import 'package:flutter/material.dart';
import 'package:mywine/custom/forms/edit_appellation.dart';
import 'package:mywine/custom/forms/edit_country.dart';
import 'package:mywine/custom/forms/edit_region.dart';
import 'package:mywine/custom/forms/edit_wine.dart';
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
    // required bool isLogged,
    // required void Function(bool) updateLogged,
  }) {
    CustomRouteBuilders customRouteBuilders =
        _routeBuilders(context: context, settings: settings);
    return MaterialPageRoute(
        builder: (context) => Landing(
              child: customRouteBuilders.widget,
              // isLogged: isLogged,
              // updateLogged: updateLogged,
            ),
        fullscreenDialog: customRouteBuilders.fullScreen);
  }

  static CustomRouteBuilders _routeBuilders(
      {required BuildContext context, required RouteSettings settings}) {
    switch (settings.name ?? null) {
      case "/search":
        return CustomRouteBuilders(widget: Homepage());
      case "/account":
        return CustomRouteBuilders(widget: Scaffold(body: Account()));
      case "/add":
        return CustomRouteBuilders(
            widget: Homepage(
          initialIndex: 1,
        ));
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
        Appellation? args = settings.arguments as Appellation?;

        return CustomRouteBuilders(
          widget: Scaffold(
            body: EditAppellation(
              appellation: args,
            ),
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
        Region? args = settings.arguments as Region?;

        return CustomRouteBuilders(
          widget: Scaffold(
            body: EditRegion(
              region: args,
            ),
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
        Country? args = settings.arguments as Country?;

        return CustomRouteBuilders(
          widget: Scaffold(
            body: EditCountry(country: args),
          ),
        );
      default:
        return CustomRouteBuilders(
          widget: Homepage(),
        );
    }
  }
}
