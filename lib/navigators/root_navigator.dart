import 'package:flutter/material.dart';

import '../shelf.dart';

class RootNavigator {
  static MaterialPageRoute onGenerateRoute(
      {required BuildContext context, required String route}) {
    switch (route) {
      case "/":
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                  body: Homepage(),
                ));
      case "/second":
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                  body: SecondSon(),
                ),
            fullscreenDialog: true);
      case "/third":
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                  body: ThirdSon(),
                ));
      default:
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                  body: Homepage(),
                ));
    }
  }
  // static Map<String, Function> _routes = {
  //   '/': (context) => Homepage(),
  //   '/second': (context) => SecondSon(),
  //   '/third': (context) => SecondSon(),
  // };

  // static onGenerateRoute(routeSettings) {
  //   //RootNavigator
  //   return MaterialPageRoute(
  //     builder: (context) => Scaffold(
  //         body: ,
  //   );
  // }
}
