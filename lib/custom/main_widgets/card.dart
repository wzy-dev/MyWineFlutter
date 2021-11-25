import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key? key,
    required this.child,
    this.margin = const EdgeInsets.all(4),
    this.backgroundColor,
  }) : super(key: key);

  final Widget? child;
  final EdgeInsets margin;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      clipBehavior: Clip.hardEdge,
      margin: margin,
      elevation: 4,
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

class TextInputCard extends StatefulWidget {
  const TextInputCard(
      {Key? key, required this.label, required this.onChanged, this.value})
      : super(key: key);

  final String label;
  final Function(String) onChanged;
  final String? value;

  @override
  State<TextInputCard> createState() => _TextInputCardState();
}

class _TextInputCardState extends State<TextInputCard> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController(text: widget.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _controller,
              onChanged: (value) => widget.onChanged(value),
              cursorColor: Theme.of(context).hintColor,
              style:
                  Theme.of(context).textTheme.headline4!.copyWith(fontSize: 17),
              decoration: InputDecoration(
                hintText: widget.label,
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
