import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mywine/models/model_methods.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as appleSignin;
import 'package:mywine/shelf.dart';

class Account extends StatelessWidget {
  const Account({Key? key}) : super(key: key);

  Future<void> _drawDeleteDialog(
      {required BuildContext context, required Function popAction}) async {
    List<String> signInMethods = await FirebaseAuth.instance
        .fetchSignInMethodsForEmail(
            FirebaseAuth.instance.currentUser!.email!.toLowerCase());
    String? password;

    if (signInMethods
            .where(
                (element) => element == "google.com" || element == "apple.com")
            .length >
        0) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext contextDialog) {
          return AlertDialog(
            title: const Text('Voulez-vous vraiment supprimer votre compte'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Supprimer votre compte est une action irréversible !'),
                  Text(
                      'Vos caves et vos vins seront immédiatement supprimés et ne pourront pas être récupérés.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Annuler'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: Text(
                    'Supprimer mon compte',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    FirebaseAuth auth = FirebaseAuth.instance;

                    if (signInMethods
                            .where((element) => element == "google.com")
                            .length >
                        0) {
                      final GoogleSignIn googleSignIn = GoogleSignIn();

                      final GoogleSignInAccount? googleSignInAccount =
                          await googleSignIn.signInSilently(
                              reAuthenticate: true);

                      if (googleSignInAccount != null) {
                        final GoogleSignInAuthentication
                            googleSignInAuthentication =
                            await googleSignInAccount.authentication;

                        final AuthCredential credential =
                            GoogleAuthProvider.credential(
                          accessToken: googleSignInAuthentication.accessToken,
                          idToken: googleSignInAuthentication.idToken,
                        );

                        try {
                          await auth.signInWithCredential(credential);

                          User user = FirebaseAuth.instance.currentUser!;
                          user.delete().then(
                            (value) {
                              GoogleSignIn().signOut();
                              ModelMethods.initDb(drop: true);
                            },
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code ==
                              'account-exists-with-different-credential') {
                            // handle the error here
                          } else if (e.code == 'invalid-credential') {
                            // handle the error here
                          }
                        } catch (e) {
                          // handle the error here
                        }
                      }
                    } else {
                      try {
                        final appleSignin.AuthorizationResult result =
                            await appleSignin.TheAppleSignIn.performRequests([
                          appleSignin.AppleIdRequest(requestedScopes: [
                            appleSignin.Scope.email,
                          ])
                        ]);

                        switch (result.status) {
                          case appleSignin.AuthorizationStatus.authorized:
                            try {
                              print("successfull sign in");

                              final appleSignin.AppleIdCredential?
                                  appleIdCredential = result.credential;

                              String? idToken;
                              String? accessToken;

                              if (appleIdCredential != null) {
                                if (appleIdCredential.identityToken != null)
                                  idToken = String.fromCharCodes(
                                      appleIdCredential.identityToken
                                          as Iterable<int>);

                                if (appleIdCredential.authorizationCode != null)
                                  accessToken = String.fromCharCodes(
                                      appleIdCredential.authorizationCode
                                          as Iterable<int>);
                              }

                              OAuthProvider oAuthProvider =
                                  new OAuthProvider("apple.com");
                              final AuthCredential credential =
                                  oAuthProvider.credential(
                                idToken: idToken,
                                accessToken: accessToken,
                              );
                              await auth.signInWithCredential(credential);

                              User user = FirebaseAuth.instance.currentUser!;
                              user.delete().then(
                                (value) {
                                  GoogleSignIn().signOut();
                                  ModelMethods.initDb(drop: true);
                                },
                              );
                              return null;
                            } catch (e) {
                              print("error");
                              return null;
                            }
                          case appleSignin.AuthorizationStatus.error:
                            return null;

                          case appleSignin.AuthorizationStatus.cancelled:
                            print('User cancelled');
                            return null;
                        }
                      } catch (error) {
                        print("error with apple sign in");
                        return null;
                      }
                    }
                  }),
            ],
          );
        },
      );
    } else if (signInMethods.where((element) => element == "password").length >
        0) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext contextDialog) {
          return AlertDialog(
            title: const Text('Voulez-vous vraiment supprimer votre compte'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Supprimer votre compte est une action irréversible !'),
                  Text(
                      'Vos caves et vos vins seront immédiatement supprimés et ne pourront pas être récupérés.'),
                  SizedBox(height: 30),
                  CustomTextFieldWithIcon(
                    context: context,
                    onChange: (value) => password = value,
                    placeholder: "Mot de passe",
                    icon: Icons.lock_outline,
                    hidden: true,
                    autofill: [
                      AutofillHints.password,
                      AutofillHints.newPassword
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Annuler'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  'Supprimer mon compte',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  if (password == null) return;
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: FirebaseAuth.instance.currentUser!.email!
                          .toLowerCase(),
                      password: password!);

                  User user = FirebaseAuth.instance.currentUser!;
                  user.delete().then(
                    (value) {
                      GoogleSignIn().signOut();
                      ModelMethods.initDb(drop: true);
                    },
                  );
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      title: Text("Mon comte"),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 66),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Bonjour",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(220, 220, 220, 1),
                fontSize: 56,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
              child: Text(
                FirebaseAuth.instance.currentUser!.email!.toLowerCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(120, 120, 120, 1),
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CustomElevatedButton(
              onPress: () => FirebaseAuth.instance.signOut().then(
                (value) {
                  GoogleSignIn().signOut();
                  ModelMethods.initDb(drop: true);
                },
              ),
              title: "Se déconnecter",
              backgroundColor: Theme.of(context).colorScheme.secondary,
              icon: Icon(
                Icons.logout_rounded,
              ),
            ),
            CustomFlatButton(
              title: "Supprimer mon compte",
              onPress: () => _drawDeleteDialog(
                context: context,
                popAction: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              icon: Icon(Icons.warning_rounded),
            )
          ],
        ),
      ),
    );
  }
}
