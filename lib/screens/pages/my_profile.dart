import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/user_provider.dart';
import 'package:week7_networking_discussion/screens/user/modal_user.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController _bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    User? user = context.watch<AuthProvider>().user;

    // filter the current user using the id
    Stream<QuerySnapshot> userStream =
        db.collection("users").where("id", isEqualTo: user?.uid).snapshots();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          title: const Text("User Pofile"),
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
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text("No Users Found"),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: ((context, index) {
                UserModel user = UserModel.fromJson(
                    snapshot.data?.docs[index].data() as Map<String, dynamic>);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                Colors.grey,
                                Colors.black,
                              ])),
                          child: SizedBox(
                            width: double.infinity,
                            height: 350.0,
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
                                  Card(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 5.0),
                                    clipBehavior: Clip.antiAlias,
                                    color: Colors.white,
                                    elevation: 5.0,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 22.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () => Navigator.pushNamed(
                                                  context, '/friends'),
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    "Friends",
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          33, 33, 33, 1),
                                                      fontSize: 22.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Text(
                                                    user.friends!.length
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Color.fromRGBO(
                                                          33, 33, 33, 1),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  "Location",
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        33, 33, 33, 1),
                                                    fontSize: 22.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  user.location,
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Color.fromRGBO(
                                                        33, 33, 33, 1),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  "Birthdate",
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        33, 33, 33, 1),
                                                    fontSize: 22.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  user.birthdateInput,
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Color.fromRGBO(
                                                        33, 33, 33, 1),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30.0, horizontal: 16.0),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Bio',
                              // textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(33, 33, 33, 1),
                                letterSpacing: 1.0,
                                height: 1.7,
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              user.bio,
                              // textAlign: TextAlign.right,
                              style: const TextStyle(
                                // fontSize: 12.0,
                                fontStyle: FontStyle.italic,
                                color: Color.fromRGBO(33, 33, 33, 1),
                                letterSpacing: 1.0,
                                height: 1.7,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.all(20),
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(fontSize: 20),
                            backgroundColor: Colors.grey[900]),
                        child: const Text("Update Bio"),
                        onPressed: () => updateBio(user),
                      )
                    ],
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }

  // update the bio of the currently logged in user
  updateBio(UserModel user) {
    _bioController.text = user.bio;

    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          // Get available height and width of the build area of this widget. Make a choice depending on the size.

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: const Text(
            "Update Bio",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: _bioController,
              decoration: const InputDecoration(
                labelText: "Enter Bio",
                // icon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Bio field cannot be empty!';
                }
                return null;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  context
                      .read<UserProvider>()
                      .changeUserBio(_bioController.text);

                  // Remove dialog after editing user bio
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'Update Bio',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
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
