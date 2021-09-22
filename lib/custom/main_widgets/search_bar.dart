import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 5),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                child: TextField(
                  cursorColor: Theme.of(context).primaryColor,
                  style: TextStyle(color: Colors.grey.shade800),
                  decoration: InputDecoration(
                    hintText: "bourgogne, saint-émilion...",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 20),
                  ),
                ),
              ),
            ),
            Container(
              color: Theme.of(context).primaryColor,
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
