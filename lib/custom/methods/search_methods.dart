// ignore: import_of_legacy_library_into_null_safe
import 'package:fuzzy/data/fuzzy_options.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:fuzzy/data/result.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:fuzzy/fuzzy.dart';
import 'package:mywine/shelf.dart';

class SearchMethods {
  static String _removeUselessSpace(String string) {
    if (string.length == 0) return string;

    String firstCharacter = string.substring(0, 1);
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

  static String _removeAccent(String string) {
    var withDia =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      string = string.replaceAll(withDia[i], withoutDia[i]);
    }

    return string;
  }

  // Biais quand appellation contient château
  // static String _removeWord(
  //     {required String string, required String wordToRemove}) {
  //   final FuzzyOptions options = FuzzyOptions(threshold: 0.3);

  //   final Fuzzy fuse = Fuzzy([string], options: options);

  //   List<Result<dynamic>> search = fuse.search(wordToRemove);
  //   Map<String, int> location = {"dif": 0, "l": 0, "m": 0};

  //   if (search.length == 0) return string;

  //   search[0].matches[0].matchedIndices.forEach((i) {
  //     if (i.end - i.start > location["dif"]!) {
  //       location["dif"] = i.end - i.start;
  //       location["l"] = i.start;
  //       location["m"] = i.end;
  //     }
  //   });

  //   String rectifiedWordToRemove = search[0]
  //       .matches[0]
  //       .value
  //       .substring(location["l"]!, location["m"]! + 1);

  //   return search[0].matches[0].value.replaceAll(rectifiedWordToRemove, '');
  // }

  static String _genererateSlug(String string) {
    String result;

    result = string.replaceAll("-", " ");
    result = _removeAccent(result);
    result = _removeUselessSpace(result);
    result = result.toLowerCase();

    return result;
  }

  static List<Result> getResults({
    required String query,
    List<Region> regions = const [],
    List<Country> countries = const [],
    List<Domain> domains = const [],
    List<Appellation> appellations = const [],
  }) {
    if (query.length == 0) return [];
    List searchs = [];
    int id = 0;

    regions.forEach((Region r) {
      searchs.add({
        "slug": _genererateSlug(r.name),
        "name": r.name,
        "nameWithSpace": r.name.replaceAll("-", ' '),
        "entity": [r],
        "id": id.toString(),
        "cat": 'region',
      });
      id++;
    });

    appellations.forEach((Appellation a) {
      String slug = _genererateSlug(a.name);
      int whereIndex = searchs
          .indexWhere((s) => s["slug"] == slug && s["cat"] == 'appellation');
      if (whereIndex != -1) {
        searchs[whereIndex]["entity"].add(a);
        searchs[whereIndex]["multiple"] = true;
        return;
      }
      searchs.add({
        "slug": slug,
        "name": a.name,
        "label": a.label,
        "nameWithSpace": a.name.replaceAll("-", " "),
        "entity": [a],
        "id": id.toString(),
        "cat": 'appellation',
      });
      id++;
    });

    domains.forEach((d) {
      String slug = _genererateSlug(d.name);
      searchs.add({
        "slug": slug,
        "name": d.name,
        "nameWithSpace": d.name.replaceAll("-", " "),
        "entity": [d],
        "id": id.toString(),
        "cat": 'domain'
      });
      id++;
    });

    countries.forEach((c) {
      searchs.add({
        "slug": _genererateSlug(c.name),
        "name": c.name,
        "nameWithSpace": c.name.replaceAll("-", " "),
        "entity": [c],
        "id": id.toString(),
        "cat": 'country'
      });
      id++;
    });

    // if (data.varieties) {
    //   data.varieties.map(v => {
    //     searchs.push({ slug: removeSpace(removeAccent(v.name.replace(/-/g, ' '))).toLowerCase(), name: v.name, nameWithSpace: v.name.replace(/-/g, ' '), entity: [v], id: id.toString(), cat: 'variety' })
    //     id++
    //   })
    // }

    // const options = {
    //   // isCaseSensitive: false,
    //   includeScore: true,
    //   // shouldSort: true,
    //   // includeMatches: true,
    //   // findAllMatches: false,
    //   minMatchCharLength: (customOptions && customOptions.minMatchCharLength ? customOptions.minMatchCharLength : 1),
    //   // location: 0,
    //   threshold: (customOptions && customOptions.threshold ? customOptions.threshold : 0.4),
    //   distance: 0,
    //   // useExtendedSearch: false,
    //   ignoreLocation: (customOptions && customOptions.ignoreLocation ? customOptions.ignoreLocation : false),
    //   // ignoreFieldNorm: false,
    //   keys: [
    //     "slug",
    //   ]
    // }

    final FuzzyOptions options =
        FuzzyOptions(minMatchCharLength: 1, threshold: 0.2, distance: 0, keys: [
      WeightedKey(
        name: "slug",
        getter: (e) {
          return (e as Map)["slug"];
        },
        weight: 1,
      )
    ]);

    // if (customOptions && customOptions.levenshtein) {
    //   let results = []
    //   searchs.map(s => {
    //     let maxLength = q.length > s.slug.length ? q.length : s.slug.length,
    //       score = levenshtein(removeSpace(removeAccent(q.replace(/-/g, ' '))).toLowerCase(), s.slug) / maxLength
    //     if (score < options.threshold) results.push({ ...s, score: score, searched: q.toLowerCase(), levenshtein: score * maxLength })
    //   })
    //   return results
    // }

    final Fuzzy fuse = Fuzzy(searchs, options: options);

    return fuse.search(_genererateSlug(query));
  }
}
