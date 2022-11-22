import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week7_networking_discussion/models/user_model.dart';

class FirebaseUserAPI {
  // maaaccess using db
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  // returns stream of query snapshots
  Stream<QuerySnapshot> getAllUsers() {
    return db.collection("users").snapshots();
  }

  // sampleid1 is still a placeholder (since it is the first user)
  Future<String> removefromListChangeHandler(
      String? id, String? firstUser, String list, String message) async {
    var collection = FirebaseFirestore.instance.collection('users');
    await collection.doc(firstUser).update({
      list: FieldValue.arrayRemove([id]),
    });

    return "Successfully $message $id from $list of $firstUser";
  }

  // sampleid1 is still a placeholder (since it is the first user)
  Future<String> addToListChangeHandler(
      String? id, String? firstUser, String list, String message) async {
    var collection = FirebaseFirestore.instance.collection('users');
    await collection.doc(firstUser).update({
      list: FieldValue.arrayUnion([id]),
    });

    return "Successfully $message $id from $list of $firstUser";
  }
}
