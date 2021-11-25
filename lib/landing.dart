import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mywine/shelf.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key, required this.child}) : super(key: key);

  final Widget? child;

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }

    return user;
  }

  Stream<User?> _streamUser = FirebaseAuth.instance.authStateChanges();
  String? _username;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: _streamUser,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.active) {
            return CircularProgressIndicator();
          }
          if (snapshot.data == null) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarBrightness: Brightness.dark,
                  systemNavigationBarIconBrightness: Brightness.dark,
                  statusBarIconBrightness: Brightness.dark,
                ),
              ),
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                        child: ScrollConfiguration(
                          behavior: ScrollBehavior(),
                          child: ListView(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            children: [
                              AutofillGroup(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 50),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Container(
                                          constraints: BoxConstraints(
                                              minWidth: 1, minHeight: 1),
                                          child: SvgPicture.asset(
                                            "assets/svg/logo_expanded.svg",
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    CustomTextField(
                                      context: context,
                                      onChange: (value) => setState(() {
                                        _username = value;
                                      }),
                                      placeholder: "Adresse email",
                                      icon: Icons.mail_outline,
                                      autofill: [AutofillHints.email],
                                    ),
                                    SizedBox(height: 10),
                                    CustomTextField(
                                      context: context,
                                      onChange: (value) => setState(() {
                                        _password = value;
                                      }),
                                      placeholder: "Mot de passe",
                                      icon: Icons.lock_outline,
                                      hidden: true,
                                      autofill: [AutofillHints.password],
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () => FirebaseAuth.instance
                                            .signInWithEmailAndPassword(
                                                email: _username ?? "",
                                                password: _password ?? ""),
                                        child: Center(
                                          child: Text(
                                            "ME CONNECTER",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all<
                                              EdgeInsets>(
                                            EdgeInsets.all(8),
                                          ),
                                          alignment: Alignment.centerLeft,
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () => print("signup"),
                                        child: Center(
                                          child: Text(
                                            "M'INSCRIRE",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all<
                                              EdgeInsets>(
                                            EdgeInsets.all(8),
                                          ),
                                          alignment: Alignment.centerLeft,
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: BorderSide(
                                                width: 1.2,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Text(
                                        "Ou",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 50,
                                      child: CustomElevatedButton(
                                        onPress: () =>
                                            signInWithGoogle(context: context),
                                        title: "Me connecter avec Google",
                                        textColor: Colors.black54,
                                        backgroundColor: Colors.white,
                                        icon: SvgPicture.asset(
                                            'assets/svg/google.svg'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    MediaQuery.of(context).viewInsets.bottom <= 200
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: TextButton(
                              onPressed: () =>
                                  FirebaseAuth.instance.signInAnonymously(),
                              child: Text("Commencer sans compte..."),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            );
          }
          return widget.child ?? Container();
        });
  }
}
