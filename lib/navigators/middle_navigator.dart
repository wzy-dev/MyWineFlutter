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
        );
      case "/add/wine/domain":
        AddWineDomainArguments? args =
            settings.arguments as AddWineDomainArguments?;
        return AddWineDomain(
          selectedRadio: args?.selectedRadio ?? null,
        );
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
