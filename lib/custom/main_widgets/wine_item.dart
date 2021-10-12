import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class WineItem extends StatelessWidget {
  const WineItem({
    Key? key,
    required this.enhancedWine,
    this.freeQuantity,
    this.expandable = false,
  }) : super(key: key);

  final Map<String, dynamic> enhancedWine;
  final int? freeQuantity;
  final bool expandable;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.all(0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          bottomLeft: Radius.circular(5),
          topRight: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      color: Colors.white,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 10,
              color: CustomMethods.getColorRgbaByIndex(
                  enhancedWine["appellation"]["color"])["color"],
            ),
            expandable
                ? Expanded(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: _drawTitle(context),
                        subtitle: _drawSubTitle(context),
                        tilePadding: const EdgeInsets.fromLTRB(10, 8, 10, 15),
                        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7),
                            child: CustomElevatedButton(
                              title: "Text",
                              icon: Icon(Icons.info_outline),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    child: Material(
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 8, 10, 15),
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).pushNamed(
                            "/wine",
                            arguments: WineDetailsArguments(
                              wineId: enhancedWine["id"],
                              fullScreenDialog: (expandable ? true : false),
                            ),
                          );
                        },
                        tileColor: Colors.white,
                        title: _drawTitle(context),
                        subtitle: _drawSubTitle(context),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Column _drawSubTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          enhancedWine["appellation"]["name"],
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(height: 5),
        // Badge(value: freeQuantity ?? enhancedWine["quantity"]),
        Text("567"),
      ],
    );
  }

  Text _drawTitle(BuildContext context) {
    return Text(
      "${enhancedWine["domain"].name.toUpperCase()} ${enhancedWine["millesime"]}",
      style: Theme.of(context).textTheme.headline2,
    );
  }
}
