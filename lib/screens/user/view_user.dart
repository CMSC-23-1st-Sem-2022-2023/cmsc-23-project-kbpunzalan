import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';

class ViewUser extends StatefulWidget {
  ViewUser({super.key});

  @override
  // UserModel user;
  State<ViewUser> createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog();
  }

  viewUser(UserModel user) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

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
                container("Bio", user.email),
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
