import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key, required this.focusNode}) : super(key: key);

  final FocusNode focusNode;

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  int? selected;

  late List<Appellation> appellations;
  late List<Domain> domains;
  late List<Region> regions;
  late List<Country> countries;

  List results = [];

  void _onSearch(String query) {
    if (query.length < 2) {
      setState(() {
        results = [];
      });
      return;
    }
    setState(() {
      results = SearchMethods.getResults(
        query: query,
        appellations: appellations,
        domains: domains,
        regions: regions,
        countries: countries,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    appellations = MyDatabase.getAppellations(context: context);
    domains = MyDatabase.getDomains(context: context);
    regions = MyDatabase.getRegions(context: context);
    countries = MyDatabase.getCountries(context: context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: MainContainer(
        title: "MyWine",
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Recherchez dans votre cave".toUpperCase(),
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Une appellation, un domaine, une région ?",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomSearchBar(
                    onChange: _onSearch,
                    focusNode: widget.focusNode,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                padding: const EdgeInsets.all(0),
                children: _drawResults(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _drawResults(BuildContext context) {
    List<Widget> _listResults = [];

    results
        .map(
          (r) => _listResults.add(
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: Material(
                color: Colors.transparent,
                child: (r.item["cat"] == "appellation" &&
                        r.item["entity"].length > 1
                    ? ExpansionTile(
                        backgroundColor: Color.fromRGBO(255, 255, 255, 0.8),
                        tilePadding: const EdgeInsets.symmetric(horizontal: 20),
                        childrenPadding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                        title: Text(
                          r.item["nameWithSpace"].toUpperCase(),
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              CustomMethods.getCatName(r.item["cat"]),
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            Text(
                              " (plusieurs couleurs)",
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ],
                        ),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: r.item["entity"].map<Widget>((a) {
                              Map<String, Color> _colorScheme =
                                  CustomMethods.getColorRgbaByIndex(a.color);
                              return ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          _colorScheme["color"]!),
                                ),
                                child: Text(
                                  CustomMethods.getColorLabelByIndex(a.color),
                                  style: TextStyle(
                                      color: _colorScheme["contrasted"]!),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      )
                    : InkWell(
                        onTap: () {},
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          title: Text(
                            r.item["nameWithSpace"].toUpperCase(),
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                CustomMethods.getCatName(r.item["cat"]),
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              if (r.item["cat"] == "appellation")
                                Text(
                                  " (${CustomMethods.getColorLabelByIndex(r.item["entity"][0].color).toLowerCase()})",
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                            ],
                          ),
                        ),
                      )),
              ),
            ),
          ),
        )
        .toList();

    // results
    //     .map(
    //       (r) =>
    //     )
    //     .toList();

    _listResults.add(
      SizedBox(
        height: 60,
      ),
    );
    return _listResults;
  }
}
