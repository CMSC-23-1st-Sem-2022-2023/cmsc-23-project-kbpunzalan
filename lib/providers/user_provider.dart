import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/models/user_model.dart';
import '../api/firebase_user_api.dart';

class UserProvider with ChangeNotifier {
  late FirebaseUserAPI firebaseService;
  User? _selectedUser;

  late Stream<QuerySnapshot> _userStream;

  UserProvider() {
    firebaseService = FirebaseUserAPI();
    fetchUsers();
  }

  Stream<QuerySnapshot> get users => _userStream;
  User get selected => _selectedUser!;

  fetchUsers() {
    _userStream = firebaseService.getAllUsers();
    notifyListeners();
  }

  changeSelectedUser(User item) {
    _selectedUser = item;
  }

  void cancelRequest() async {
    String receivedFriendMessage =
        await firebaseService.removefromListChangeHandler(
            _selectedUser!.id, "sampleid1", "sentFriendRequest", "removed");
    print(receivedFriendMessage);

    String sentFriendMessage =
        await firebaseService.removefromListChangeHandler("sampleid1",
            _selectedUser!.id, "receivedFriendRequests", "removed");
    print(sentFriendMessage);

    notifyListeners();
  }

  void addUser() async {
    String added1 = await firebaseService.addToListChangeHandler(
        _selectedUser!.id, "sampleid1", "sentFriendRequest", "added");
    print(added1);

    String added2 = await firebaseService.addToListChangeHandler(
        "sampleid1", _selectedUser!.id, "receivedFriendRequests", "added");
    print(added2);

    notifyListeners();
  }

  void rejectUser() async {
    String receivedFriendMessage =
        await firebaseService.removefromListChangeHandler(_selectedUser!.id,
            "sampleid1", "receivedFriendRequests", "removed");
    print(receivedFriendMessage);

    String sentFriendMessage =
        await firebaseService.removefromListChangeHandler(
            "sampleid1", _selectedUser!.id, "sentFriendRequest", "removed");
    print(sentFriendMessage);

    notifyListeners();
  }

  void acceptUser() async {
    String added1 = await firebaseService.addToListChangeHandler(
        _selectedUser!.id, "sampleid1", "friends", "added");
    print(added1);

    String added2 = await firebaseService.addToListChangeHandler(
        "sampleid1", _selectedUser!.id, "friends", "added");
    print(added2);

    // remove from sentFriendRequest and receivedFriendRequests after adding to the friends list
    rejectUser();

    notifyListeners();
  }

  void unfriendUser() async {
    String remove1 = await firebaseService.removefromListChangeHandler(
        _selectedUser!.id, "sampleid1", "friends", "removed");
    print(remove1);

    String remove2 = await firebaseService.removefromListChangeHandler(
        "sampleid1", _selectedUser!.id, "friends", "removed");
    print(remove2);

    notifyListeners();
  }
}
