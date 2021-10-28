import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    Key? key,
    required this.child,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.heroTag,
    this.fabIcon,
  }) : super(key: key);

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

      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton:
      //     // Cacher quand clavier ouvert
      //     (true == true
      //         ? Padding(
      //             padding: const EdgeInsets.fromLTRB(0, 22, 0, 0),
      //             child: Material(
      //               elevation: 3,
      //               shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.all(Radius.circular(15.0))),
      //               clipBehavior: Clip.hardEdge,
      //               child: AnimatedContainer(
      //                 duration:
      //                     ((MediaQuery.of(context).viewInsets.bottom == 0.0)
      //                         ? Duration(milliseconds: 50)
      //                         : Duration(milliseconds: 0)),
      //                 width: (MediaQuery.of(context).viewInsets.bottom == 0.0)
      //                     ? 48
      //                     : 0,
      //                 height: (MediaQuery.of(context).viewInsets.bottom == 0.0)
      //                     ? 48
      //                     : 0,
      //                 child: AnimatedGradient(
      //                   child: FloatingActionButton(
      //                     shape: RoundedRectangleBorder(
      //                         borderRadius:
      //                             BorderRadius.all(Radius.circular(15.0))),
      //                     heroTag: heroTag,
      //                     mini: true,
      //                     splashColor: Color.fromRGBO(219, 84, 97, 0.26),
      //                     focusElevation: 0,
      //                     hoverElevation: 0,
      //                     highlightElevation: 0,
      //                     elevation: 0,
      //                     backgroundColor: Colors.transparent,
      //                     child: Icon(
      //                       fabIcon != null ? fabIcon : Icons.add_rounded,
      //                       color: Colors.white,
      //                       size: 40,
      //                     ),
      //                     onPressed: () => onItemTapped(1),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           )
      //         : Container()),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    margin: const EdgeInsets.only(top: 9),
                    child: IconButton(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 0),
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
                          : Theme.of(context).colorScheme.primaryVariant),
                      iconSize: iconSize,
                      onPressed: () => onItemTapped(0),
                    ),
                  ),
                ],
              ),
            ),
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color.fromRGBO(219, 84, 97, 1),
                    Color.fromRGBO(9, 118, 181, 1)
                  ],
                  tileMode: TileMode.mirror,
                ).createShader(bounds);
              },
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: selectedIndex == 1
                      ? Color.fromRGBO(219, 84, 97, 0.15)
                      : null,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(width: 3, color: Colors.white),
                ),
                child: Material(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(),
                  child: InkWell(
                    onTap: () => onItemTapped(1),
                    splashColor: Color.fromRGBO(219, 84, 97, 0.26),
                    highlightColor: Color.fromRGBO(219, 84, 97, 0.1),
                    child: Icon(
                      Icons.add_rounded,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                ),
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
                  margin: const EdgeInsets.only(top: 9),
                  child: IconButton(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                    splashColor: Color.fromRGBO(219, 84, 97, 0.26),
                    highlightColor: Color.fromRGBO(219, 84, 97, 0.1),
                    icon: Container(
                      child: Icon(
                        Icons.wine_bar_outlined,
                      ),
                    ),
                    color: (selectedIndex == 2
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).colorScheme.primaryVariant),
                    iconSize: iconSize,
                    onPressed: () => onItemTapped(2),
                  ),
                ),
              ]),
            ),
          ],
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
