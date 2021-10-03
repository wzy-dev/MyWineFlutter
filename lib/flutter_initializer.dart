import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/utils/utils.dart';
import 'package:sqlbrite/sqlbrite.dart';

class FirebaseInitializer extends StatefulWidget {
  final Widget Function(
          BuildContext context, AsyncSnapshot snapshots, BriteDatabase briteDb)
      onDidInitilize;
  final Widget Function(BuildContext) onLoading;

  const FirebaseInitializer({
    Key? key,
    required this.onDidInitilize,
    required this.onLoading,
  }) : super(key: key);

  @override
  _FirebaseInitializerState createState() => _FirebaseInitializerState();
}

class _FirebaseInitializerState extends State<FirebaseInitializer> {
  late Future<FirebaseApp> _initialization;
  late Future<Database> _db;

  @override
  void initState() {
    _initialization = Firebase.initializeApp();
    _db = _initDb();
    super.initState();
  }

  Future<bool> tableExists(DatabaseExecutor db, String table) async {
    int count = firstIntValue(await db.query('sqlite_master',
            columns: ['COUNT(*)'],
            where: 'type = ? AND name = ?',
            whereArgs: ['table', table])) ??
        0;
    return count > 0;
  }

  Future<Database> _initDb() async {
    final db = await openDatabase('mywine_db.db');

    await db.execute("DROP TABLE IF EXISTS last_update");
    await db.execute("DROP TABLE IF EXISTS cellars");
    await db.execute("DROP TABLE IF EXISTS blocks");
    await db.execute("DROP TABLE IF EXISTS positions");
    await db.execute("DROP TABLE IF EXISTS wines");
    await db.execute("DROP TABLE IF EXISTS appellations");

    if (!await tableExists(db, "wines")) {
      // Create a table
      await db.execute(
          'CREATE TABLE wines (id STRING PRIMARY KEY, createdAt INTEGER, editedAt INTEGER, enabled INTEGER, appellation STRING, quantity INTEGER)');
    }

    if (!await tableExists(db, "cellars")) {
      // Create a table
      await db.execute(
          'CREATE TABLE cellars (id STRING PRIMARY KEY, createdAt INTEGER, editedAt INTEGER, enabled INTEGER, name STRING)');
    }

    if (!await tableExists(db, "blocks")) {
      // Create a table
      await db.execute(
          'CREATE TABLE blocks (id STRING PRIMARY KEY, createdAt INTEGER, editedAt INTEGER, enabled INTEGER, cellar STRING, horizontalAlignment STRING, verticalAlignment STRING, nbColumn INTEGER, nbLine INTEGER, x INTEGER, y INTEGER)');
    }

    if (!await tableExists(db, "positions")) {
      // Create a table
      await db.execute(
          'CREATE TABLE positions (id STRING PRIMARY KEY, createdAt INTEGER, editedAt INTEGER, enabled INTEGER, block STRING, wine STRING, x INTEGER, y INTEGER)');
    }

    if (!await tableExists(db, "appellations")) {
      // Create a table
      await db.execute(
          'CREATE TABLE appellations (id STRING PRIMARY KEY, createdAt INTEGER, editedAt INTEGER, enabled INTEGER, color STRING, name STRING)');
    }

    if (!await tableExists(db, "last_update")) {
      // Create a table
      await db.execute(
          'CREATE TABLE last_update (id INTEGER PRIMARY KEY AUTOINCREMENT, tableName STRING, datetime INTEGER)');
      db.insert("last_update", {"tableName": "wines", "datetime": 0});
      db.insert("last_update", {"tableName": "cellars", "datetime": 0});
      db.insert("last_update", {"tableName": "blocks", "datetime": 0});
      db.insert("last_update", {"tableName": "positions", "datetime": 0});
      db.insert("last_update", {"tableName": "appellations", "datetime": 0});
    }

    return db;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Database>(
        future: _db,
        builder: (context, snapshotDatabase) {
          // Once complete, show your application
          if (snapshotDatabase.connectionState == ConnectionState.done &&
              snapshotDatabase.data != null) {
            return FutureBuilder<FirebaseApp>(
              future: _initialization,
              builder: (context, snapshotFirebaseApp) {
                // Once complete, show your application
                if (snapshotFirebaseApp.connectionState ==
                    ConnectionState.done) {
                  return widget.onDidInitilize(context, snapshotFirebaseApp,
                      BriteDatabase(snapshotDatabase.data!, logger: null));
                }
                // Otherwise, show something whilst waiting for initialization to complete
                return widget.onLoading(context);
              },
            );
          }
          // Otherwise, show something whilst waiting for initialization to complete
          return widget.onLoading(context);
        });
  }
}
