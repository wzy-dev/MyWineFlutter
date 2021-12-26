import 'package:sqflite/utils/utils.dart';
import 'package:sqlbrite/sqlbrite.dart';

class ModelMethods {
  static Map<String, dynamic> boolToInt(
      {required Map<String, dynamic> json, required String property}) {
    json[property] == true || json[property] == 1
        ? json[property] = 1
        : json[property] = 0;
    return json;
  }

  static Map<String, dynamic> intToBool(
      {required Map<String, dynamic> json, required String property}) {
    json[property] == true || json[property] == 1
        ? json[property] = true
        : json[property] = false;
    return json;
  }

  static Future<bool> tableExists(DatabaseExecutor db, String table) async {
    int count = firstIntValue(await db.query('sqlite_master',
            columns: ['COUNT(*)'],
            where: 'type = ? AND name = ?',
            whereArgs: ['table', table])) ??
        0;
    return count > 0;
  }

  static Future<Database> initDb({bool drop = false}) async {
    final db = await openDatabase('mywine_db.db');

    if (drop) {
      await db.execute("DROP TABLE IF EXISTS last_update");
      await db.execute("DROP TABLE IF EXISTS cellars");
      await db.execute("DROP TABLE IF EXISTS blocks");
      await db.execute("DROP TABLE IF EXISTS positions");
      await db.execute("DROP TABLE IF EXISTS wines");
      await db.execute("DROP TABLE IF EXISTS appellations");
      await db.execute("DROP TABLE IF EXISTS domains");
      await db.execute("DROP TABLE IF EXISTS regions");
      await db.execute("DROP TABLE IF EXISTS countries");
    }

    if (!await ModelMethods.tableExists(db, "wines")) {
      // Create a table
      await db.execute('''CREATE TABLE wines (
            id STRING PRIMARY KEY,
            createdAt INTEGER,
            editedAt INTEGER,
            owner STRING,
            enabled INTEGER,
            appellation STRING,
            domain STRING,
            quantity INTEGER,
            millesime INTEGER,
            bio INTEGER,
            sparkling INTEGER,
            tempmin INTEGER,
            tempmax INTEGER,
            yearmin INTEGER,
            yearmax INTEGER,
            size INTEGER,
            notes STRING
          )''');
    }

    if (!await ModelMethods.tableExists(db, "cellars")) {
      // Create a table
      await db.execute(
          'CREATE TABLE cellars (id STRING PRIMARY KEY, createdAt INTEGER, editedAt INTEGER, owner STRING, enabled INTEGER, name STRING)');
    }

    if (!await ModelMethods.tableExists(db, "blocks")) {
      // Create a table
      await db.execute(
          'CREATE TABLE blocks (id STRING PRIMARY KEY, createdAt INTEGER, editedAt INTEGER, owner STRING, enabled INTEGER, cellar STRING, horizontalAlignment STRING, verticalAlignment STRING, nbColumn INTEGER, nbLine INTEGER, x INTEGER, y INTEGER)');
    }

    if (!await ModelMethods.tableExists(db, "positions")) {
      // Create a table
      await db.execute(
          'CREATE TABLE positions (id STRING PRIMARY KEY, createdAt INTEGER, editedAt INTEGER, owner STRING, enabled INTEGER, block STRING, wine STRING, x INTEGER, y INTEGER)');
    }

    if (!await ModelMethods.tableExists(db, "appellations")) {
      // Create a table
      await db.execute('''CREATE TABLE appellations (
            id STRING PRIMARY KEY, 
            createdAt INTEGER, 
            editedAt INTEGER, 
            owner STRING,
            enabled INTEGER, 
            color STRING, 
            name STRING,
            label STRING,
            region STRING,
            tempmin INTEGER,
            tempmax INTEGER,
            yearmin INTEGER,
            yearmax INTEGER
          )''');
    }

    if (!await ModelMethods.tableExists(db, "domains")) {
      // Create a table
      await db.execute(
          'CREATE TABLE domains (id STRING PRIMARY KEY, createdAt INTEGER, editedAt INTEGER, owner STRING, enabled INTEGER, name STRING)');
    }

    if (!await ModelMethods.tableExists(db, "countries")) {
      // Create a table
      await db.execute('''CREATE TABLE countries (
            id STRING PRIMARY KEY,
            createdAt INTEGER,
            editedAt INTEGER,
            owner STRING,
            enabled INTEGER,
            name STRING
          )''');
    }

    if (!await ModelMethods.tableExists(db, "regions")) {
      // Create a table
      await db.execute('''CREATE TABLE regions (
            id STRING PRIMARY KEY,
            createdAt INTEGER,
            editedAt INTEGER,
            owner STRING,
            enabled INTEGER,
            name STRING,
            country STRING
          )''');
    }

    if (!await ModelMethods.tableExists(db, "last_update")) {
      // Create a table
      await db.execute(
          'CREATE TABLE last_update (id INTEGER PRIMARY KEY AUTOINCREMENT, tableName STRING, datetime INTEGER)');
      db.insert("last_update", {"tableName": "wines", "datetime": 0});
      db.insert("last_update", {"tableName": "cellars", "datetime": 0});
      db.insert("last_update", {"tableName": "blocks", "datetime": 0});
      db.insert("last_update", {"tableName": "positions", "datetime": 0});
      db.insert("last_update", {"tableName": "appellations", "datetime": 0});
      db.insert("last_update", {"tableName": "domains", "datetime": 0});
      db.insert("last_update", {"tableName": "regions", "datetime": 0});
      db.insert("last_update", {"tableName": "countries", "datetime": 0});
    }

    return db;
  }
}
