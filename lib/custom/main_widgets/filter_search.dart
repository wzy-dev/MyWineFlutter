import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

class FilterSearch extends StatefulWidget {
  const FilterSearch({
    Key? key,
    required this.placeholder,
    required this.type,
    this.submitLabel = "Appliquer",
    this.multiple = true,
    this.initialSelection = const [],
    this.appellationsData = const [],
    this.domainsData = const [],
    this.regionsData = const [],
    this.countriesData = const [],
    this.addPath,
  }) : super(key: key);

  final String placeholder;
  final String type;
  final String submitLabel;
  final bool multiple;
  final List<String> initialSelection;
  final List<Appellation> appellationsData;
  final List<Domain> domainsData;
  final List<Region> regionsData;
  final List<Country> countriesData;
  final String? addPath;

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
  late String? _activeLetter;

  late List<Appellation> _sortedAppellationsData;
  late List<Domain> _sortedDomainsData;
  late List<Region> _sortedRegionsData;
  late List<Country> _sortedCountriesData;

  // If multiple
  late List<String> _selectedList;

  // If not multiple;
  String? _selectedRadio;

  int _sortFunction(a, b) => CustomMethods.removeAccent(a.name.toLowerCase())
      .compareTo(CustomMethods.removeAccent(b.name.toLowerCase()));

  dynamic _getArgumentsToEdit(String itemId) {
    switch (widget.type) {
      case "appellation":
        return MyDatabase.getAppellationById(
          context: context,
          appellationId: itemId,
          listen: false,
        );
      case "region":
        return MyDatabase.getRegionById(
          context: context,
          regionId: itemId,
          listen: false,
        );
      case "country":
        return MyDatabase.getCountryById(
          context: context,
          countryId: itemId,
          listen: false,
        );
      case "domain":
        return MyDatabase.getDomainById(
          context: context,
          domainId: itemId,
          listen: false,
        );
    }
    return;
  }

  Widget _drawPopupMenu(dynamic item) {
    return (item["owner"] != null && item["owner"] != "admin"
        ? widget.addPath != null
            ? PopupMenuButton(
                itemBuilder: (contextg) => [
                  PopupMenuItem(
                    onTap: () => Future(
                      () async {
                        String? name = await Navigator.of(context).pushNamed(
                                widget.addPath!,
                                arguments: _getArgumentsToEdit(item["id"]))
                            as String?;

                        if (name == null) return;

                        setState(() {
                          if (_selectedRadio == item["name"])
                            _selectedRadio = name;
                          item["name"] = name;
                        });
                      },
                    ),
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).hintColor,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.construction_outlined,
                          color: Theme.of(context).hintColor,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Modifier".toUpperCase(),
                        ),
                      ],
                    ),
                  ),
                  _showDeleteItem(item["id"]),
                ],
                icon: Icon(Icons.more_vert_outlined),
              )
            : Container()
        : Container());
  }

  PopupMenuItem _showDeleteItem(String id) {
    late int wineQuantity;
    switch (widget.type) {
      case "appellation":
        wineQuantity = MyDatabase.getQuantityOfAppellation(
            context: context, appellationId: id);
        break;
      case "region":
        wineQuantity =
            MyDatabase.getQuantityOfRegion(context: context, regionId: id);
        break;
      case "country":
        wineQuantity =
            MyDatabase.getQuantityOfCountry(context: context, countryId: id);
        break;
      case "domain":
        wineQuantity =
            MyDatabase.getQuantityOfDomain(context: context, domainId: id);
        break;
      default:
        return PopupMenuItem(
          child: Container(),
        );
    }

    return PopupMenuItem(
      enabled: wineQuantity == 0,
      onTap: wineQuantity == 0 ? () => print("retirer") : null,
      textStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Row(
        children: [
          Icon(
            Icons.delete_outline,
            color: wineQuantity == 0
                ? Theme.of(context).colorScheme.secondary
                : Colors.black87,
          ),
          SizedBox(width: 5),
          Text(
            "Supprimer".toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          wineQuantity > 0
              ? Text(
                  " ($wineQuantity bouteilles)",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic),
                )
              : Text(""),
        ],
      ),
    );
  }

  @override
  void initState() {
    _sortedAppellationsData = List<Appellation>.from(widget.appellationsData);
    _sortedAppellationsData.sort((a, b) => _sortFunction(a, b));

    _sortedDomainsData = List<Domain>.from(widget.domainsData);
    _sortedDomainsData.sort((a, b) => _sortFunction(a, b));

    _sortedRegionsData = List<Region>.from(widget.regionsData);
    _sortedRegionsData.sort((a, b) => _sortFunction(a, b));

    _sortedCountriesData = List<Country>.from(widget.countriesData);
    _sortedCountriesData.sort((a, b) => _sortFunction(a, b));

    _data = [
      ..._sortedAppellationsData,
      ..._sortedDomainsData,
      ..._sortedRegionsData,
      ..._sortedCountriesData,
    ];

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
      int index = scrollListChildren.indexWhere((object) =>
          CustomMethods.removeAccent(object["name"].toLowerCase()[0]) ==
          letter);

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
      _activeLetter = usedLetter.length > 0 ? usedLetter[0] : null;
      _scrollListChildren = scrollListChildren;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 30,
                  ),
                  child: CustomTextField(
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
                        regions: widget.regionsData,
                        countries: widget.countriesData,
                      ).forEach((result) =>
                          resultsList.add(result.item["entity"][0]));

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
                        labelTextBuilder: _activeLetter != null
                            ? (double offset) => Text(
                                  _activeLetter!.toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                )
                            : null,
                        controller: _scrollController,
                        child: ListView.separated(
                          separatorBuilder: (BuildContext context, int i) =>
                              Divider(
                            height: 1,
                          ),
                          padding: const EdgeInsets.only(bottom: 100),
                          controller: _scrollController,
                          itemCount: _scrollListChildren.length,
                          itemBuilder: (BuildContext context, int i) =>
                              Container(
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
                                          value: _selectedList.indexWhere(
                                                      (id) =>
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
                                                    _scrollListChildren[i]
                                                        ["id"]);
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
                                          title: GestureDetector(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(_scrollListChildren[i]
                                                    ["name"]),
                                                _drawPopupMenu(
                                                    _scrollListChildren[i]),
                                              ],
                                            ),
                                          ),
                                          value: _scrollListChildren[i]["name"],
                                          onChanged: (dynamic value) =>
                                              setState(
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
              child: Row(
                children: [
                  widget.addPath != null
                      ? ElevatedButton(
                          onPressed: widget.addPath != null
                              ? () async {
                                  String? name = await Navigator.of(context,
                                          rootNavigator: true)
                                      .pushNamed(widget.addPath!) as String?;

                                  if (name != null)
                                    Navigator.of(context).pop(name);
                                }
                              : null,
                          child: Icon(Icons.add_outlined),
                          style: ButtonStyle(
                            minimumSize:
                                MaterialStateProperty.all<Size>(Size(0, 0)),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(8),
                            ),
                            alignment: Alignment.centerLeft,
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).hintColor,
                            ),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    width: 5,
                  ),
                  CustomElevatedButton(
                    icon: Icon(Icons.save_outlined),
                    title: widget.submitLabel,
                    dense: true,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    onPress: () => Navigator.of(context)
                        .pop(widget.multiple ? _selectedList : _selectedRadio),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
