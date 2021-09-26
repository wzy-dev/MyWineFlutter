import 'package:flutter/material.dart';

class AnimatedGradient extends StatefulWidget {
  AnimatedGradient({required this.child});

  final Widget child;

  @override
  _AnimatedGradientState createState() => _AnimatedGradientState();
}

class _AnimatedGradientState extends State<AnimatedGradient> {
  List<Color> colorList = [
    Color.fromRGBO(9, 118, 181, 1),
    Color.fromRGBO(219, 84, 97, 1),
    Color.fromRGBO(9, 118, 181, 1),
    Color.fromRGBO(219, 84, 97, 1),
    Color.fromRGBO(9, 118, 181, 1),
  ];

  int index = 0;

  late Color bottomColor;
  late Color topColor;

  Alignment begin = Alignment.bottomRight;
  Alignment end = Alignment.topLeft;

  @override
  void initState() {
    bottomColor = colorList[0];
    topColor = colorList[1];

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // setState(() {
      //   bottomColor = colorList[3];
      // });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 5),
      onEnd: () {
        setState(() {
          index = index + 1;

          // animate the color
          bottomColor = colorList[index % colorList.length];
          topColor = colorList[(index + 1) % colorList.length];

          //// animate the alignment
          // begin = alignmentList[index % alignmentList.length];
          // end = alignmentList[(index + 2) % alignmentList.length];
        });
      },
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: [bottomColor, topColor],
        ),
      ),
      child: widget.child,
    );
  }
}
