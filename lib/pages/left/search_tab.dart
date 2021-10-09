import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
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
        child: Padding(
          padding: const EdgeInsets.all(20),
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
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: results
                    .map(
                      (r) => Text(
                          "${r.item["nameWithSpace"]} (${r.item["cat"]}) ${r.item["cat"] == "appellation" ? r.item["entity"].map((a) => a.color) : ""}"),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
