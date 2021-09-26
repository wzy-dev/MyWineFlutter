import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mywine/shelf.dart';
import 'package:provider/provider.dart';
import 'package:sqlbrite/sqlbrite.dart';

class CustomProvider {
  static _mapFromFirestore({required String name, required item}) {
    switch (name) {
      case "wines":
        return Wine.fromFirestore(item).toJson();
      case "cellars":
        return Cellar.fromFirestore(item).toJson();
    }
  }

  static void getLastUpdate({
    required String tableName,
    required BriteDatabase briteDb,
  }) {
    briteDb
        .query(
      "last_update",
      where: "tableName = ?",
      whereArgs: [tableName],
      limit: 1,
    )
        .then((lastUpdateMap) {
      int lastUpdate = int.parse(lastUpdateMap[0]["datetime"].toString());
      int datetime = DateTime.now().toUtc().millisecondsSinceEpoch.toInt();
      FirebaseFirestore.instance
          .collection(tableName)
          .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where("editedAt", isGreaterThan: lastUpdate)
          .get()
          .then((value) {
        for (var item in value.docs) {
          briteDb.insert(
            tableName,
            _mapFromFirestore(item: item, name: tableName),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        briteDb.update(
          "last_update",
          {"datetime": datetime},
          where: "tableName = ?",
          whereArgs: [tableName],
        );
      });
    });
  }

  static Stream<List<Wine>> streamOfWines({required BriteDatabase briteDb}) {
    getLastUpdate(tableName: "wines", briteDb: briteDb);
    return briteDb.createQuery(
      "wines",
      where: 'enabled = ?',
      whereArgs: ['1'],
    ).mapToList((row) => Wine.fromJson(row));
  }

  static Stream<List<Cellar>> streamOfCellars(
      {required BriteDatabase briteDb}) {
    getLastUpdate(tableName: "cellars", briteDb: briteDb);
    return briteDb.createQuery(
      "cellars",
      where: 'enabled = ?',
      whereArgs: ['1'],
    ).mapToList((row) => Cellar.fromJson(row));
    // briteDb.query("last_update", orderBy: "id DESC", limit: 1).then((value) {
    //   int lastUpdate = int.parse(value[0]["datetime"].toString());
    //   int datetime = DateTime.now().toUtc().millisecondsSinceEpoch.toInt();
    //   FirebaseFirestore.instance
    //       .collection("cellars")
    //       .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
    //       .where("editedAt", isGreaterThan: lastUpdate)
    //       .get()
    //       .then((value) {
    //     for (var item in value.docs) {
    //       briteDb.insert('cellars', Cellar.fromFirestore(item).toJson());
    //     }
    //     briteDb.insert("last_update", {"datetime": datetime});
    //   });
    // });

    // return briteDb.createQuery(
    //   'cellars',
    //   where: 'enabled = ?',
    //   whereArgs: ['1'],
    // ).mapToList((row) => Cellar.fromJson(row));

    // var ref = FirebaseFirestore.instance
    //     .collection("cellars")
    //     .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
    //     .where("enabled", isEqualTo: true);

    // return ref.snapshots().map(
    //     (list) => list.docs.map((doc) => Cellar.fromFirestore(doc)).toList());
  }

  static Stream<List<Block>> streamOfBlocks({required BriteDatabase briteDb}) {
    var ref = FirebaseFirestore.instance
        .collectionGroup("blocks")
        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("enabled", isEqualTo: true);

    return ref.snapshots().map(
        (list) => list.docs.map((doc) => Block.fromFirestore(doc)).toList());
  }

  static Stream<List<Position>> streamOfPositions(
      {required BriteDatabase briteDb}) {
    var ref = FirebaseFirestore.instance
        .collectionGroup("positions")
        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("enabled", isEqualTo: true);

    return ref.snapshots().map(
        (list) => list.docs.map((doc) => Position.fromFirestore(doc)).toList());
  }

  static Stream<List<Appellation>> streamOfAppellations(
      {required BriteDatabase briteDb}) {
    var ref1 = FirebaseFirestore.instance
        .collection("appellations")
        .where("owner", whereIn: [
      "admin",
      FirebaseAuth.instance.currentUser!.uid
    ]).where("enabled", isEqualTo: true);

    return ref1.snapshots().map((list) =>
        list.docs.map((doc) => Appellation.fromFirestore(doc)).toList());
  }

  static generateProvidersList({required BriteDatabase briteDb}) {
    return [
      StreamProvider<List<Cellar>>(
        create: (_) => CustomProvider.streamOfCellars(briteDb: briteDb),
        initialData: [],
      ),
      StreamProvider<List<Block>>(
        create: (_) => CustomProvider.streamOfBlocks(briteDb: briteDb),
        initialData: [],
      ),
      StreamProvider<List<Position>>(
        create: (_) => CustomProvider.streamOfPositions(briteDb: briteDb),
        initialData: [],
      ),
      StreamProvider<List<Wine>>(
        create: (_) => CustomProvider.streamOfWines(briteDb: briteDb),
        initialData: [],
      ),
      StreamProvider<List<Appellation>>(
        create: (_) => CustomProvider.streamOfAppellations(briteDb: briteDb),
        initialData: [],
      ),
      Provider<BriteDatabase>(
        create: (_) => briteDb,
      ),
    ];
  }
}
