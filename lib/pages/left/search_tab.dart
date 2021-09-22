import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class SearchTab extends StatelessWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainContainer(
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
            CustomSearchBar(),
            // InkWell(
            //   child: Text("Go to"),
            //   onTap: () => Navigator.of(context, rootNavigator: true)
            //       .pushNamed("/second"),
            // ),
          ],
        ),
      ),
    );
  }
}
