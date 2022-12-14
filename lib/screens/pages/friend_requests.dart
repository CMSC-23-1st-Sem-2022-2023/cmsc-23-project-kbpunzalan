import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/user_model.dart';
import 'package:week7_networking_discussion/providers/user_provider.dart';
import 'package:week7_networking_discussion/screens/user/modal_user.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../../providers/auth_provider.dart';

class FriendsRequests extends StatefulWidget {
  const FriendsRequests({super.key});

  @override
  State<FriendsRequests> createState() => _FriendsRequestsState();
}

class _FriendsRequestsState extends State<FriendsRequests> {
  final TextEditingController searchFriend = TextEditingController();

  var mainUserData;

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    searchFriend.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    searchFriend.dispose();
    super.dispose();
  }

  void _printLatestValue() {
    print('Text Field Value: ${searchFriend.text}');
  }

  @override
  Widget build(BuildContext context) {
    // access the list of users in the provider
    Stream<QuerySnapshot> userStream = context.watch<UserProvider>().users;

    User? user = context.read<AuthProvider>().user;

    final FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection('users').doc(user?.uid).snapshots().listen((userData) {
      mainUserData = userData.data();
    });

    return SafeArea(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey[900],
            title: const Text("Friend Requests"),
          ),
          body: StreamBuilder(
            stream: userStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error encountered! ${snapshot.error}"),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!snapshot.hasData || snapshot.data?.docs.length == 4) {
                return const Center(
                  child: Text("No Users"),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 200.0,
                        child: ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: ((context, index) {
                            UserModel mainUser =
                                UserModel.fromJson(mainUserData);

                            UserModel otherUsers = UserModel.fromJson(
                                snapshot.data?.docs[index].data()
                                    as Map<String, dynamic>);

                            // show all users who added you
                            // do not include the main user in the list builder
                            // not case sensitive
                            if (otherUsers.id != mainUser.id &&
                                mainUser.receivedFriendRequests!
                                    .contains(otherUsers.id)) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                shadowColor: Colors.grey[900],
                                child: ListTile(
                                  leading: const Icon(Icons.people),
                                  title: Text(
                                      "${otherUsers.firstName} ${otherUsers.lastName}"),
                                  subtitle: SubstringHighlight(
                                    text: "@${otherUsers.username}",
                                    term: searchFriend.text,
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      textButtonPerUser(otherUsers, mainUser)
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              // must be the main user, non-empty, and contains the searched string
                              return const SizedBox.shrink();
                            }
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // when user clicked, it will alrt the show dialog, and will do certain actions (add user, delete) provided by the modal
  Widget textButtonStyle(
      UserModel user, String type, String text1, Color color, Color color2) {
    return TextButton(
      onPressed: () {
        context.read<UserProvider>().changeSelectedUser(user);
        showDialog(
          context: context,
          builder: (BuildContext context) => UserModal(
            type: type,
          ),
        );
      },
      style: TextButton.styleFrom(
          foregroundColor: color2,
          textStyle: const TextStyle(fontSize: 13),
          backgroundColor: color),
      child: Text(text1),
    );
  }

  // for the text button on accept and reject user
  Widget twoButtonStatus(UserModel user) {
    return SingleChildScrollView(
      child: Row(
        children: [
          textButtonStyle(user, "Confirm", "Confirm", Colors.blue.shade100,
              Colors.blue.shade700),
          const SizedBox(width: 10),
          textButtonStyle(user, "Reject", "Reject", Colors.red.shade100,
              Colors.red.shade700),
        ],
      ),
    );
  }

  // the button that will appear depends on the contents of the array in the database
  // if the userid is not present in all the arrays, the default "Add User" will be prompted
  Widget textButtonPerUser(UserModel user, UserModel mainUser) {
    return twoButtonStatus(user);
  }
}
