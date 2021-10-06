import 'package:flutter/material.dart';

import '../shelf.dart';

class RootNavigator {
  static MaterialPageRoute onGenerateRoute(
      {required BuildContext context, required RouteSettings settings}) {
    switch (settings.name ?? null) {
      case "/":
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                  body: Homepage(),
                ));
      case "/wine":
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                  body: WineDetails(),
                ),
            fullscreenDialog: true,
            settings: settings);
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
}
