import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mywine/shelf.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key, required this.focusNode}) : super(key: key);

  final FocusNode focusNode;

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  late List<Appellation> _appellations;
  late List<Domain> _domains;
  late List<Region> _regions;
  late List<Country> _countries;
  List _results = [];

  void _onSearch(String query) {
    if (query.length < 2) {
      setState(() {
        _results = [];
      });
      return;
    }
    setState(() {
      _results = SearchMethods.getResults(
        query: query,
        appellations: _appellations,
        domains: _domains,
        regions: _regions,
        countries: _countries,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _appellations = MyDatabase.getAppellations(context: context, listen: false);
    _domains = MyDatabase.getDomainsWithStock(context: context, listen: false);
    _regions = MyDatabase.getRegionsWithStock(context: context, listen: false);
    _countries =
        MyDatabase.getCountriesWithStock(context: context, listen: false);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: MainContainer(
        title: SvgPicture.asset(
          "assets/svg/logo.svg",
          width: 110,
        ),
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
                    context: context,
                    onChange: _onSearch,
                    focusNode: widget.focusNode,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
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

    _results.map(
      (r) {
        Map<String, int> _quantity = {};
        int _totalQuantity = 0;
        switch (r.item["cat"]) {
          case "appellation":
            r.item["entity"].forEach((appellation) {
              final int stock = MyDatabase.getQuantityOfAppellation(
                  context: context, appellationId: appellation.id);
              _quantity[appellation.id] = stock;
              _totalQuantity += stock;
            });
            break;
          case "domain":
            Domain domain = r.item["entity"][0];
            final int stock = MyDatabase.getQuantityOfDomain(
                context: context, domainId: domain.id);
            _quantity[domain.id] = stock;
            _totalQuantity += stock;
            break;
          case "region":
            Region region = r.item["entity"][0];
            final int stock = MyDatabase.getQuantityOfRegion(
                context: context, regionId: region.id);
            _quantity[region.id] = stock;
            _totalQuantity += stock;
            break;
          case "country":
            Country country = r.item["entity"][0];
            final int stock = MyDatabase.getQuantityOfCountry(
                context: context, countryId: country.id);
            _quantity[country.id] = stock;
            _totalQuantity += stock;
            break;
          default:
            _quantity = {};
        }

        _listResults.add(
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
                      title: Row(
                        children: [
                          Text(
                            "${r.item["nameWithSpace"].toUpperCase()} ",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          _totalQuantity > 0
                              ? Badge(value: _totalQuantity)
                              : Container(),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            CustomMethods.getCatName(r.item["cat"])
                                .toLowerCase(),
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          Text(
                            " / plusieurs couleurs",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ],
                      ),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: r.item["entity"].map<Widget>((a) {
                            Map<String, dynamic> _colorScheme =
                                CustomMethods.getColorByIndex(a.color);

                            return ElevatedButton(
                              onPressed: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pushNamed(
                                "/winelist",
                                arguments: WineListArguments(
                                  selectedAppellations: [a],
                                  selectedColors: [
                                    ColorBottle(
                                        value: a.color,
                                        name: CustomMethods.getColorByIndex(
                                            a.color)["name"])
                                  ],
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        _colorScheme["color"]!),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "${CustomMethods.getColorByIndex(a.color)["name"].toUpperCase()} ",
                                    style: TextStyle(
                                        color: _colorScheme["contrasted"]!),
                                  ),
                                  _quantity[a.id]! > 0
                                      ? Badge(
                                          value: _quantity[a.id]!,
                                          mini: true,
                                          color: _colorScheme["contrasted"],
                                        )
                                      : Container(),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    )
                  : InkWell(
                      onTap: () =>
                          Navigator.of(context, rootNavigator: true).pushNamed(
                        "/winelist",
                        arguments: WineListArguments(
                          selectedRegions: r.item["cat"] == "region"
                              ? r.item["entity"]
                              : null,
                          selectedAppellations: r.item["cat"] == "appellation"
                              ? r.item["entity"]
                              : null,
                          selectedDomains: r.item["cat"] == "domain"
                              ? r.item["entity"]
                              : null,
                        ),
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        title: Row(
                          children: [
                            Text(
                              "${r.item["nameWithSpace"].toUpperCase()} ",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            _totalQuantity > 0
                                ? Badge(value: _totalQuantity)
                                : Container(),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              CustomMethods.getCatName(r.item["cat"])
                                  .toLowerCase(),
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            if (r.item["cat"] == "appellation")
                              Text(
                                " / ${CustomMethods.getColorByIndex(r.item["entity"][0].color)["name"].toLowerCase()}",
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                          ],
                        ),
                      ),
                    )),
            ),
          ),
        );
      },
    ).toList();

    _listResults.add(
      SizedBox(
        height: 60,
      ),
    );
    return _listResults;
  }
}
