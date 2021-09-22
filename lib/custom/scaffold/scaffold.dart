import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    Key? key,
    required this.child,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.heroTag,
    this.fabIcon,
  }) : super(key: key);

  static const double heightNavBar = 50;
  static const double iconSize = 27;

  final Widget child;
  final int selectedIndex;
  final Function onItemTapped;
  final String heroTag;
  final IconData? fabIcon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Pour que la navigation surchappe la page
      extendBody: true,

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          // Cacher quand clavier ouvert
          (true == true
              ? AnimatedContainer(
                  duration: ((MediaQuery.of(context).viewInsets.bottom == 0.0)
                      ? Duration(milliseconds: 150)
                      : Duration(milliseconds: 0)),
                  width: (MediaQuery.of(context).viewInsets.bottom == 0.0)
                      ? 65
                      : 0,
                  // height: (MediaQuery.of(context).viewInsets.bottom == 0.0)
                  //     ? 65
                  //     : 0,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Material(
                    elevation: 3,
                    shape: CircleBorder(),
                    child: AnimatedGradient(
                      // Container(
                      //   decoration: BoxDecoration(
                      //     shape: BoxShape.circle,
                      //     gradient: LinearGradient(
                      //         begin: Alignment.topLeft,
                      //         end: Alignment.bottomRight,
                      //         colors: [
                      //           Color.fromRGBO(7, 93, 143, 1),
                      //           Color.fromRGBO(7, 93, 143, 1),
                      //           Color.fromRGBO(219, 61, 77, 1),
                      //         ],
                      //         stops: [
                      //           0,
                      //           0.15,
                      //           1
                      //         ]),
                      //   ),
                      child: FloatingActionButton(
                        clipBehavior: Clip.hardEdge,
                        heroTag: heroTag,
                        mini: true,
                        elevation: 0,
                        splashColor: Color.fromRGBO(219, 84, 97, 0.26),
                        focusElevation: 1,
                        backgroundColor: Colors.transparent,
                        child: Icon(
                          fabIcon != null ? fabIcon : Icons.add_rounded,
                          color: Colors.white,
                          size: 35,
                        ),
                        onPressed: () => onItemTapped(1),
                      ),
                    ),
                  ),
                )
              : Container()),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.elliptical(30, 30),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.elliptical(30, 30),
          ),
          child: Stack(
            children: [
              BottomAppBar(
                color: Colors.white,
                elevation: 2,
                shape: CircularNotchedRectangle(),
                notchMargin: 6,
                child: Container(
                  height: heightNavBar,
                ),
              ),
              Container(
                height: heightNavBar,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          CurrentTabIndicator(
                            isActive: selectedIndex == 0,
                            key: UniqueKey(),
                          ),
                          Container(
                            height: heightNavBar,
                            child: IconButton(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 0),
                              splashColor: Color.fromRGBO(219, 84, 97, 0.26),
                              highlightColor: Color.fromRGBO(219, 84, 97, 0.1),
                              icon: Padding(
                                padding: const EdgeInsets.only(left: 3),
                                child: Icon(
                                  Icons.search_outlined,
                                ),
                              ),
                              color: (selectedIndex == 0
                                  ? Theme.of(context).primaryColor
                                  : Color.fromRGBO(138, 162, 158, 1)),
                              iconSize: iconSize,
                              onPressed: () => onItemTapped(0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: Stack(alignment: Alignment.topCenter, children: [
                        CurrentTabIndicator(
                          isActive: selectedIndex == 2,
                          key: UniqueKey(),
                        ),
                        Container(
                          height: heightNavBar,
                          child: IconButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 0),
                            splashColor: Color.fromRGBO(219, 84, 97, 0.26),
                            highlightColor: Color.fromRGBO(219, 84, 97, 0.1),
                            icon: Container(
                              child: Icon(
                                Icons.wine_bar_outlined,
                              ),
                            ),
                            color: (selectedIndex == 2
                                ? Theme.of(context).primaryColor
                                : Color.fromRGBO(138, 162, 158, 1)),
                            iconSize: iconSize,
                            onPressed: () => onItemTapped(2),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: child,
    );
  }
}

class CurrentTabIndicator extends StatefulWidget {
  const CurrentTabIndicator({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  final bool isActive;

  @override
  _CurrentTabIndicatorState createState() => _CurrentTabIndicatorState();
}

class _CurrentTabIndicatorState extends State<CurrentTabIndicator> {
  late double _size;

  @override
  void initState() {
    _size = 0;

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        _size = widget.isActive ? 50 : 0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      height: 3,
      width: _size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
          color: Theme.of(context).primaryColor),
    );
  }
}
