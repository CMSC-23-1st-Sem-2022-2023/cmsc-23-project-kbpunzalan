import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:week7_networking_discussion/api/firebase_auth_api.dart';

// auth provide with change notifier
class AuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  User? userObj; // will hold the data of user that is already logged in

  // constructor
  AuthProvider() {
    authService = FirebaseAuthAPI();
    authService.getUser().listen((User? newUser) {
      // continuous stream of data
      // if there are changes, it will automatically reflect

      // checks if logged in, magkakaroon ng laman si newUser, we pass it to userObj
      // notify the listeners
      userObj = newUser;
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $newUser');
      notifyListeners();
    }, onError: (e) {
      // if there are errors
      // provide a more useful error
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $e');
    });
  }

  User? get user => userObj;

  // check if logged in
  // use the getter
  bool get isAuthenticated {
    return user != null;
  }

  void signIn(String email, String password) {
    authService.signIn(email, password);
  }

  void signOut() {
    authService.signOut();
  }

  void signUp(
      String firstName, String lastName, String email, String password) {
    authService.signUp(firstName, lastName, email, password);
  }
}
