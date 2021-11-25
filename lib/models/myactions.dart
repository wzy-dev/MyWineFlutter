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
      position.editedAt = InitializerModel.getTimestamp();
      position.enabled = false;

      await db.update("positions", position.toJson(),
          where: 'id = ?', whereArgs: [position.id]);
    }

    wine.editedAt = InitializerModel.getTimestamp();
    wine.quantity--;
    await db
        .update("wines", wine.toJson(), where: 'id = ?', whereArgs: [wine.id]);
  }

  static Future<void> updateWine({
    required BuildContext context,
    required Wine? wine,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    if (wine == null) return;

    wine.editedAt = InitializerModel.getTimestamp();
    wine.enabled = true;

    await db
        .update("wines", wine.toJson(), where: 'id = ?', whereArgs: [wine.id]);
  }

  static Future<void> deletePosition({
    required BuildContext context,
    required Position? position,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    if (position == null) return;

    position.editedAt = InitializerModel.getTimestamp();
    position.enabled = false;

    await db.update("positions", position.toJson(),
        where: 'id = ?', whereArgs: [position.id]);
  }

  static Future<void> addPosition({
    required BuildContext context,
    required Position? position,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    if (position == null) return;

    await db.insert("positions", position.toJson());
  }

  static Future<void> addWine({
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

  static Future<void> addCellar({
    required BuildContext context,
    required Cellar cellar,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    await db.insert("cellars", cellar.toJson());
  }

  static Future<void> editCellar({
    required BuildContext context,
    required Cellar cellar,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    cellar.editedAt = InitializerModel.getTimestamp();

    await db.update("cellars", cellar.toJson(),
        where: 'id = ?', whereArgs: [cellar.id]);
  }

  static Future<void> deleteCellar({
    required BuildContext context,
    required Cellar cellar,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    cellar.editedAt = InitializerModel.getTimestamp();
    cellar.enabled = false;

    await db.update("cellars", cellar.toJson(),
        where: 'id = ?', whereArgs: [cellar.id]);
  }

  static Future<void> addBlock({
    required BuildContext context,
    required Block block,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    await db.insert("blocks", block.toJson());
  }

  static Future<void> editBlock({
    required BuildContext context,
    required Block block,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    block.editedAt = InitializerModel.getTimestamp();

    await db.update("blocks", block.toJson(),
        where: 'id = ?', whereArgs: [block.id]);
  }

  static Future<void> deleteBlock({
    required BuildContext context,
    required Block block,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    block.editedAt = InitializerModel.getTimestamp();
    block.enabled = false;

    await db.update("blocks", block.toJson(),
        where: 'id = ?', whereArgs: [block.id]);
  }
}
