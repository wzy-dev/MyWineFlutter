import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<int> _tabHistory = [0];

  final _navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
  };

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      // pop to first route
      _navigatorKeys[index]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      _tabHistory.removeWhere((pageIndex) => pageIndex == index);
      _tabHistory.insert(0, index);
      if (_tabHistory.length > 3) _tabHistory.removeLast();

      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool canPop = !await Navigator.maybePop(
            _navigatorKeys[_selectedIndex]!.currentState!.context);

        if (canPop) {
          if (_tabHistory.length == 1) return true;

          setState(() => _selectedIndex = _tabHistory[1]);
          _tabHistory.removeAt(0);
        }

        return false;
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildOffstageNavigator(0),
            _buildOffstageNavigator(1),
            _buildOffstageNavigator(2),
          ],
        ),
      ),
    );
  }

  Widget _renderSelectedNavigator(
      {required int index, required GlobalKey<NavigatorState>? navigatorKey}) {
    List<Widget> routes = [
      LeftNavigator(
        navigatorKey: navigatorKey,
        tabIndex: index,
        onItemTapped: _onItemTapped,
      ),
      MiddleNavigator(
        navigatorKey: navigatorKey,
        tabIndex: index,
        onItemTapped: _onItemTapped,
      ),
      RightNavigator(
        navigatorKey: navigatorKey,
        tabIndex: index,
        onItemTapped: _onItemTapped,
      ),
    ];

    return routes[index];
  }

  Widget _buildOffstageNavigator(int tabIndex) {
    return _renderSelectedNavigator(
        index: tabIndex, navigatorKey: _navigatorKeys[tabIndex]);
  }
}
