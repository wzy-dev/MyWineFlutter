import 'package:firebase_auth/firebase_auth.dart';
import 'package:mywine/shelf.dart';
import 'package:uuid/uuid.dart';

class InitializerModel {
  static User? _user = FirebaseAuth.instance.currentUser;

  static int getTimestamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static String generateUuid() {
    return Uuid().v4();
  }

  static Cellar initCellar({required String name}) {
    int timestamp = getTimestamp();
    return Cellar(
      id: generateUuid(),
      createdAt: timestamp,
      editedAt: timestamp,
      name: name,
      owner: _user!.uid,
    );
  }

  static Block initBlock({
    required String cellar,
    String horizontalAlignment = "center",
    String verticalAlignment = "center",
    required int nbColumn,
    required int nbLine,
    required int x,
    required int y,
  }) {
    int timestamp = getTimestamp();
    return Block(
      id: generateUuid(),
      createdAt: timestamp,
      editedAt: timestamp,
      cellar: cellar,
      horizontalAlignment: horizontalAlignment,
      verticalAlignment: verticalAlignment,
      nbColumn: nbColumn,
      nbLine: nbLine,
      x: x,
      y: y,
      owner: _user!.uid,
    );
  }

  static Position initPosition({
    required String block,
    required String wine,
    required int x,
    required int y,
  }) {
    int timestamp = getTimestamp();
    return Position(
      id: generateUuid(),
      createdAt: timestamp,
      editedAt: timestamp,
      block: block,
      wine: wine,
      x: x,
      y: y,
      owner: _user!.uid,
    );
  }

  static Appellation initAppellation({
    required String color,
    required String name,
    required String region,
    String? label,
    int? tempmin,
    int? tempmax,
    int? yearmin,
    int? yearmax,
  }) {
    int timestamp = getTimestamp();
    return Appellation(
      id: generateUuid(),
      createdAt: timestamp,
      editedAt: timestamp,
      color: color,
      name: name,
      region: region,
      tempmin: tempmin,
      tempmax: tempmax,
      yearmin: yearmin,
      yearmax: yearmax,
      owner: _user!.uid,
    );
  }

  static Region initRegion({
    required String name,
    required String country,
  }) {
    int timestamp = getTimestamp();
    return Region(
      id: generateUuid(),
      createdAt: timestamp,
      editedAt: timestamp,
      name: name,
      country: country,
      owner: _user!.uid,
    );
  }

  static Country initCountry({
    required String name,
  }) {
    int timestamp = getTimestamp();
    return Country(
      id: generateUuid(),
      createdAt: timestamp,
      editedAt: timestamp,
      name: name,
      owner: _user!.uid,
    );
  }

  static Domain initDomain({
    required String name,
  }) {
    int timestamp = getTimestamp();
    return Domain(
      id: generateUuid(),
      createdAt: timestamp,
      editedAt: timestamp,
      name: name,
      owner: _user!.uid,
    );
  }

  static Wine initWine({
    required String appellation,
    required String domain,
    required int quantity,
    required int millesime,
    required int size,
    bool bio = false,
    bool sparkling = false,
    int? tempmin,
    int? tempmax,
    int? yearmin,
    int? yearmax,
  }) {
    int timestamp = getTimestamp();
    return Wine(
      id: generateUuid(),
      createdAt: timestamp,
      editedAt: timestamp,
      appellation: appellation,
      domain: domain,
      quantity: quantity,
      millesime: millesime,
      size: size,
      bio: bio,
      sparkling: sparkling,
      tempmin: tempmin,
      tempmax: tempmax,
      yearmin: yearmin,
      yearmax: yearmax,
      owner: _user!.uid,
    );
  }
}
