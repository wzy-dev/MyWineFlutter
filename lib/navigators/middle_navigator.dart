import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class MiddleNavigator extends StatefulWidget {
  MiddleNavigator({
    Key? key,
    required this.navigatorKey,
    required this.tabIndex,
    required this.isActive,
    required this.onItemTapped,
  });
  final GlobalKey<NavigatorState>? navigatorKey;
  final int tabIndex;
  final bool isActive;
  final Function onItemTapped;

  @override
  State<MiddleNavigator> createState() => _MiddleNavigatorState();
}

class _MiddleNavigatorState extends State<MiddleNavigator> {
  Widget _routeBuilders(
      {required BuildContext context, required RouteSettings settings}) {
    switch (settings.name) {
      case "/":
        return AddTab(isActive: widget.isActive);
      case "/add/wine":
        ResultSearchVision? args = settings.arguments as ResultSearchVision?;
        return AddWine(resultSearchVision: args);
      case "/add/wine/appellation":
        AddWineAppellationArguments? args =
            settings.arguments as AddWineAppellationArguments?;
        return AddWineAppellation(
          selectedRadio: args?.selectedRadio ?? null,
          addPath: args?.addPath ?? null,
        );
      case "/add/wine/domain":
        AddWineDomainArguments? args =
            settings.arguments as AddWineDomainArguments?;
        return AddWineDomain(
          selectedRadio: args?.selectedRadio ?? null,
          addPath: args?.addPath ?? null,
        );
      case "/add/domain":
        return AddDomain();
      case "/add/appellation":
        return AddAppellation();
      case "/add/appellation/region":
        AddAppellationRegionArguments? args =
            settings.arguments as AddAppellationRegionArguments?;
        return AddAppellationRegion(
          selectedRadio: args?.selectedRadio ?? null,
          addPath: args?.addPath ?? null,
        );
      case "/add/region":
        return AddRegion();
      case "/add/region/country":
        AddRegionCountryArguments? args =
            settings.arguments as AddRegionCountryArguments?;
        return AddRegionCountry(
          selectedRadio: args?.selectedRadio ?? null,
          addPath: args?.addPath ?? null,
        );
      case "/add/country":
        return AddCountry();
      default:
        return AddTab(isActive: widget.isActive);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      heroTag: "middle",
      fabIcon: Icons.camera_rounded,
      child: Navigator(
        key: widget.navigatorKey,
        initialRoute: "/",
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) =>
                _routeBuilders(context: context, settings: routeSettings),
          );
        },
      ),
      onItemTapped: widget.onItemTapped,
      selectedIndex: widget.tabIndex,
    );
  }
}
