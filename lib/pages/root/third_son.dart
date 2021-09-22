import 'package:flutter/material.dart';
import 'package:mywine/custom/scaffold/main_container.dart';

class ThirdSon extends StatelessWidget {
  const ThirdSon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      title: "ThirdSon",
      child: Text("I'm the third"),
    );
  }
}
