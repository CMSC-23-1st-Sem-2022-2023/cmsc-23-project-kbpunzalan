import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseTodoAPI {
  // static final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final db = FakeFirebaseFirestore();

  Future<String> addTodo(Map<String, dynamic> todo) async {
    User? user = auth.currentUser;

    try {
      // final docRef = await db
      //     .collection("users")
      //     .doc(user?.uid)
      //     .collection("todos")
      //     .add(todo);

      // // add its id
      // await db
      //     .collection("users")
      //     .doc(user?.uid)
      //     .collection("todos")
      //     .doc(docRef.id)
      //     .update({"id": docRef.id});

      final docRef = await db.collection("todos").add(todo);
      await db.collection("todos").doc(docRef.id).update({'id': docRef.id});

      return "Successfully added todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  // get all todos of the current logged in user
  Stream<QuerySnapshot> getAllTodos() {
    User? user = auth.currentUser;

    print("USER ID: ${user?.uid}");

    var snap =
        db.collection("users").doc(user?.uid).collection("todos").snapshots();
    print("SNAP: $snap");
    return snap;
  }

  // get all todos of a specific friend
  Stream<QuerySnapshot> getFriendAllTodos(String id) {
    var snap = db.collection("users").doc(id).collection("todos").snapshots();
    print(snap);
    return snap;
  }

  // delete a selected todo
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

  // edit selected to do and modify last edited by and last edited date
  Future<String> editTodo(String? id, String newTitle, String newDescription,
      String newDeadline) async {
    User? user = auth.currentUser;

    try {
      // await db.collection("users").doc(id).collection("todos").doc(id).delete();
      final editedData = {
        'title': newTitle,
        'description': newDescription,
        'deadline': newDeadline,
        "lastEditedBy": "${user?.displayName}",
        "lastEditedDate": DateTime.now().toString(),
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

  // a user can edit todo of their friends
  Future<String> editFriendTodo(String selectedUserId, String? id,
      String newTitle, String newDescription, String newDeadline) async {
    User? user = auth.currentUser;

    try {
      // await db.collection("users").doc(id).collection("todos").doc(id).delete();
      final editedData = {
        'title': newTitle,
        'description': newDescription,
        'deadline': newDeadline,
        "lastEditedBy": "${user?.displayName}",
        "lastEditedDate": DateTime.now().toString(),
      };

      await db
          .collection("users")
          .doc(selectedUserId)
          .collection("todos")
          .doc(id)
          .update(editedData);

      return "Successfully edited todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  // main user onlu can edit the status of the todo
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
