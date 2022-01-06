import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mywine/shelf.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as appleSignin;

class Landing extends StatefulWidget {
  const Landing({Key? key, required this.child}) : super(key: key);

  final Widget? child;

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  String? _errorPassword;
  String? _errorEmail;
  String? _successPassword;
  bool _supportsAppleSignIn = false;

  @override
  void initState() {
    if (Platform.isIOS) {
      appleSignin.TheAppleSignIn.isAvailable()
          .then((isAvailable) => _supportsAppleSignIn = isAvailable);
    }
    super.initState();
  }

  static Future<User?> signInWithApple({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      final appleSignin.AuthorizationResult result =
          await appleSignin.TheAppleSignIn.performRequests([
        appleSignin.AppleIdRequest(requestedScopes: [
          appleSignin.Scope.email,
        ])
      ]);

      print(result.status);

      switch (result.status) {
        case appleSignin.AuthorizationStatus.authorized:
          try {
            print("successfull sign in");

            final appleSignin.AppleIdCredential? appleIdCredential =
                result.credential;

            String? idToken;
            String? accessToken;

            if (appleIdCredential != null) {
              if (appleIdCredential.identityToken != null)
                idToken = String.fromCharCodes(
                    appleIdCredential.identityToken as Iterable<int>);

              if (appleIdCredential.authorizationCode != null)
                accessToken = String.fromCharCodes(
                    appleIdCredential.authorizationCode as Iterable<int>);
            }

            OAuthProvider oAuthProvider = new OAuthProvider("apple.com");
            final AuthCredential credential = oAuthProvider.credential(
              idToken: idToken,
              accessToken: accessToken,
            );
            final UserCredential userCredential =
                await auth.signInWithCredential(credential);

            user = userCredential.user;

            return user;
          } catch (e) {
            print("error");
          }
          break;
        case appleSignin.AuthorizationStatus.error:
          // do something
          break;

        case appleSignin.AuthorizationStatus.cancelled:
          print('User cancelled');
          break;
      }
    } catch (error) {
      print("error with apple sign in");
    }
  }

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

  bool _tooManyMail = false;

  void _sendConfirmation(User user) {
    user.sendEmailVerification().then((e) {
      setState(() => _tooManyMail = false);
    }).catchError((error) {
      if (error.code == 'too-many-requests') {
        setState(() => _tooManyMail = true);
      }
    });
  }

  void _checkIfVerified() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    user.sendEmailVerification();

    Timer.periodic(Duration(seconds: 3), (timer) {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) timer.cancel();

      user!.reload().then((value) {
        User? refreshUser = FirebaseAuth.instance.currentUser;
        if (refreshUser != null && refreshUser.emailVerified) {
          FirebaseAuth.instance.signOut().then((value) => FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: _username ?? "", password: _password ?? "")
              .then((value) => timer.cancel()));
        }
      });
    });
  }

  void _signInWithEmail() {
    bool hasError = _checkIfError();

    if (hasError) return;

    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _username ?? "", password: _password ?? "")
        .then((value) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) _checkIfVerified();
    }).catchError((error) {
      switch (error.code) {
        case 'wrong-password':
          setState(() => _errorPassword = 'Votre mot de passe est incorrect');
          break;
        case 'user-not-found':
          setState(() => _errorEmail = 'Cette adresse email est inconnue');
          break;
        case 'invalid-email':
          setState(
              () => _errorEmail = 'Veuillez donner une adresse email correcte');
          break;
        default:
          setState(() => _errorPassword = 'Une erreur est survenue');
      }
    });
  }

  void _resetPassword() {
    bool hasError = false;

    if (_username == null || _username!.length == 0) {
      setState(() {
        _errorEmail = "L'adresse email ne peut pas être nulle";
      });
      hasError = true;
    } else {
      RegExp checkEmail = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

      if (!checkEmail.hasMatch(_username!)) {
        setState(() {
          _errorEmail = "L'adresse email n'est pas valide";
        });
        hasError = true;
      } else {
        setState(() {
          _errorEmail = null;
        });
      }
    }

    if (hasError) return;

    FirebaseAuth.instance
        .sendPasswordResetEmail(email: _username!)
        .then((value) => setState(() => _successPassword =
            "Un email a été envoyé à cette adresse pour réinitialiser votre mot de passe"))
        .catchError((error) {
      switch (error.code) {
        case 'user-not-found':
          setState(() {
            _errorEmail = "Cette adresse email est inconnue";
          });
          break;
        case 'invalid-email':
          setState(() {
            _errorEmail = "Cette adresse email est incorrecte";
          });
          break;
        case 'too-many-requests':
          setState(() {
            _errorPassword =
                "Veuillez patienter avant de demander un nouveau mail";
          });
          break;
        default:
          setState(() {
            _errorEmail = "Une erreur est survenue";
          });
      }
    });
  }

  void _createNewUser() {
    bool hasError = _checkIfError();

    if (hasError) return;

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: _username ?? "",
          password: _password ?? "",
        )
        .then((value) => _checkIfVerified())
        .catchError((error) {
      switch (error.code) {
        case 'weak-password':
          setState(() =>
              _errorPassword = 'Votre mot de passe n\'est pas assez sécurisé');
          break;
        case 'email-already-in-use':
          setState(() => _errorEmail =
              'Vous possédez déjà un compte avec cette adresse email');
          break;
        default:
          setState(() => _errorPassword = 'Une erreur est survenue');
      }
    });
  }

  bool _checkIfError() {
    bool hasError = false;

    if (_username == null || _username!.length == 0) {
      setState(() {
        _errorEmail = "L'adresse email ne peut pas être nulle";
      });
      hasError = true;
    } else {
      RegExp checkEmail = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

      if (!checkEmail.hasMatch(_username!)) {
        setState(() {
          _errorEmail = "L'adresse email n'est pas valide";
        });
        hasError = true;
      } else {
        setState(() {
          _errorEmail = null;
        });
      }
    }
    if (_password == null || _password!.length == 0) {
      setState(() {
        _errorPassword = "Le mot de passe ne peut pas être nul";
      });
      hasError = true;
    } else {
      if (_password!.length < 6) {
        setState(() {
          _errorPassword = "Le mot de passe doit faire plus de 6 charactères";
        });
        hasError = true;
      } else {
        setState(() {
          _errorPassword = null;
        });
      }
    }

    return hasError;
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
                  statusBarBrightness: Brightness.light,
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
                                    CustomTextFieldWithIcon(
                                      context: context,
                                      onChange: (value) => setState(() {
                                        _username = value;
                                      }),
                                      placeholder: "Adresse email",
                                      icon: Icons.mail_outline,
                                      autofill: [AutofillHints.email],
                                    ),
                                    _errorEmail != null
                                        ? ErrorLine(string: _errorEmail!)
                                        : Container(),
                                    SizedBox(height: 10),
                                    CustomTextFieldWithIcon(
                                      context: context,
                                      onChange: (value) => setState(() {
                                        _password = value;
                                      }),
                                      placeholder: "Mot de passe",
                                      icon: Icons.lock_outline,
                                      hidden: true,
                                      autofill: [
                                        AutofillHints.password,
                                        AutofillHints.newPassword
                                      ],
                                    ),
                                    _errorPassword != null
                                        ? ErrorLine(string: _errorPassword!)
                                        : Container(),
                                    _successPassword != null
                                        ? SuccessLine(string: _successPassword!)
                                        : Container(),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () => _signInWithEmail(),
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
                                      child: TextButton(
                                        onPressed: () => _createNewUser(),
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
                                    TextButton(
                                      onPressed: () => _resetPassword(),
                                      child: Text(
                                        "J'ai oublié mon mot de passe",
                                        style: TextStyle(
                                            color: Theme.of(context).hintColor),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 30),
                                      child: Text(
                                        "Ou",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                    _supportsAppleSignIn
                                        ? Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 15),
                                            child:
                                                appleSignin.AppleSignInButton(
                                              type: appleSignin
                                                  .ButtonType.continueButton,
                                              cornerRadius: 10,
                                              buttonText:
                                                  "Continuer avec Apple",
                                              style: appleSignin
                                                  .ButtonStyle.whiteOutline,
                                              onPressed: () => signInWithApple(
                                                  context: context),
                                            ),
                                          )
                                        : SizedBox(),
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
                    // MediaQuery.of(context).viewInsets.bottom <= 200
                    //     ? Padding(
                    //         padding: const EdgeInsets.symmetric(
                    //             horizontal: 20, vertical: 10),
                    //         child: TextButton(
                    //           onPressed: () =>
                    //               FirebaseAuth.instance.signInAnonymously(),
                    //           child: Text("Commencer sans compte..."),
                    //         ),
                    //       )
                    //     : Container(),
                  ],
                ),
              ),
            );
          } else if (snapshot.data != null &&
              snapshot.data.emailVerified == false &&
              !snapshot.data.isAnonymous) {
            User user = snapshot.data;
            return WillPopScope(
              onWillPop: () async {
                FirebaseAuth.instance.signOut();
                return false;
              },
              child: Scaffold(
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
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Theme.of(context).hintColor,
                          ),
                          SizedBox(height: 20),
                          Text(
                            "En attente de validation".toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(fontSize: 25),
                          ),
                          SizedBox(height: 30),
                          TextButton(
                            child: Text(
                              "Recevoir un nouveau mail de confirmation",
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            onPressed: () => _sendConfirmation(user),
                          ),
                          _tooManyMail
                              ? ErrorLine(
                                  string:
                                      "Veuillez patienter avant de demander un nouveau mail.",
                                  dense: true,
                                )
                              : Container(),
                        ],
                      ),
                      Positioned(
                        bottom: 5,
                        child: InkWell(
                          onTap: () => FirebaseAuth.instance.signOut(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.expand_more_outlined,
                                color: Colors.black87,
                              ),
                              Text(
                                "Annuler",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return widget.child ?? Container();
        });
  }
}

class ErrorLine extends StatelessWidget {
  const ErrorLine({
    Key? key,
    required this.string,
    this.dense = false,
  }) : super(key: key);

  final String string;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: (dense ? 5 : 10), bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_outlined,
            color: Theme.of(context).colorScheme.secondary,
          ),
          SizedBox(width: 8),
          Expanded(
            flex: (dense ? 0 : 1),
            child: Text(
              string,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SuccessLine extends StatelessWidget {
  const SuccessLine({
    Key? key,
    required this.string,
    this.dense = false,
  }) : super(key: key);

  final String string;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: (dense ? 5 : 10), bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.forward_to_inbox_outlined,
            color: Theme.of(context).colorScheme.primaryVariant,
          ),
          SizedBox(width: 8),
          Expanded(
            flex: (dense ? 0 : 1),
            child: Text(
              string,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primaryVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
