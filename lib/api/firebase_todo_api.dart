import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseTodoAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  // final db = FakeFirebaseFirestore();

  Future<String> addTodo(Map<String, dynamic> todo) async {
    User? user = auth.currentUser;

    try {
      final docRef = await db
          .collection("users")
          .doc(user?.uid)
          .collection("todos")
          .add(todo);

      // add its id
      await db
          .collection("users")
          .doc(user?.uid)
          .collection("todos")
          .doc(docRef.id)
          .update({"id": docRef.id});

      // final docRef = await db.collection("todos").add(todo);
      // await db.collection("todos").doc(docRef.id).update({'id': docRef.id});

      return "Successfully added todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllTodos() {
    User? user = auth.currentUser;

    print("USER ID: ${user?.uid}");
    return db
        .collection("users")
        .doc(user?.uid)
        .collection("todos")
        .snapshots();
  }

  Future<String> deleteTodo(String? id) async {
    User? user = auth.currentUser;

    try {
      // await db.collection("users").doc(id).collection("todos").doc(id).delete();
      await db
          .collection("users")
          .doc(user?.uid)
          .collection("todos")
          .doc(id)
          .delete();

      return "Successfully deleted todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> editTodo(String? id, String newTitle, String newDescription,
      String newDeadline) async {
    User? user = auth.currentUser;

    try {
      // await db.collection("users").doc(id).collection("todos").doc(id).delete();
      final editedData = {
        'title': newTitle,
        'description': newDescription,
        'deadline': newDeadline
      };

      await db
          .collection("users")
          .doc(user?.uid)
          .collection("todos")
          .doc(id)
          .update(editedData);

      return "Successfully edited todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> editStatus(String? id, bool status) async {
    User? user = auth.currentUser;
    print("STATUS: $status");

    final editedData = {'status': status};

    try {
      await db
          .collection("users")
          .doc(user?.uid)
          .collection("todos")
          .doc(id)
          .update(editedData);

      return "Successfully edited status to $status!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
