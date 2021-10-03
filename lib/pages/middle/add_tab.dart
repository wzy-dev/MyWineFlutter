import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class AddTab extends StatelessWidget {
  const AddTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainContainer(
        child: InkWell(
      child: Text("AddTab"),
      onTap: () => Navigator.pushNamed(context, "/second"),
    ));
  }
}
