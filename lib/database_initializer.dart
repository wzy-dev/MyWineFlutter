import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mywine/models/model_methods.dart';
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
    _db = ModelMethods.initDb(drop: false);
    super.initState();
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
                  return widget.onDidInitilize(
                    context,
                    snapshotFirebaseApp,
                    BriteDatabase(snapshotDatabase.data!, logger: null),
                  );
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
