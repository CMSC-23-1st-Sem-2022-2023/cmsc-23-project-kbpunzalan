import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  // returns streram of data of type user
  Stream<User?> getUser() {
    return auth.authStateChanges();
  }

  // checks the email and password of the user
  void signIn(String email, String password) async {
    UserCredential credential;
    try {
      // is it possible to sign in using the email and password
      // will wait for the credential (await)
      // returns user credentials: access email, id, etc.
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // error: not found (not yet registered)
        //possible to return something more useful
        //than just print an error message to improve UI/UX
        print('No user found for that email.');
        // return future string if we want to return something
      } else if (e.code == 'wrong-password') {
        // wrong password
        print('Wrong password provided for that user.');
      }
    }
  }

  // new user - register
  void signUp(
    String name,
    String birthdate,
    String location,
    String username,
    String password,
  ) async {
    UserCredential credential;
    try {
      // create a user
      // returns user credential if successfully created user
      credential = await auth.createUserWithEmailAndPassword(
        email:
            username, // TODO: change to username only (not email and password)
        password: password,
      );
      if (credential.user != null) {
        // if user is created
        // method defined to save user in the database
        saveUserToFirestore(
            credential.user?.uid, name, birthdate, location, username);
      }
    } on FirebaseAuthException catch (e) {
      //possible to return something more useful
      //than just print an error message to improve UI/UX
      if (e.code == 'weak-password') {
        // less than 6 characters (more than 6 characters are required)
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        // email is already in use?
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  // signout is already abstracted
  void signOut() async {
    auth.signOut();
  }

  void saveUserToFirestore(String? uid, String name, String birthdate,
      String location, String username) async {
    try {
      // uid is the generated user id
      // add all fields in the users database
      final userData = {
        "id": uid,
        "name": name,
        "birthdate": birthdate,
        "location": location,
        "username": username,
        "sentFriendRequests": [],
        "receivedFriendRequests": [],
        "friends": [],
      };
      await db
          .collection("users")
          .doc(uid)
          .set(userData)
          .then((value) => print("User Added"))
          .catchError(
            (error) => print("Failed to add user: $error"),
          );
      // await db.collection("users").doc(uid).set({"lastName": lastName});
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }
}
