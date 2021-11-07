import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class RootNavigator {
  static MaterialPageRoute onGenerateRoute(
      {required BuildContext context, required RouteSettings settings}) {
    switch (settings.name ?? null) {
      case "/search":
        return MaterialPageRoute(
          builder: (context) => Homepage(),
        );
      case "/cellar":
        CellarTabArguments? arguments =
            settings.arguments as CellarTabArguments?;

        return MaterialPageRoute(
          builder: (context) => Homepage(
              initialIndex: 2, searchedWine: arguments?.searchedWine ?? null),
        );
      case "/wine":
        final WineDetailsArguments arguments =
            settings.arguments as WineDetailsArguments;

        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: WineDetails(wineDetails: arguments),
          ),
          fullscreenDialog: arguments.fullScreenDialog,
          settings: settings,
        );
      case "/appellation":
        final AppellationDetailsArguments arguments =
            settings.arguments as AppellationDetailsArguments;

        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: AppellationDetails(appellationDetails: arguments),
          ),
          fullscreenDialog: arguments.fullScreenDialog,
          settings: settings,
        );
      case "/wine/list":
        final WineListArguments? selectedFilters =
            settings.arguments as WineListArguments?;

        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: WineList(selectedFilters: selectedFilters),
          ),
          fullscreenDialog: true,
        );
      case "/filters":
        final WineListArguments? selectedFilters =
            settings.arguments as WineListArguments?;

        return MaterialPageRoute(
            builder: (context) => Scaffold(
                  body: Filters(selectedFilters: selectedFilters),
                ));
      case "/filter/appellation":
        final FilterAppellationArguments filterAppellationArguments =
            settings.arguments as FilterAppellationArguments;

        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: FilterAppellation(
                filterAppellationArguments: filterAppellationArguments),
          ),
        );
      case "/filter/domain":
        final FilterDomainArguments filterDomainArguments =
            settings.arguments as FilterDomainArguments;

        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: FilterDomain(filterDomainArguments: filterDomainArguments),
          ),
          settings: settings,
        );
      case "/stock/cellar":
        StockCellarArguments? arguments =
            settings.arguments as StockCellarArguments;

        return MaterialPageRoute(
          builder: (context) => StockCellar(
            toStockWine: arguments.toStockWine,
          ),
        );
      case "/stock/block":
        StockBlockArguments? arguments =
            settings.arguments as StockBlockArguments;

        return MaterialPageRoute(
          builder: (context) => StockBlock(
            arguments: arguments,
            stockAddonForCellar: arguments.stockAddonForCellar,
          ),
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
