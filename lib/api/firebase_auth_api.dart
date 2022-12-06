import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// fake : for testing
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

class FirebaseAuthAPI {
  // instance of firebase auth
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  // final db = FakeFirebaseFirestore();

  // final auth = MockFirebaseAuth(
  //     mockUser: MockUser(
  //   isAnonymous: false,
  //   uid: 'someuid',
  //   email: 'charlie@paddyspub.com',
  //   displayName: 'Charlie',
  // ));

  // get the auth state changes
  // auth state change: notifies about changes from the user sign in stage
  // if user is signed in or signed out
  // returns stream of data of type user
  Stream<User?> getUser() {
    return auth.authStateChanges();
  }

  // checks the email and password of the user
  Future<String> signIn(String email, String password) async {
    // UserCredential credential;
    try {
      // is it possible to sign in using the email and password
      // will wait for the credential (await)
      // returns user credentials: access email, id, etc.
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return "";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // error: not found (not yet registered)
        //possible to return something more useful
        //than just print an error message to improve UI/UX
        return 'No user found for that email.';
        // return future string if we want to return something
      } else if (e.code == 'wrong-password') {
        // wrong password
        return 'Wrong password provided for that user.';
      }
    }

    return "";
  }

  // new user - register
  Future<String> signUp(
    String firstName,
    String lastName,
    String username,
    String birthdate,
    String location,
    String email,
    String password,
  ) async {
    UserCredential credential;
    try {
      // create a user
      // returns user credential if successfully created user
      credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        // if user is created
        // method defined to save user in the database

        saveUserToFirestore(credential.user?.uid, firstName, lastName, username,
            birthdate, location, email);

        return "";
      }
    } on FirebaseAuthException catch (e) {
      //possible to return something more useful
      //than just print an error message to improve UI/UX
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        // email is already in use?
        return 'The account already exists for that email.';
      }
    } catch (e) {
      print(e);
    }

    return "";
  }

  // signout is already abstracted
  void signOut() async {
    auth.signOut();
  }

  void saveUserToFirestore(
    String? uid,
    String firstName,
    String lastName,
    String username,
    String birthdateInput,
    String location,
    String email,
  ) async {
    try {
      // uid is the generated user id
      // add all fields in the users database
      final userData = {
        "id": uid,
        "firstName": firstName,
        "lastName": lastName,
        "username": username,
        "birthdateInput": birthdateInput,
        "location": location,
        "email": email,
        "sentFriendRequests": [],
        "receivedFriendRequests": [],
        "friends": [],
        "bio": // sample bio
            "Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia, molestiae quas vel sint commodi repudiandae",
      };
      await db
          .collection("users")
          .doc(uid)
          .set(userData)
          .then((value) => print("User Added"))
          .catchError(
            (error) => print("Failed to add user: $error"),
          );

      final DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now); // fo
      print(formattedDate); // something like 2013-04-20

      // add a new collection for the todo of each user with a sample todo
      final todo = {
        "title": "Sample todo",
        "description": "sample description",
        "status": false,
        "deadline": formattedDate,
        // "userId": uid,
      };

      final docRef =
          await db.collection("users").doc(uid).collection("todos").add(todo);

      // add its id
      await db
          .collection("users")
          .doc(uid)
          .collection("todos")
          .doc(docRef.id)
          .update({"id": docRef.id});
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }
}
