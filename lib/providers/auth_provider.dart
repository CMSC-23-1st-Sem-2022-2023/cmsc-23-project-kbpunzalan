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

  Future<String> signIn(String email, String password) {
    return authService.signIn(email, password);
  }

  void signOut() {
    authService.signOut();
  }

  Future<String> signUp(String firstName, String lastName, String username,
      String birthdate, String location, String email, String password) {
    return authService.signUp(
        firstName, lastName, username, birthdate, location, email, password);
  }

  getMainUser(User user) {
    userObj = user;
  }
}
