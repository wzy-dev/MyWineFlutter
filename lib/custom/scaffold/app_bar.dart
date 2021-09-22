import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  static roundedAppBar(
      {String? title, required BuildContext context, bool backButton = false}) {
    return AppBar(
      leading: (backButton
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )
          : null),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      title: (title != null
          ? Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.w300,
                  fontSize: 17,
                ),
              ),
            )
          : Container()),
      centerTitle: false,
    );
  }
}
