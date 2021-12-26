import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';
import 'package:sqlbrite/sqlbrite.dart';

class MyActions {
  static void _updateFirestore<T>(
      {required BuildContext context, required T object, bool isNew = false}) {
    late dynamic typeObject;
    late String tableName;

    switch (T) {
      case Wine:
        typeObject = object as Wine;
        tableName = "wines";
        break;
      case Domain:
        typeObject = object as Domain;
        tableName = "domains";
        break;
      case Appellation:
        typeObject = object as Appellation;
        tableName = "appellations";
        break;
      case Region:
        typeObject = object as Region;
        tableName = "regions";
        break;
      case Country:
        typeObject = object as Country;
        tableName = "countries";
        break;
      case Cellar:
        typeObject = object as Cellar;
        tableName = "cellars";
        break;
      case Block:
        typeObject = object as Block;
        tableName = "cellars/${typeObject.cellar}/blocks";
        break;
      case Position:
        typeObject = object as Position;
        Block? block = MyDatabase.getBlockById(
            context: context, blockId: typeObject.block, listen: false);
        block != null
            ? tableName =
                "cellars/${block.cellar}/blocks/${typeObject.block}/positions"
            : tableName = "";
        break;
      default:
        return;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null || user.isAnonymous) return;

    if (isNew) {
      Map<String, dynamic> mapObject = typeObject.toJsonWithBool();
      mapObject["owner"] = user.uid;

      FirebaseFirestore.instance
          .collection(tableName)
          .doc(typeObject.id)
          .set(mapObject)
          .then((value) => print("updated"))
          .onError((error, stackTrace) => print(error));
    } else {
      FirebaseFirestore.instance
          .collection(tableName)
          .doc(typeObject.id)
          .update(typeObject.toJsonWithBool())
          .then((value) => print("updated"))
          .onError((error, stackTrace) => print(error));
    }
  }

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
          where: 'id = ?',
          whereArgs: [
            position.id
          ]).then((value) =>
          _updateFirestore<Position>(context: context, object: position));
    }

    wine.editedAt = InitializerModel.getTimestamp();
    wine.quantity--;
    await db.update("wines", wine.toJson(), where: 'id = ?', whereArgs: [
      wine.id
    ]).then((value) => _updateFirestore<Wine>(context: context, object: wine));
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

    await db.update("wines", wine.toJson(), where: 'id = ?', whereArgs: [
      wine.id
    ]).then((value) => _updateFirestore<Wine>(context: context, object: wine));
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
        where: 'id = ?',
        whereArgs: [
          position.id
        ]).then((value) =>
        _updateFirestore<Position>(context: context, object: position));
  }

  static Future<void> addPosition({
    required BuildContext context,
    required Position? position,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    if (position == null) return;

    await db.insert("positions", position.toJson()).then((value) =>
        _updateFirestore<Position>(
            context: context, object: position, isNew: true));
  }

  static Future<void> addWine({
    required BuildContext context,
    required Wine wine,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    await db.insert("wines", wine.toJson()).then((value) =>
        _updateFirestore<Wine>(context: context, object: wine, isNew: true));
  }

  static Future<void> addDomain({
    required BuildContext context,
    required Domain domain,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    await db.insert("domains", domain.toJson()).then((value) =>
        _updateFirestore<Domain>(
            context: context, object: domain, isNew: true));
  }

  static Future<void> deleteDomain({
    required BuildContext context,
    required Domain? domain,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    if (domain == null) return;

    domain.editedAt = InitializerModel.getTimestamp();
    domain.enabled = false;

    await db.update("domains", domain.toJson(), where: 'id = ?', whereArgs: [
      domain.id
    ]).then(
        (value) => _updateFirestore<Domain>(context: context, object: domain));
  }

  static Future<void> updateDomain({
    required BuildContext context,
    required Domain? domain,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    if (domain == null) return;

    domain.editedAt = InitializerModel.getTimestamp();
    domain.enabled = true;

    await db.update("domains", domain.toJson(), where: 'id = ?', whereArgs: [
      domain.id
    ]).then(
        (value) => _updateFirestore<Domain>(context: context, object: domain));
  }

  static Future<void> addAppellation({
    required BuildContext context,
    required Appellation appellation,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    await db.insert("appellations", appellation.toJson()).then((value) =>
        _updateFirestore<Appellation>(
            context: context, object: appellation, isNew: true));
  }

  static Future<void> deleteAppellation({
    required BuildContext context,
    required Appellation? appellation,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    if (appellation == null) return;

    appellation.editedAt = InitializerModel.getTimestamp();
    appellation.enabled = false;

    await db.update("appellations", appellation.toJson(),
        where: 'id = ?',
        whereArgs: [
          appellation.id
        ]).then((value) =>
        _updateFirestore<Appellation>(context: context, object: appellation));
  }

  static Future<void> updateAppellation({
    required BuildContext context,
    required Appellation? appellation,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    if (appellation == null) return;

    appellation.editedAt = InitializerModel.getTimestamp();
    appellation.enabled = true;

    await db.update("appellations", appellation.toJson(),
        where: 'id = ?',
        whereArgs: [
          appellation.id
        ]).then((value) =>
        _updateFirestore<Appellation>(context: context, object: appellation));
  }

  static Future<void> addRegion({
    required BuildContext context,
    required Region region,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    await db.insert("regions", region.toJson()).then((value) =>
        _updateFirestore<Region>(
            context: context, object: region, isNew: true));
  }

  static Future<void> deleteRegion({
    required BuildContext context,
    required Region? region,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    if (region == null) return;

    region.editedAt = InitializerModel.getTimestamp();
    region.enabled = false;

    await db.update("regions", region.toJson(), where: 'id = ?', whereArgs: [
      region.id
    ]).then(
        (value) => _updateFirestore<Region>(context: context, object: region));
  }

  static Future<void> updateRegion({
    required BuildContext context,
    required Region? region,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    if (region == null) return;

    region.editedAt = InitializerModel.getTimestamp();
    region.enabled = true;

    await db.update("regions", region.toJson(), where: 'id = ?', whereArgs: [
      region.id
    ]).then(
        (value) => _updateFirestore<Region>(context: context, object: region));
  }

  static Future<void> addCountry({
    required BuildContext context,
    required Country country,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    await db.insert("countries", country.toJson()).then((value) =>
        _updateFirestore<Country>(
            context: context, object: country, isNew: true));
  }

  static Future<void> deleteCountry({
    required BuildContext context,
    required Country? country,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    if (country == null) return;

    country.editedAt = InitializerModel.getTimestamp();
    country.enabled = false;

    await db.update("countries", country.toJson(), where: 'id = ?', whereArgs: [
      country.id
    ]).then((value) =>
        _updateFirestore<Country>(context: context, object: country));
  }

  static Future<void> updateCountry({
    required BuildContext context,
    required Country? country,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    if (country == null) return;

    country.editedAt = InitializerModel.getTimestamp();
    country.enabled = true;

    await db.update("countries", country.toJson(), where: 'id = ?', whereArgs: [
      country.id
    ]).then((value) =>
        _updateFirestore<Country>(context: context, object: country));
  }

  static Future<void> addCellar({
    required BuildContext context,
    required Cellar cellar,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    await db.insert("cellars", cellar.toJson()).then((value) =>
        _updateFirestore<Cellar>(
            context: context, object: cellar, isNew: true));
  }

  static Future<void> editCellar({
    required BuildContext context,
    required Cellar cellar,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    cellar.editedAt = InitializerModel.getTimestamp();

    await db.update("cellars", cellar.toJson(), where: 'id = ?', whereArgs: [
      cellar.id
    ]).then(
        (value) => _updateFirestore<Cellar>(context: context, object: cellar));
  }

  static Future<void> deleteCellar({
    required BuildContext context,
    required Cellar cellar,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    cellar.editedAt = InitializerModel.getTimestamp();
    cellar.enabled = false;

    await db.update("cellars", cellar.toJson(), where: 'id = ?', whereArgs: [
      cellar.id
    ]).then(
        (value) => _updateFirestore<Cellar>(context: context, object: cellar));
  }

  static Future<void> addBlock({
    required BuildContext context,
    required Block block,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    await db.insert("blocks", block.toJson()).then((value) =>
        _updateFirestore<Block>(context: context, object: block, isNew: true));
  }

  static Future<void> editBlock({
    required BuildContext context,
    required Block block,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    block.editedAt = InitializerModel.getTimestamp();

    await db.update("blocks", block.toJson(), where: 'id = ?', whereArgs: [
      block.id
    ]).then(
        (value) => _updateFirestore<Block>(context: context, object: block));
  }

  static Future<void> deleteBlock({
    required BuildContext context,
    required Block block,
  }) async {
    BriteDatabase db =
        MyDatabase.getBriteDatabase(context: context, listen: false);

    block.editedAt = InitializerModel.getTimestamp();
    block.enabled = false;

    await db.update("blocks", block.toJson(), where: 'id = ?', whereArgs: [
      block.id
    ]).then(
        (value) => _updateFirestore<Block>(context: context, object: block));
  }
}
