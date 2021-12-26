import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key? key,
    required this.child,
    this.margin = const EdgeInsets.all(4),
    this.backgroundColor,
    this.elevation,
  }) : super(key: key);

  final Widget? child;
  final EdgeInsets margin;
  final Color? backgroundColor;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      clipBehavior: Clip.hardEdge,
      margin: margin,
      elevation: elevation ?? 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(),
        child: child,
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  const ActionCard({
    Key? key,
    required this.enhancedWine,
    required this.leftWidget,
    required this.listActions,
    this.margin = const EdgeInsets.only(bottom: 5, top: 5),
  }) : super(key: key);

  final Map<String, dynamic> enhancedWine;
  final Widget leftWidget;
  final List<Widget> listActions;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: margin,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  leftWidget,
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${enhancedWine["domain"].name.toUpperCase()} ${enhancedWine["millesime"]}",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          SizedBox(height: 8),
                          Text(
                            enhancedWine["appellation"]["name"],
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...listActions.map((action) => action).toList(),
          ],
        ),
      ),
    );
  }
}
