import 'package:flutter/material.dart';

class AnimatedGradient extends StatefulWidget {
  AnimatedGradient({required this.child});

  final Widget child;

  @override
  _AnimatedGradientState createState() => _AnimatedGradientState();
}

class _AnimatedGradientState extends State<AnimatedGradient> {
  late Color bottomColor;
  late Color middleColor;
  late Color topColor;

  final double minValue = 0.4;
  final double maxValue = 0.6;

  double middlePosition = 0.4;

  @override
  void initState() {
    bottomColor = Color.fromRGBO(219, 84, 97, 1);
    middleColor = Color.fromRGBO(122, 100, 136, 1);
    topColor = Color.fromRGBO(9, 118, 181, 1);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        middlePosition = maxValue;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 5),
      onEnd: () {
        setState(() {
          if (middlePosition == minValue) {
            middlePosition = maxValue;
          } else if (middlePosition == maxValue) {
            middlePosition = minValue;
          }
        });
      },
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0, middlePosition, 1],
          colors: [bottomColor, middleColor, topColor],
        ),
      ),
      child: widget.child,
    );
  }
}
