// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class CellarModel with ChangeNotifier {
//   Future<List<QueryDocumentSnapshot>?> _cellar = FirebaseFirestore.instance
//       .collection('cellars')
//       .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//       .where("enabled", isEqualTo: true)
//       .get()
//       .then((collection) {
//     print("load");
//     return collection.docs;
//   });

//   Future<List<QueryDocumentSnapshot>?> get cellar => _cellar;
// }

// class Cellar {
//   String id;
//   String name;

//   Cellar({required this.id, required this.name});

//   factory Cellar.fromJson(Map<String, dynamic> json) => _$CellarFromJson(json);

//   Map<dynamic, dynamic> toJson() => _$CellarFromJson(this);

//   factory Cellar.fromFirestore(DocumentSnapshot documentSnapshot) {
//     Cellar cellar = Cellar.fromJson(documentSnapshot.s);
//     cellar.id = documentSnapshot.documentId;
//     return cellar;
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cellar.g.dart';

@JsonSerializable()
class Cellar {
  String id;
  String name;

  Cellar({required this.id, required this.name});

  factory Cellar.fromJson(Map<String, dynamic> json) => _$CellarFromJson(json);

  Map<dynamic, dynamic> toJson() => _$CellarToJson(this);

  factory Cellar.fromFirestore(DocumentSnapshot documentSnapshot) {
    var data = documentSnapshot.data() as Map<String, dynamic>;

    data['id'] = documentSnapshot.reference.id;

    Cellar cellar = Cellar.fromJson(data);
    return cellar;
  }
}
