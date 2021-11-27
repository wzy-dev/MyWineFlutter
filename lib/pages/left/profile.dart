import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mywine/models/model_methods.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainContainer(
        title: Text("Mon compte"),
        child: IconButton(
          icon: Icon(Icons.logout_outlined),
          onPressed: () => FirebaseAuth.instance.signOut().then(
            (value) {
              GoogleSignIn().signOut();
              ModelMethods.initDb(drop: true);
            },
          ),
        ));
  }
}
