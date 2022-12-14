import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:week7_networking_discussion/models/user_model.dart';

class FirebaseUserAPI {
  // maaaccess using db
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // returns stream of query snapshots

  Stream<QuerySnapshot> getAllUsers() {
    User? user = auth.currentUser;

    return db.collection("users").snapshots();
  }

  // remove id from the list
  Future<String> removefromListChangeHandler(
      String? id, String? firstUser, String list, String message) async {
    var collection = FirebaseFirestore.instance.collection('users');
    await collection.doc(firstUser).update({
      list: FieldValue.arrayRemove([id]),
    });

    return "Successfully $message $id from $list of $firstUser";
  }

  // add user id to the list
  Future<String> addToListChangeHandler(
      String? id, String? firstUser, String list, String message) async {
    var collection = FirebaseFirestore.instance.collection('users');
    await collection.doc(firstUser).update({
      list: FieldValue.arrayUnion([id]),
    });

    return "Successfully $message $id from $list of $firstUser";
  }

  // change the bio of the currently logged in user (in the profile)
  Future<String> changeUserBio(String? id, String bio) async {
    var collection = FirebaseFirestore.instance.collection('users');
    await collection.doc(id).update({'bio': bio});

    return "Successfully edited bio of $id";
  }
}
