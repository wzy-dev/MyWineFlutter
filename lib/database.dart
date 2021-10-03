import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:sqlbrite/sqlbrite.dart';

class MyDatabase {
  static BriteDatabase getBriteDatabase({required BuildContext context}) {
    return Provider.of<BriteDatabase>(context, listen: false);
  }

  static List<Cellar> getCellars({required BuildContext context}) {
    return Provider.of<List<Cellar>>(context);
  }

  static List<Block> getBlocks({required BuildContext context}) {
    return Provider.of<List<Block>>(context);
  }

  static List<Position> getPositions({required BuildContext context}) {
    return Provider.of<List<Position>>(context);
  }

  static List<Position> getPositionsByBlockId(
      {required BuildContext context, required String blockId}) {
    return getPositions(context: context)
        .where((position) => position.block == blockId)
        .toList();
  }

  static List<Wine> getWines({required BuildContext context}) {
    return Provider.of<List<Wine>>(context, listen: false);
  }

  static Wine? getWineById(
      {required BuildContext context, required String wineId}) {
    return getWines(context: context)
        .firstWhereOrNull((wine) => wine.id == wineId);
  }

  static Map<String, dynamic>? getEnhancedWineById(
      {required BuildContext context, required String wineId}) {
    Wine? wine = getWineById(context: context, wineId: wineId);

    if (wine == null) return null;

    Map<String, dynamic> enhancedWine = wine.toJson();

    Appellation? appellation = getAppellationById(
      context: context,
      appellationId: enhancedWine["appellation"],
    );

    if (appellation == null) return null;

    enhancedWine["appellation"] = appellation;

    return enhancedWine;
  }

  static List<Appellation> getAppellations({required BuildContext context}) {
    return Provider.of<List<Appellation>>(context, listen: false);
  }

  static Appellation? getAppellationById(
      {required BuildContext context, required String appellationId}) {
    return getAppellations(context: context)
        .firstWhereOrNull((appellation) => appellation.id == appellationId);
  }

  static List<Map<String, Object>> getFreeWines(
      {required BuildContext context}) {
    List<Wine> wines = getWines(context: context);
    List<Position> positions = getPositions(context: context);
    List<Map<String, Object>> listOfFreeWines = [];

    wines.forEach((Wine wine) {
      int freeQuantity = wine.quantity -
          positions.where((position) => position.wine == wine.id).length;
      if (freeQuantity > 0)
        listOfFreeWines.add({"wine": wine, "freeQuantity": freeQuantity});
    });
    return listOfFreeWines;
  }

  static int countFreeWines({required BuildContext context}) {
    int totalFreeWines = 0;
    getFreeWines(context: context)
        .forEach((map) => totalFreeWines += map["freeQuantity"] as int);
    return totalFreeWines;
  }

  static Future<void> addWine(
      {required BuildContext context, required Wine wine}) {
    BriteDatabase _briteDb = getBriteDatabase(context: context);
    return _briteDb.insert(
      'wines',
      wine.toJson(),
    );
  }

  static Map<String, dynamic>? getEnhancedWineByPosition({
    required BuildContext context,
    required String block,
    required int x,
    required int y,
  }) {
    List<Position> positions = getPositions(context: context);
    Position? position = positions.firstWhereOrNull(
      (element) => element.y == y && element.x == x && element.block == block,
    );

    if (position == null) return null;

    Map<String, dynamic>? wine =
        getEnhancedWineById(context: context, wineId: position.wine);

    return wine;
  }

  static String? getColorByPosition(
      {required BuildContext context,
      required String block,
      required int x,
      required int y}) {
    List<Position> positions = getPositions(context: context);
    Position? position = positions.firstWhereOrNull(
      (element) => element.y == y && element.x == x && element.block == block,
    );

    if (position == null) return null;

    List<Appellation> appellations = getAppellations(context: context);

    List<Wine> wines = getWines(context: context);

    Wine? wine = wines.firstWhereOrNull((wine) => wine.id == position.wine);

    if (wine == null) return null;

    Appellation? appellation = appellations
        .firstWhereOrNull((appellation) => appellation.id == wine.appellation);

    if (appellation == null) return null;

    return appellation.color;
  }
}
