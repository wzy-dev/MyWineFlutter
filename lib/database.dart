import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class Database {
  static Future<List<QueryDocumentSnapshot>?> getCellars() async {
    return FirebaseFirestore.instance
        .collection('cellars')
        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("enabled", isEqualTo: true)
        .get()
        .then((collection) {
      print("load");
      return collection.docs;
    });
  }

  static Future<List<QueryDocumentSnapshot>?> getBlocksByCellar(
      {required String cellarId}) async {
    return FirebaseFirestore.instance
        .collection('cellars/$cellarId/blocks')
        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("enabled", isEqualTo: true)
        .get()
        .then((collection) => collection.docs);
  }

  static Future<List<QueryDocumentSnapshot>?> getPositionsByBlock(
      {required String cellarId, required String blockId}) async {
    return FirebaseFirestore.instance
        .collection('cellars/$cellarId/blocks/$blockId/positions')
        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("enabled", isEqualTo: true)
        .get()
        .then((collection) => collection.docs);
  }

  static Future<Map?> getWineById({required String wineId}) async {
    return FirebaseFirestore.instance
        .collection('wines')
        .doc(wineId)
        .get()
        .then((document) => document.data());
  }

  static Future<Map?> getAppellationById(
      {required String appellationId}) async {
    return FirebaseFirestore.instance
        .collection('appellations')
        .doc(appellationId)
        .get()
        .then((document) => document.data());
  }

  static String? getColorByPosition(
      {required BuildContext context,
      required String block,
      required int x,
      required int y}) {
    List<Position> positions = Provider.of<List<Position>>(context);
    Position? position = positions.firstWhereOrNull(
      (element) => element.y == y && element.x == x && element.block == block,
    );

    if (position == null) return null;

    List<Appellation> appellations = Provider.of<List<Appellation>>(context);

    List<Wine> wines = Provider.of<List<Wine>>(context);

    Wine? wine = wines.firstWhereOrNull((wine) => wine.id == position.wine);

    if (wine == null) return null;

    Appellation? appellation = appellations
        .firstWhereOrNull((appellation) => appellation.id == wine.appellation);

    if (appellation == null) return null;

    return appellation.color;
  }
}
