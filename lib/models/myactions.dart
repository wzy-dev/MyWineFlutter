import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';
import 'package:sqlbrite/sqlbrite.dart';

class MyActions {
  static void drinkWine({
    required BuildContext context,
    required Wine? wine,
    Position? position,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    if (wine == null) return;

    if (position != null) {
      position.enabled = false;

      await db.update("positions", position.toJson(),
          where: 'id = ?', whereArgs: [position.id]);
    }

    wine.quantity--;
    await db
        .update("wines", wine.toJson(), where: 'id = ?', whereArgs: [wine.id]);
  }

  static void updateWine({
    required BuildContext context,
    required Wine? wine,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    if (wine == null) return;

    await db
        .update("wines", wine.toJson(), where: 'id = ?', whereArgs: [wine.id]);
  }

  static void deletePosition({
    required BuildContext context,
    required Position? position,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    if (position == null) return;

    position.enabled = false;

    await db.update("positions", position.toJson(),
        where: 'id = ?', whereArgs: [position.id]);
  }

  static void addPosition({
    required BuildContext context,
    required Position? position,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    if (position == null) return;

    await db.insert("positions", position.toJson());
  }

  static void addWine({
    required BuildContext context,
    required Wine wine,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    await db.insert("wines", wine.toJson());
  }

  static Future<void> addDomain({
    required BuildContext context,
    required Domain domain,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    await db.insert("domains", domain.toJson());
  }

  static Future<void> addAppellation({
    required BuildContext context,
    required Appellation appellation,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    await db.insert("appellations", appellation.toJson());
  }

  static Future<void> addRegion({
    required BuildContext context,
    required Region region,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    await db.insert("regions", region.toJson());
  }

  static Future<void> addCountry({
    required BuildContext context,
    required Country country,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    await db.insert("countries", country.toJson());
  }
}
