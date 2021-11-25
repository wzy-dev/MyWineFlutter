import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class RightNavigator extends StatelessWidget {
  RightNavigator({
    required this.navigatorKey,
    required this.tabIndex,
    required this.onItemTapped,
    this.searchedWine,
  });
  final GlobalKey<NavigatorState>? navigatorKey;
  final int tabIndex;
  final Function onItemTapped;
  final Wine? searchedWine;

  Widget _routeBuilders(
      {required BuildContext context, required RouteSettings settings}) {
    switch (settings.name) {
      case "/":
        return CellarTab(searchedWine: searchedWine);
      case "/block":
        BlockTabArguments args = settings.arguments as BlockTabArguments;
        return BlockTab(
          arguments: args,
        );
      case "/edit/cellar":
        EditCellarArguments args = settings.arguments as EditCellarArguments;
        return EditCellar(cellar: args.cellar);
      case "/edit/block":
        EditBlockArguments args = settings.arguments as EditBlockArguments;
        return EditBlock(
          cellarId: args.cellarId,
          x: args.x,
          y: args.y,
          block: args.block,
        );
      default:
        return CellarTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      heroTag: "right",
      child: Navigator(
        observers: [HeroController()],
        key: navigatorKey,
        initialRoute: "/",
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) =>
                _routeBuilders(context: context, settings: routeSettings),
            settings: routeSettings,
          );
        },
      ),
      onItemTapped: onItemTapped,
      selectedIndex: tabIndex,
    );
  }
}
