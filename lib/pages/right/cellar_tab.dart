import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mywine/pages/right/shelf_right.dart';
import 'package:mywine/shelf.dart';
import 'package:provider/provider.dart';
import 'package:sqlbrite/sqlbrite.dart';

class CellarTab extends StatefulWidget {
  const CellarTab({Key? key}) : super(key: key);

  @override
  _CellarTabState createState() => _CellarTabState();
}

class _CellarTabState extends State<CellarTab> {
  ShaderMask _shaderMask({required Widget child}) {
    return ShaderMask(
      shaderCallback: (Rect rect) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.white,
            Colors.white,
            Color.fromRGBO(0, 0, 0, 0.5),
            Color.fromRGBO(0, 0, 0, 0),
            Color.fromRGBO(0, 0, 0, 0),
            Color.fromRGBO(0, 0, 0, 0.5),
            Colors.white,
            Colors.white
          ],
          stops: [0.0, 0.01, 0.03, 0.05, 0.95, 0.97, 0.99, 1.0],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: child,
    );
  }

  Widget _drawCellar({required List<Cellar> snapshot}) {
    return Container(
      child: Column(
        children: snapshot
            .map(
              (cellar) => Column(
                children: [
                  ScrollConfiguration(
                    behavior: ScrollBehavior(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: DrawCellar(cellarId: cellar.id),
                      ),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cellars = Provider.of<List<Cellar>>(context);

    BriteDatabase briteDb = Provider.of<BriteDatabase>(context, listen: false);

    return MainContainer(
      title: "Mes caves",
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: ShadowBox(
                child: _shaderMask(
                  child: AnimatedSize(
                    duration: Duration(milliseconds: 500),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                      child: _drawCellar(
                        snapshot: cellars,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.red,
              child: InkWell(
                child: Text("Go to"),
                // onTap: () => Navigator.pushNamed(context, "/second"),
                onTap: () async {
                  await briteDb.insert(
                    'wine',
                    Wine(
                      id: "2id",
                      appellation: "appellation",
                      createdAt: 2,
                      editedAt: 2,
                      enabled: true,
                    ).toJson(),
                  );
                  // print(await briteDb.query("wine"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
