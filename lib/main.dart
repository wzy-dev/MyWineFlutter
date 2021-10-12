import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mywine/database_initializer.dart';
import 'package:mywine/shelf.dart';
import 'package:provider/provider.dart';

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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FirebaseInitializer(
      onDidInitilize: (initContext, snapshot, briteDb) {
        //Authentification
        FirebaseAuth.instance.signInWithEmailAndPassword(
            email: "mumu17100@gmail.com", password: "mumumumu17.");

        return MultiProvider(
          providers: CustomProvider.generateProvidersList(briteDb: briteDb),
          child: MaterialApp(
            title: 'MyWine',
            initialRoute: '/',
            onGenerateRoute: (routeSettings) => RootNavigator.onGenerateRoute(
                context: context, settings: routeSettings),
            theme: ThemeData(
              // Colors
              primaryColor: Colors.red,
              // primaryColor: Color.fromRGBO(5, 60, 92, 1),
              colorScheme: ColorScheme(
                primary: Color.fromRGBO(5, 60, 92, 1),
                primaryVariant: Color.fromRGBO(138, 162, 158, 1),
                secondary: Color.fromRGBO(219, 84, 97, 1),
                secondaryVariant: Colors.white,
                surface: Colors.white,
                background: Colors.white,
                error: Color.fromRGBO(219, 84, 97, 1),
                onPrimary: Color.fromRGBO(5, 60, 92, 1),
                onSecondary: Color.fromRGBO(219, 84, 97, 1),
                onSurface: Colors.white,
                onBackground: Colors.white,
                onError: Colors.white,
                brightness: Brightness.light,
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
                headline4: TextStyle(
                  color: Color.fromRGBO(47, 111, 143, 1),
                  fontSize: 20,
                  fontFamily: "Ubuntu",
                  fontWeight: FontWeight.bold,
                ),
                headline3: TextStyle(
                  color: Color.fromRGBO(104, 105, 99, 1),
                  fontSize: 15,
                  fontFamily: "OpenSans",
                ),
                subtitle1: TextStyle(
                  color: Color.fromRGBO(104, 105, 99, 1),
                  fontSize: 18,
                  fontFamily: "OpenSans",
                ),
                subtitle2: TextStyle(
                  color: Color.fromRGBO(104, 105, 99, 1),
                  fontSize: 13,
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
  }
}
