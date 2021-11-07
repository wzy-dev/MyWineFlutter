import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

class FilterSearch extends StatefulWidget {
  const FilterSearch({
    Key? key,
    required this.placeholder,
    this.submitLabel = "Appliquer",
    this.multiple = true,
    this.initialSelection = const [],
    this.appellationsData = const [],
    this.domainsData = const [],
  }) : super(key: key);

  final String placeholder;
  final String submitLabel;
  final bool multiple;
  final List<String> initialSelection;
  final List<Appellation> appellationsData;
  final List<Domain> domainsData;

  @override
  _FilterSearchState createState() => _FilterSearchState();
}

class _FilterSearchState extends State<FilterSearch> {
  late List<dynamic> _scrollListChildren;
  late List<dynamic> _data;
  double _childHeight = 50;
  final ScrollController _scrollController = ScrollController();
  final List<String> _alphabet = [
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "p",
    "q",
    "r",
    "s",
    "t",
    "u",
    "v",
    "w",
    "x",
    "y",
    "z"
  ];
  List<String> _usedLetter = [];
  Map<String, int> _alphabetPosition = {};
  late String _activeLetter;

  // If multiple
  late List<String> _selectedList;

  // If not multiple;
  dynamic _selectedRadio;

  @override
  void initState() {
    _data = [...widget.appellationsData, ...widget.domainsData];
    // Evite que le state du filter_search.dart influence filters.dart
    _selectedList = List<String>.from(widget.initialSelection);
    _selectedRadio =
        widget.initialSelection.length > 0 ? widget.initialSelection[0] : null;
    _drawChildrenList(_data);

    super.initState();
  }

  _drawChildrenList(List<dynamic> dataList) {
    Map<String, int> alphabetPosition = {};
    List<String> usedLetter = [];
    List<dynamic> scrollListChildren = dataList.map((e) => e.toJson()).toList();

    _alphabet.forEach((letter) {
      int index = scrollListChildren
          .indexWhere((object) => object["name"].toLowerCase()[0] == letter);

      if (index > -1) {
        alphabetPosition[letter] = index;
        usedLetter.add(letter);
        scrollListChildren.insert(index, {"name": letter.toUpperCase()});
      }
    });

    // Si un symbole ou un chiffre en premier
    if (scrollListChildren.length > 0 && scrollListChildren[0]["id"] != null) {
      alphabetPosition["#"] = 0;
      usedLetter.insert(0, "#");
      scrollListChildren.insert(0, {"name": "#"});
    }

    setState(() {
      _alphabetPosition = alphabetPosition;
      _usedLetter = usedLetter;
      _activeLetter = usedLetter[0];
      _scrollListChildren = scrollListChildren;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 30,
                ),
                child: CustomSearchBar(
                  context: context,
                  autofocus: true,
                  onChange: (query) {
                    if (query == "") {
                      _drawChildrenList(_data);
                      return;
                    }

                    List<dynamic> resultsList = [];
                    SearchMethods.getResults(
                      query: query,
                      appellations: widget.appellationsData,
                      domains: widget.domainsData,
                      regions: [],
                      countries: [],
                    ).forEach(
                        (result) => resultsList.add(result.item["entity"][0]));

                    _drawChildrenList(resultsList);
                  },
                  placeholder: widget.placeholder,
                ),
              ),
              Expanded(
                child: NotificationListener<ScrollUpdateNotification>(
                  onNotification: (notification) {
                    double position = notification.metrics.pixels;
                    for (int i = 0; i < _usedLetter.length; i++) {
                      String letter = _usedLetter[i];
                      String? nextLetter;
                      if (i + 1 < _usedLetter.length)
                        nextLetter = _usedLetter[i + 1];

                      if (position >
                              _alphabetPosition[letter]! * _childHeight &&
                          nextLetter != null &&
                          _alphabetPosition[nextLetter] != null) {
                        setState(() {
                          _activeLetter = letter;
                        });
                      }
                    }

                    return true;
                  },
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    removeBottom: true,
                    child: DraggableScrollbar.arrows(
                      alwaysVisibleScrollThumb: true,
                      backgroundColor: Theme.of(context).hintColor,
                      heightScrollThumb: 60,
                      labelTextBuilder: (double offset) => Text(
                        _activeLetter.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      controller: _scrollController,
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int i) =>
                            Divider(
                          height: 1,
                        ),
                        padding: const EdgeInsets.only(bottom: 100),
                        controller: _scrollController,
                        itemCount: _scrollListChildren.length,
                        itemBuilder: (BuildContext context, int i) => Container(
                          color: _scrollListChildren[i]["id"] != null
                              ? null
                              : Colors.white,
                          height: _childHeight,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _scrollListChildren[i]["id"] != null
                                ? widget.multiple
                                    ? CheckboxListTile(
                                        dense: true,
                                        activeColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        title: Text(
                                            _scrollListChildren[i]["name"]),
                                        value: _selectedList.indexWhere((id) =>
                                                    id ==
                                                    _scrollListChildren[i]
                                                        ["id"]) >
                                                -1
                                            ? true
                                            : false,
                                        onChanged: (bool? enabled) {
                                          int indexWhere =
                                              _selectedList.indexWhere((id) =>
                                                  id ==
                                                  _scrollListChildren[i]["id"]);
                                          setState(
                                            () {
                                              indexWhere == -1
                                                  ? _selectedList.add(
                                                      _scrollListChildren[i]
                                                          ["id"])
                                                  : _selectedList
                                                      .removeAt(indexWhere);
                                            },
                                          );
                                        },
                                      )
                                    : RadioListTile<dynamic>(
                                        groupValue: _selectedRadio,
                                        dense: true,
                                        activeColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        title: Text(
                                            _scrollListChildren[i]["name"]),
                                        value: _scrollListChildren[i]["name"],
                                        onChanged: (dynamic value) => setState(
                                          () {
                                            _selectedRadio = value;
                                          },
                                        ),
                                      )
                                : Padding(
                                    padding: const EdgeInsets.only(left: 29),
                                    child: Text(
                                      _scrollListChildren[i]["name"],
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: CustomElevatedButton(
              icon: Icon(Icons.save_outlined),
              title: widget.submitLabel,
              dense: true,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              onPress: () => Navigator.of(context)
                  .pop(widget.multiple ? _selectedList : _selectedRadio),
            ),
          ),
        ],
      ),
    );
  }
}
