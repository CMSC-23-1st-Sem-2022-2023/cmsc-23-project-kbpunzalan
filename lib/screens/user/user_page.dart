import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/user_model.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/providers/user_provider.dart';
import 'package:week7_networking_discussion/screens/user/modal_user.dart';
import 'package:substring_highlight/substring_highlight.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
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
      child: Scaffold(
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
                  buildTextField(searchFriend), // search field (textfield)
                  Expanded(
                    child: SizedBox(
                      height: 200.0,
                      child: ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: ((context, index) {
                          UserModel mainUser = UserModel.fromJson(mainUserData);

                          UserModel otherUsers = UserModel.fromJson(
                              snapshot.data?.docs[index].data()
                                  as Map<String, dynamic>);
                          // let the main user be the first user (index 0)

                          // treat the document with "sampleid1" as its id to be the main user
                          // do not include the main user in the list builder
                          // not case sensitive
                          if (otherUsers.id != mainUser.id &&
                              searchFriend.text != "" &&
                              otherUsers.username.toLowerCase().contains(
                                    searchFriend.text.toLowerCase(),
                                  )) {
                            return GestureDetector(
                              onTap: () => viewUser(otherUsers),
                              child: Card(
                                // color: Colors.grey[200],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                shadowColor: Colors.grey[900],
                                margin: const EdgeInsets.all(10.0),
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
    );
  }

  Widget buildTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon:
            const Icon(Icons.search, color: Color.fromRGBO(66, 66, 66, 1)),
        suffixIcon: IconButton(
          onPressed: () {
            // clear search
            controller.clear();
            setState(() {
              controller.text;
            });
          },
          icon: const Icon(
            Icons.clear,
            color: Color.fromRGBO(66, 66, 66, 1),
          ),
        ), // Show the clear button if the text field has something
        hintText: 'Search User',
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromRGBO(33, 33, 33, 1), width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromRGBO(33, 33, 33, 1), width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
      ),
      onChanged: (value) {
        setState(() {
          value = searchFriend.text;
        });
      },
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

  // rest of the text buttons
  Widget singleButtonStatus(
      UserModel user, String type, String text, Color bg, Color textColor) {
    return SingleChildScrollView(
        child: textButtonStyle(user, type, text, bg, textColor));
  }

  // the button that will appear depends on the contents of the array in the database
  // if the userid is not present in all the arrays, the default "Add User" will be prompted
  Widget textButtonPerUser(UserModel user, UserModel mainUser) {
    if (mainUser.receivedFriendRequests!.contains(user.id)) {
      return twoButtonStatus(user);
    } else if (mainUser.friends!.contains(user.id)) {
      return singleButtonStatus(user, "Unfriend", "Unfriend",
          Colors.red.shade100, Colors.red.shade700);
    } else if (mainUser.sentFriendRequests!.contains(user.id)) {
      return singleButtonStatus(user, "Cancel Request", "Cancel Request",
          Colors.red.shade100, Colors.red.shade700);
    } else {
      // not in any list (user is not yet added)
      return singleButtonStatus(user, "Add Friend", "Add User",
          Colors.blue.shade100, Colors.blue.shade700);
    }
  }

  Widget container(String title, String userFielData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            // textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(33, 33, 33, 1),
              letterSpacing: 1.0,
              height: 1.7,
            ),
          ),
          Text(
            userFielData,
            // textAlign: TextAlign.right,
            style: const TextStyle(
              // fontSize: 12.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,
              color: Color.fromRGBO(33, 33, 33, 1),
              letterSpacing: 1.0,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  viewUser(UserModel user) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          // Get available height and width of the build area of this widget. Make a choice depending on the size.
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          content: SizedBox(
            height: height,
            width: width,
            child: ListView(
              children: <Widget>[
                Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.grey,
                              Colors.black,
                            ])),
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.grey[900],
                                child: Text(
                                  "${user.firstName[0]}${user.lastName[0]}",
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                                radius: 50,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "${user.firstName} ${user.lastName}",
                                style: TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "${user.id}",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                container("Birthdate", user.birthdateInput),
                container("Location", user.location),
                container("Bio", user.bio),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
