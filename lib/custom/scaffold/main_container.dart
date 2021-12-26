import 'package:flutter/material.dart';

class MainContainer extends StatelessWidget {
  const MainContainer(
      {Key? key,
      required this.child,
      this.hideAppBar = false,
      this.title,
      this.backgroundColor,
      this.action})
      : super(key: key);

  final Widget child;
  final bool hideAppBar;
  final Widget? title;
  final Color? backgroundColor;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final AppBar _appBar = AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      title: title ?? Text(""),
      actions: [action ?? Container()],
    );
    final double _heightAppBar = _appBar.preferredSize.height;

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: EdgeInsets.only(
            top: (!hideAppBar
                ? _heightAppBar + MediaQuery.of(context).padding.top
                : 0),
          ),
          color: backgroundColor != null
              ? backgroundColor
              : Theme.of(context).backgroundColor,
          child: child,
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: (!hideAppBar ? _appBar : Container()),
        ),
      ],
    );
  }
}
