import 'package:flutter/material.dart';
import 'package:mywine/custom/main_widgets/card.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar(
      {Key? key, required this.onChange, required this.focusNode})
      : super(key: key);

  final FocusNode focusNode;
  final Function onChange;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.all(0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: TextField(
                focusNode: focusNode,
                onChanged: (value) => onChange(value),
                cursorColor: Theme.of(context).primaryColor,
                style: TextStyle(color: Colors.grey.shade800, fontSize: 15),
                decoration: InputDecoration(
                  hintText: "bourgogne, saint-émilion...",
                  hintStyle:
                      TextStyle(color: Colors.grey.shade500, fontSize: 15),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 20),
                ),
              ),
            ),
            Container(
              color: Theme.of(context).hintColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Icon(
                  Icons.search_outlined,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
