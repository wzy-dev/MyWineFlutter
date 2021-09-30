import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mywine/shelf.dart';
import 'package:provider/provider.dart';
import 'package:sqlbrite/sqlbrite.dart';

class CustomProvider {
  static Map<String, dynamic> _mapFromFirestore(
      {required String name, required item}) {
    switch (name) {
      case "wines":
        return Wine.fromFirestore(item).toJson();
      case "cellars":
        return Cellar.fromFirestore(item).toJson();
      case "blocks":
        return Block.fromFirestore(item).toJson();
      case "positions":
        return Position.fromFirestore(item).toJson();
      case "appellations":
        return Appellation.fromFirestore(item).toJson();
      default:
        print("Add an enter in the _mapFromFirstore function");
        return {};
    }
  }

  static void getLastUpdateCollection({
    required String tableName,
    required BriteDatabase briteDb,
    List<String>? whereList,
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
          .where(
            "owner",
            whereIn: whereList ?? [FirebaseAuth.instance.currentUser!.uid],
          )
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

  static void getLastUpdateSubCollection({
    required String tableName,
    required BriteDatabase briteDb,
    List<String>? whereList,
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
          .collectionGroup(tableName)
          .where(
            "owner",
            whereIn: whereList ?? [FirebaseAuth.instance.currentUser!.uid],
          )
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
    getLastUpdateCollection(tableName: "wines", briteDb: briteDb);
    return briteDb.createQuery(
      "wines",
      where: 'enabled = ?',
      whereArgs: ['1'],
    ).mapToList((row) => Wine.fromJson(row));
  }

  static Stream<List<Cellar>> streamOfCellars(
      {required BriteDatabase briteDb}) {
    getLastUpdateCollection(tableName: "cellars", briteDb: briteDb);
    return briteDb.createQuery(
      "cellars",
      where: 'enabled = ?',
      whereArgs: ['1'],
    ).mapToList((row) => Cellar.fromJson(row));
  }

  static Stream<List<Block>> streamOfBlocks({required BriteDatabase briteDb}) {
    getLastUpdateSubCollection(tableName: "blocks", briteDb: briteDb);
    return briteDb.createQuery(
      "blocks",
      where: 'enabled = ?',
      whereArgs: ['1'],
    ).mapToList((row) => Block.fromJson(row));
  }

  static Stream<List<Position>> streamOfPositions(
      {required BriteDatabase briteDb}) {
    getLastUpdateSubCollection(tableName: "positions", briteDb: briteDb);
    return briteDb.createQuery(
      "positions",
      where: 'enabled = ?',
      whereArgs: ['1'],
    ).mapToList((row) => Position.fromJson(row));
  }

  static Stream<List<Appellation>> streamOfAppellations(
      {required BriteDatabase briteDb}) {
    getLastUpdateCollection(
        tableName: "appellations",
        briteDb: briteDb,
        whereList: [
          "admin",
          FirebaseAuth.instance.currentUser!.uid,
        ]);
    return briteDb.createQuery(
      "appellations",
      where: 'enabled = ?',
      whereArgs: ['1'],
    ).mapToList((row) => Appellation.fromJson(row));
    // var ref = FirebaseFirestore.instance
    //     .collection("appellations")
    //     .where("owner", whereIn: [
    //   "admin",
    //   FirebaseAuth.instance.currentUser!.uid
    // ]).where("enabled", isEqualTo: true);

    // return ref.snapshots().map((list) =>
    //     list.docs.map((doc) => Appellation.fromFirestore(doc)).toList());
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
