import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class CustomRouteBuilders {
  CustomRouteBuilders({required this.widget, this.fullScreen = false});

  final Widget widget;
  final bool fullScreen;
}

class RootNavigator {
  static MaterialPageRoute onGenerateRoute({
    required BuildContext context,
    required RouteSettings settings,
  }) {
    CustomRouteBuilders customRouteBuilders =
        _routeBuilders(context: context, settings: settings);
    return MaterialPageRoute(
        builder: (context) => Landing(child: customRouteBuilders.widget),
        fullscreenDialog: customRouteBuilders.fullScreen);
  }

  static CustomRouteBuilders _routeBuilders(
      {required BuildContext context, required RouteSettings settings}) {
    switch (settings.name ?? null) {
      case "/search":
        return CustomRouteBuilders(widget: Homepage());
      case "/cellar":
        CellarTabArguments? arguments =
            settings.arguments as CellarTabArguments?;

        return CustomRouteBuilders(
            widget: Homepage(
                initialIndex: 2,
                searchedWine: arguments?.searchedWine ?? null));
      case "/wine":
        final WineDetailsArguments arguments =
            settings.arguments as WineDetailsArguments;

        return CustomRouteBuilders(
            widget: Scaffold(
              body: WineDetails(wineDetails: arguments),
            ),
            fullScreen: arguments.fullScreenDialog);
      case "/appellation":
        final AppellationDetailsArguments arguments =
            settings.arguments as AppellationDetailsArguments;

        return CustomRouteBuilders(
            widget: Scaffold(
              body: AppellationDetails(appellationDetails: arguments),
            ),
            fullScreen: arguments.fullScreenDialog);
      case "/wine/list":
        final WineListArguments? selectedFilters =
            settings.arguments as WineListArguments?;

        return CustomRouteBuilders(
            widget: Scaffold(
              body: WineList(selectedFilters: selectedFilters),
            ),
            fullScreen: true);
      case "/filters":
        final WineListArguments? selectedFilters =
            settings.arguments as WineListArguments?;

        return CustomRouteBuilders(
          widget: Scaffold(
            body: Filters(selectedFilters: selectedFilters),
          ),
        );
      case "/filter/appellation":
        final FilterAppellationArguments filterAppellationArguments =
            settings.arguments as FilterAppellationArguments;

        return CustomRouteBuilders(
          widget: Scaffold(
            body: FilterAppellation(
                filterAppellationArguments: filterAppellationArguments),
          ),
        );
      case "/filter/domain":
        final FilterDomainArguments filterDomainArguments =
            settings.arguments as FilterDomainArguments;

        return CustomRouteBuilders(
          widget: Scaffold(
            body: FilterDomain(filterDomainArguments: filterDomainArguments),
          ),
        );
      case "/stock/cellar":
        StockCellarArguments? arguments =
            settings.arguments as StockCellarArguments;

        return CustomRouteBuilders(
          widget: StockCellar(
            toStockWine: arguments.toStockWine,
          ),
        );
      case "/stock/block":
        StockBlockArguments? arguments =
            settings.arguments as StockBlockArguments;

        return CustomRouteBuilders(
          widget: StockBlock(
            arguments: arguments,
            stockAddonForCellar: arguments.stockAddonForCellar,
          ),
        );
      default:
        return CustomRouteBuilders(
          widget: Homepage(),
        );
    }
  }
}
