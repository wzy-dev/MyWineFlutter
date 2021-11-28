import 'package:flutter/material.dart';
import 'package:mywine/pages/root/edit_wine.dart';
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
      case "/edit/wine":
        final Wine arguments = settings.arguments as Wine;

        return CustomRouteBuilders(
          widget: Scaffold(
            body: EditWine(wine: arguments),
          ),
        );
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
          widget: Scaffold(
            body: StockCellar(
              toStockWine: arguments.toStockWine,
            ),
          ),
        );
      case "/stock/block":
        StockBlockArguments? arguments =
            settings.arguments as StockBlockArguments;

        return CustomRouteBuilders(
          widget: Scaffold(
            body: StockBlock(
              arguments: arguments,
              stockAddonForCellar: arguments.stockAddonForCellar,
            ),
          ),
        );
      case "/add/wine/appellation":
        AddWineAppellationArguments? args =
            settings.arguments as AddWineAppellationArguments?;
        return CustomRouteBuilders(
          widget: Scaffold(
            body: AddWineAppellation(
              selectedRadio: args?.selectedRadio ?? null,
              addPath: args?.addPath ?? null,
            ),
          ),
        );
      case "/add/wine/domain":
        AddWineDomainArguments? args =
            settings.arguments as AddWineDomainArguments?;
        return CustomRouteBuilders(
          widget: Scaffold(
            body: AddWineDomain(
              selectedRadio: args?.selectedRadio ?? null,
              addPath: args?.addPath ?? null,
            ),
          ),
        );
      case "/add/domain":
        Domain? args = settings.arguments as Domain?;

        return CustomRouteBuilders(
          widget: Scaffold(
            body: EditDomain(domain: args),
          ),
        );
      case "/add/appellation":
        return CustomRouteBuilders(
          widget: Scaffold(
            body: AddAppellation(),
          ),
        );
      case "/add/appellation/region":
        AddAppellationRegionArguments? args =
            settings.arguments as AddAppellationRegionArguments?;
        return CustomRouteBuilders(
          widget: Scaffold(
            body: AddAppellationRegion(
              selectedRadio: args?.selectedRadio ?? null,
              addPath: args?.addPath ?? null,
            ),
          ),
        );
      case "/add/region":
        return CustomRouteBuilders(
          widget: Scaffold(
            body: AddRegion(),
          ),
        );
      case "/add/region/country":
        AddRegionCountryArguments? args =
            settings.arguments as AddRegionCountryArguments?;
        return CustomRouteBuilders(
          widget: Scaffold(
            body: AddRegionCountry(
              selectedRadio: args?.selectedRadio ?? null,
              addPath: args?.addPath ?? null,
            ),
          ),
        );
      case "/add/country":
        return CustomRouteBuilders(
          widget: Scaffold(
            body: AddCountry(),
          ),
        );
      default:
        return CustomRouteBuilders(
          widget: Homepage(),
        );
    }
  }
}
