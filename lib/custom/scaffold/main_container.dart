import 'package:flutter/material.dart';

class MainContainer extends StatelessWidget {
  const MainContainer({Key? key, required this.child, this.title})
      : super(key: key);

  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: [
          AppBar(title: Text(title ?? "")),
          child,
        ],
      ),
    );
  }
}
