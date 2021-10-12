import 'package:flutter/material.dart';
import 'package:mywine/pages/root/wine_list.dart';

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
        final WineDetailsArguments arguments =
            settings.arguments as WineDetailsArguments;

        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: WineDetails(),
          ),
          fullscreenDialog: arguments.fullScreenDialog,
          settings: settings,
        );
      case "/winelist":
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: WineList(),
          ),
          fullscreenDialog: true,
        );
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
