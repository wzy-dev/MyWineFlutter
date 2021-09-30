import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mywine/flutter_initializer.dart';
import 'package:mywine/shelf.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/utils/utils.dart';
import 'package:sqlbrite/sqlbrite.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());

  //For Navigation bar
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future _db;
  late BriteDatabase _briteDb;

  @override
  void initState() {
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

  Future _initDb() async {
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

    _briteDb = BriteDatabase(db, logger: null);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _db,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done)
          return Center(
            child: CircularProgressIndicator(),
          );

        return FirebaseInitializer(
          onDidInitilize: (didInitContext, _) {
            //Authentification
            FirebaseAuth.instance.signInWithEmailAndPassword(
                email: "mumu17100@gmail.com", password: "mumumumu17.");

            return MultiProvider(
              providers:
                  CustomProvider.generateProvidersList(briteDb: _briteDb),
              child: MaterialApp(
                title: 'MyWine',
                initialRoute: '/',
                onGenerateRoute: (routeSettings) =>
                    RootNavigator.onGenerateRoute(
                        context: context, route: routeSettings.name!),
                theme: ThemeData(
                  // Colors
                  primaryColor: Color.fromRGBO(5, 60, 92, 1),
                  // accentColor: Color.fromRGBO(219, 84, 97, 1),
                  colorScheme: ColorScheme(
                    primary: Color.fromRGBO(5, 60, 92, 1),
                    primaryVariant: Colors.white,
                    secondary: Color.fromRGBO(219, 84, 97, 1),
                    secondaryVariant: Colors.white,
                    surface: Colors.white,
                    background: Colors.white,
                    error: Colors.white,
                    onPrimary: Colors.white,
                    onSecondary: Colors.white,
                    onSurface: Colors.white,
                    onBackground: Colors.white,
                    onError: Colors.white,
                    brightness: Brightness.dark,
                  ),
                  hintColor: Color.fromRGBO(47, 111, 143, 1),
                  backgroundColor: Color.fromRGBO(245, 245, 245, 1),

                  // TextThemes
                  textTheme: TextTheme(
                    headline1: TextStyle(
                      color: Color.fromRGBO(47, 111, 143, 1),
                      fontSize: 20,
                      fontFamily: "Ubuntu",
                    ),
                    headline2: TextStyle(
                      color: Color.fromRGBO(5, 60, 92, 1),
                      fontSize: 18,
                      fontFamily: "Ubuntu",
                    ),
                    headline3: TextStyle(
                      color: Color.fromRGBO(104, 105, 99, 1),
                      fontSize: 15,
                      fontFamily: "OpenSans",
                    ),
                    subtitle1: TextStyle(
                      color: Color.fromRGBO(104, 105, 99, 1),
                      fontSize: 15,
                      fontFamily: "OpenSans",
                    ),
                    bodyText1: TextStyle(color: Colors.black),
                    bodyText2: TextStyle(color: Colors.black),
                  ),

                  // Navigation
                  appBarTheme: AppBarTheme(
                    backgroundColor: Color.fromRGBO(219, 84, 97, 1),
                    centerTitle: false,
                    titleTextStyle: TextStyle(
                      fontFamily: "OpenSans",
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                ),
                home: Homepage(),
              ),
            );
          },
          onLoading: (loadingContext) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
