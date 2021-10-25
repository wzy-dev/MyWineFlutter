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
        final WineListArguments? arguments =
            settings.arguments as WineListArguments?;

        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: WineList(
              selectedRegions: arguments?.selectedRegions ?? null,
              selectedAppellations: arguments?.selectedAppellations ?? null,
              selectedColors: arguments?.selectedColors ?? null,
              selectedDomains: arguments?.selectedDomains ?? null,
              selectedSizes: arguments?.selectedSizes ?? null,
            ),
          ),
          fullscreenDialog: true,
        );
      case "/filters":
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                  body: Filters(),
                ));
      case "/filter/appellation":
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: FilterAppellation(),
          ),
          settings: settings,
        );
      case "/filter/domain":
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: FilterDomain(),
          ),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Homepage(),
          ),
        );
    }
  }
}
