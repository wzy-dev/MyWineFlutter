import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class MiddleNavigator extends StatelessWidget {
  MiddleNavigator({
    required this.navigatorKey,
    required this.tabIndex,
    required this.onItemTapped,
  });
  final GlobalKey<NavigatorState>? navigatorKey;
  final int tabIndex;
  final Function onItemTapped;

  Widget _routeBuilders(
      {required BuildContext context, required String route}) {
    switch (route) {
      case "/":
        return AddTab();
      case "/second":
        return SecondSon();
      default:
        return AddTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      heroTag: "middle",
      fabIcon: Icons.camera_rounded,
      child: Navigator(
        key: navigatorKey,
        initialRoute: '/',
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) =>
                _routeBuilders(context: context, route: routeSettings.name!),
          );
        },
      ),
      onItemTapped: onItemTapped,
      selectedIndex: tabIndex,
    );
  }
}
