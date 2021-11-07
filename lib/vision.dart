// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/cupertino.dart';
import 'package:fuzzy/data/fuzzy_options.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:fuzzy/data/result.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:fuzzy/fuzzy.dart';
import 'package:googleapis/vision/v1.dart' as vision;
import 'package:mywine/shelf.dart';

class LocalSearchVision {
  LocalSearchVision({this.dif = 0, this.l = 0, this.m = 0});
  int dif;
  int l;
  int m;
}

class ResultSearchVision {
  ResultSearchVision(
      {required this.appellations, this.domain, required this.millesime});
  final List<Appellation> appellations;
  Domain? domain;
  int millesime;
}

class Vision {
  static String slice({required String subject, int start = 0, int? end}) {
    if (subject is! String) {
      return '';
    }

    int _realEnd;
    int _realStart = start < 0 ? subject.length + start : start;
    if (end is! int) {
      _realEnd = subject.length;
    } else {
      _realEnd = end < 0 ? subject.length + end : end;
    }

    return subject.substring(_realStart, _realEnd);
  }

  static String _removeWord(
      {required String string, required String word, String? direction}) {
    final options = FuzzyOptions(threshold: 0.3);

    final Fuzzy fuse = Fuzzy([string], options: options);

    String? result;

    List<Result<dynamic>> searchs = fuse.search(word);

    LocalSearchVision local = LocalSearchVision();

    if (searchs.length > 0) {
      Result<dynamic> search = searchs[0];

      search.matches[0].matchedIndices.map((i) => {
            if (i.end - i.start > local.dif)
              {
                local.dif = i.end - i.start,
                local.l = i.start,
                local.m = i.end,
              }
          });

      if (direction == 'left') {
        //Left
        //  result = slice(subject:search.matches[0].value, start:0, end:local.m+1);
        result = search.matches[0].value.substring(0, local.m + 1);
      } else if (direction == 'right') {
        //Right
        // result = slice(subject:search.matches[0].value, start:local.l, end:string.length);
        result = search.matches[0].value.substring(local.l, string.length);
      } else {
        //Just the word
        // result = slice(subject:search.matches[0].value, start:local.l, end:local.m+1);
        result = search.matches[0].value.substring(local.l, local.m + 1);
      }

      result = search.matches[0].value.replaceAll(string, '');

      //Suppression des espaces au début et à la fin
      result = _removeUselessSpace(result);
    }

    return result ?? string;
  }

  static String _removeUselessSpace(String string) {
    if (string.length == 0) return string;

    String firstCharacter = string[0];
    String lastCharacter = string.substring(string.length - 1);
    String result = string;
    if (firstCharacter == ' ' || firstCharacter == '-') {
      result = string.substring(1);
    }
    if (lastCharacter == ' ' || lastCharacter == '-') {
      result = string.substring(0, string.length - 1);
    }
    return result;
  }

  static _processAppellation(String l) {
    String result = l;
    print("1 $result");
    //Suppression des nombres
    result = result.replaceAll(RegExp("\d+"), "");
    print("2 $result");
    //Mise en minuscule
    result = result.toLowerCase();
    print("3 $result");
    //Suppression des espaces au début et à la fin
    result = _removeUselessSpace(l);
    result = _removeUselessSpace(l);
    //Isolation "Appellation {app} controlée"
    result =
        _removeWord(string: result, word: 'appellation', direction: 'left');
    result = _removeWord(string: result, word: 'controlee', direction: 'right');
    result = _removeWord(string: result, word: 'protegee', direction: 'right');
    print("4 $result");
    return result;
  }

  static _processDomain(String l) {
    String result = l;

    result = _removeWord(string: result, word: 'château');
    return result;
  }

  static _processMillesime(String l) {
    String result = l;
    //Recherche du millesime
    RegExp re = RegExp("^-?[1-9]\d*");

    if (re.hasMatch(result)) {
      return int.parse(result.replaceAll(RegExp("/\D/g"), ""));
    } else {
      return null;
    }
  }

  static ResultSearchVision? _setResultAppellation(
      {required List<Map<dynamic, dynamic>> resultsAppellation,
      required List<Map<dynamic, dynamic>> resultsDomain,
      int? millesime}) {
    if (resultsAppellation.length == 0) {
      return null;
    } else {
      List<Appellation> appellations;
      Domain? domain;
      if ((resultsAppellation[0]["slug"] == 'bordeaux' ||
              resultsAppellation[0]["slug"] == 'alsace') &&
          resultsAppellation[1]["score"] < 0.2) {
        if (resultsAppellation[0]["slug"] != resultsAppellation[1]["slug"]) {
          appellations = resultsAppellation[1]["entity"];
        } else if (resultsAppellation.length > 2 &&
            resultsAppellation[2]["score"] < 0.2) {
          appellations = resultsAppellation[2]["entity"];
        } else {
          appellations = resultsAppellation[0]["entity"];
        }
      } else {
        appellations = resultsAppellation[0]["entity"];
      }

      if (resultsDomain.length > 0) {
        domain = resultsDomain[0]["entity"][0];
      }

      return ResultSearchVision(
          appellations: appellations,
          domain: domain,
          millesime: millesime ?? DateTime.now().year - 1);
    }
  }

  static ResultSearchVision? takePicture({
    required BuildContext context,
    required List<vision.EntityAnnotation> ocr,
  }) {
    List<String> arrayTextAppellation = [];
    List<String> arrayTextDomain = [];
    int? millesime;

    RegExp re = RegExp("(?:\r\n|\r|\n)");

    ocr.forEach((block) {
      String? line = block.description?.replaceAll(re, " ") ?? "";
      // String line = block.description ?? "";

      millesime = (_processMillesime(line) != null
          ? _processMillesime(line)
          : millesime);

      arrayTextAppellation.add(_processAppellation(line));
      arrayTextDomain.add(_processDomain(line));
    });
    List<Map<dynamic, dynamic>> resultsAppellation = [];
    List<Map<dynamic, dynamic>> resultsDomain = [];

    arrayTextAppellation.forEach((l) {
      SearchMethods.getResults(
              query: l,
              appellations:
                  MyDatabase.getAppellations(context: context, listen: false),
              threshold: 0.2,
              levenshtein: true)
          .forEach((item) => resultsAppellation.add(item));
    });
    resultsAppellation.sort((a, b) => a["score"].compareTo(b["score"]));

    //Analyse du domaine
    arrayTextDomain.forEach((l) {
      SearchMethods.getResults(
              query: l,
              domains: MyDatabase.getDomains(context: context, listen: false),
              threshold: 0.2,
              levenshtein: true)
          .forEach((item) => resultsDomain.add(item));
    });
    resultsDomain.sort((a, b) => a["score"].compareTo(b["score"]));

    //Analyse du domaine
    if (resultsDomain.length > 0) {
      // return
    } else {
      resultsDomain = [];
      arrayTextDomain = [];
      ocr.forEach((block) {
        List<String> lines = block.description!.split(RegExp("\n"));

        lines.forEach((l) {
          arrayTextDomain.add(_processDomain(l));
        });
      });

      arrayTextDomain.forEach((l) {
        SearchMethods.getResults(
                query: l,
                domains: MyDatabase.getDomains(context: context, listen: false),
                levenshtein: true,
                threshold: 0.3,
                removeWord: "château")
            .forEach((item) => resultsDomain.add(item));
      });
      resultsDomain.sort((a, b) => a["score"].compareTo(b["score"]));
    }

    // //Analyse de l'appellation
    // if (resultsAppellation.length > 0 &&
    //     (resultsAppellation[0]["slug"] != 'bordeaux' &&
    //         resultsAppellation[0]["slug"] != 'alsace') &&
    //     resultsAppellation[0]["score"] < 0.0001) {
    // } else {
    //   resultsAppellation=[], arrayTextAppellation=[]
    //   processed.blocks.forEach(block => {
    //     let lines = block.text.split("\n")

    //     lines.map(l => {
    //       arrayTextAppellation.push(this._processAppellation(l))
    //     })
    //   })

    //   arrayTextAppellation.map(l => {
    //     getResults(l, {appellations:this.props.appellations}, {levenshtein:true,threshold:0.3}).map(item => resultsAppellation.push(item))
    //     // getResults(l, {appellations:this.props.appellations}, {minMatchCharLength:2,threshold:0.1,ignoreLocation:false}).map(item => resultsAppellation.push({...item.item, score:item.score}))
    //   })
    //   resultsAppellation = sort(resultsAppellation,'score')

    //   this._setResultAppellation(resultsAppellation, resultsDomain, millesime)
    // }
    return _setResultAppellation(
        resultsAppellation: resultsAppellation,
        resultsDomain: resultsDomain,
        millesime: millesime);
  }
}
