import 'package:flutter/material.dart';
import 'package:mywine/custom/scaffold/main_container.dart';

class SecondSon extends StatelessWidget {
  const SecondSon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      title: Text("SecondSon"),
      child: InkWell(
        child: Text("Go to third"),
        onTap: () =>
            Navigator.of(context, rootNavigator: true).pushNamed("/third"),
      ),
    );
  }
}
