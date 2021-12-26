import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mywine/database_initializer.dart';
import 'package:mywine/shelf.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());

  //For Navigation bar
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.white,
    // systemNavigationBarContrastEnforced: true,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // bool _isLogged = true;

  // void _updateLogged(bool newValue) {
  //   _isLogged = newValue;
  // }

  @override
  Widget build(BuildContext context) {
    return FirebaseInitializer(
      onDidInitilize: (initContext, snapshot, briteDb) {
        Stream<User?> _streamUser = FirebaseAuth.instance.authStateChanges();

        return StreamBuilder<User?>(
            stream: _streamUser,
            builder: (context, snapshot) {
              return MultiProvider(
                key: Key(snapshot.data?.uid ?? "null"),
                providers: CustomProvider.generateProvidersList(
                    briteDb: briteDb, user: snapshot.data),
                child: MaterialApp(
                  title: 'MyWine',
                  localizationsDelegates: [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: [Locale('fr', 'FR')],
                  onGenerateRoute: (routeSettings) =>
                      RootNavigator.onGenerateRoute(
                    context: context,
                    settings: routeSettings,
                    // isLogged: _isLogged,
                    // updateLogged: _updateLogged,
                  ),
                  theme: ThemeData(
                    // Colors
                    primaryColor: Color.fromRGBO(5, 60, 92, 1),
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

                    // Slider
                    sliderTheme: SliderThemeData(
                      trackHeight: 3,
                      rangeTrackShape: RectangularRangeSliderTrackShape(),
                      activeTrackColor: Color.fromRGBO(219, 84, 97, 1),
                      inactiveTrackColor: Color.fromRGBO(138, 162, 158, 1),
                      disabledActiveTrackColor: Colors.black12,
                      disabledInactiveTrackColor: Colors.black12,
                      thumbColor: Color.fromRGBO(219, 84, 97, 1),
                      disabledThumbColor: Color.fromRGBO(208, 188, 188, 1),
                      trackShape: RectangularSliderTrackShape(),
                    ),
                  ),
                ),
              );
            });
      },
      onLoading: (loadingContext) => Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
