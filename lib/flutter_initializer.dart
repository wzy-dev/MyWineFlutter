import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FirebaseInitializer extends StatefulWidget {
  final Widget Function(BuildContext, FirebaseApp) onDidInitilize;
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
  late Future<FirebaseApp> initialization;

  @override
  void initState() {
    super.initState();
    initialization = Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: initialization,
      builder: (context, snapshot) {
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return widget.onDidInitilize(context, snapshot.data!);
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return widget.onLoading(context);
      },
    );
  }
}
