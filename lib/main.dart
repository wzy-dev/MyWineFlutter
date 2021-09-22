import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mywine/shelf.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// This is our global ServiceLocator
GetIt getIt = GetIt.instance;

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
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  Stream<List<Cellar>> streamOfCellars() {
    var ref = FirebaseFirestore.instance.collection('test');
    return ref.snapshots().map(
        (list) => list.docs.map((doc) => Cellar.fromFirestore(doc)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done)
            return Center(
              child: CircularProgressIndicator(),
            );

          //Authentification
          FirebaseAuth.instance.signInWithEmailAndPassword(
              email: "mumu17100@gmail.com", password: "mumumumu17.");

          return MultiProvider(
            providers: [
              StreamProvider<List<Cellar>>(
                create: (_) => streamOfCellars(),
                initialData: [],
              ),
            ],
            child: MaterialApp(
              title: 'MyWine',
              initialRoute: '/',
              onGenerateRoute: (routeSettings) => RootNavigator.onGenerateRoute(
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
                  headline3: TextStyle(
                    color: Color.fromRGBO(104, 105, 99, 1),
                    fontSize: 15,
                    fontFamily: "OpenSans",
                  ),
                  bodyText1: TextStyle(color: Colors.black),
                  bodyText2: TextStyle(color: Colors.black),
                ),

                // Navigation
                appBarTheme: AppBarTheme(
                  // backwardsCompatibility: false,
                  // brightness: Brightness.dark,
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
        });
  }
}
