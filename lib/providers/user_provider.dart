import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/models/user_model.dart';
import '../api/firebase_user_api.dart';

class UserProvider with ChangeNotifier {
  late FirebaseUserAPI firebaseService;
  UserModel? _selectedUser;

  late Stream<QuerySnapshot> _userStream;
  final FirebaseAuth auth = FirebaseAuth.instance;

  UserProvider() {
    firebaseService = FirebaseUserAPI();
    fetchUsers();
  }

  Stream<QuerySnapshot> get users => _userStream;
  UserModel get selected => _selectedUser!;

  fetchUsers() {
    _userStream = firebaseService.getAllUsers();
    notifyListeners();
  }

  changeSelectedUser(UserModel item) {
    _selectedUser = item;
  }

  // cancel the request of the main yser
  void cancelRequest() async {
    String mainUserId = auth.currentUser!.uid;

    String receivedFriendMessage =
        await firebaseService.removefromListChangeHandler(
            _selectedUser!.id, mainUserId, "sentFriendRequests", "removed");
    print(receivedFriendMessage);

    String sentFriendMessage =
        await firebaseService.removefromListChangeHandler(
            mainUserId, _selectedUser!.id, "receivedFriendRequests", "removed");
    print(sentFriendMessage);

    notifyListeners();
  }

  // add a user
  void addUser() async {
    String mainUserId = auth.currentUser!.uid;

    String added1 = await firebaseService.addToListChangeHandler(
        _selectedUser!.id, mainUserId, "sentFriendRequests", "added");
    print(added1);

    String added2 = await firebaseService.addToListChangeHandler(
        mainUserId, _selectedUser!.id, "receivedFriendRequests", "added");
    print(added2);

    notifyListeners();
  }

  // reject a user
  void rejectUser() async {
    String mainUserId = auth.currentUser!.uid;

    String receivedFriendMessage =
        await firebaseService.removefromListChangeHandler(
            _selectedUser!.id, mainUserId, "receivedFriendRequests", "removed");
    print(receivedFriendMessage);

    String sentFriendMessage =
        await firebaseService.removefromListChangeHandler(
            mainUserId, _selectedUser!.id, "sentFriendRequests", "removed");
    print(sentFriendMessage);

    notifyListeners();
  }

  // be friends with the user
  void acceptUser() async {
    String mainUserId = auth.currentUser!.uid;

    String added1 = await firebaseService.addToListChangeHandler(
        _selectedUser!.id, mainUserId, "friends", "added");
    print(added1);

    String added2 = await firebaseService.addToListChangeHandler(
        mainUserId, _selectedUser!.id, "friends", "added");
    print(added2);

    // remove from sentFriendRequests and receivedFriendRequests after adding to the friends list
    rejectUser();

    notifyListeners();
  }

  // unfriend a user
  void unfriendUser() async {
    String mainUserId = auth.currentUser!.uid;

    String remove1 = await firebaseService.removefromListChangeHandler(
        _selectedUser!.id, mainUserId, "friends", "removed");
    print(remove1);

    String remove2 = await firebaseService.removefromListChangeHandler(
        mainUserId, _selectedUser!.id, "friends", "removed");
    print(remove2);

    notifyListeners();
  }

  // update the bio of the currently logged in user
  void changeUserBio(String bio) async {
    String mainUserId = auth.currentUser!.uid;

    String changedBio = await firebaseService.changeUserBio(mainUserId, bio);
    print(changedBio);
  }
}
