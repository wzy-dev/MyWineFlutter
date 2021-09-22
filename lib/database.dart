import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
}
