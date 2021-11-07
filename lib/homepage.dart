import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key, this.initialIndex = 0, this.searchedWine})
      : super(key: key);

  final int initialIndex;
  final Wine? searchedWine;

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late List<int> _tabHistory;
  // late FocusNode searchFieldFocusNode;

  late int _selectedIndex;

  @override
  void initState() {
    _tabHistory = [0];
    if (widget.initialIndex != 0) _tabHistory.insert(0, widget.initialIndex);
    _selectedIndex = widget.initialIndex;
    // searchFieldFocusNode = FocusNode();
    super.initState();
  }

  final _navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
  };

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      // searchFieldFocusNode.unfocus();
      // Si on touche le tab actif on revient à la route initiale
      // if (_selectedIndex == 0)
      // _navigatorKeys[index]!.currentState!.maybePop().then(
      //     (value) => value ? null : searchFieldFocusNode.requestFocus());
      _navigatorKeys[index]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      // Changer de tab
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
        // focusNode: searchFieldFocusNode,
      ),
      MiddleNavigator(
        navigatorKey: navigatorKey,
        tabIndex: index,
        isActive: _selectedIndex == 1 ? true : false,
        onItemTapped: _onItemTapped,
      ),
      RightNavigator(
        navigatorKey: navigatorKey,
        tabIndex: index,
        onItemTapped: _onItemTapped,
        searchedWine: widget.searchedWine,
      ),
    ];

    return routes[index];
  }

  Widget _buildOffstageNavigator(int tabIndex) {
    return _renderSelectedNavigator(
        index: tabIndex, navigatorKey: _navigatorKeys[tabIndex]);
  }
}
