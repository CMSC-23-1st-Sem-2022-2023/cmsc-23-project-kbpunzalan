import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/user_model.dart';
import 'package:week7_networking_discussion/providers/user_provider.dart';
import 'package:week7_networking_discussion/screens/user/modal_user.dart';
import 'package:substring_highlight/substring_highlight.dart';
import '../providers/auth_provider.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final TextEditingController searchFriend = TextEditingController();

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
                          // let the main user be the first user (index 0)
                          User mainUser = User.fromJson(snapshot.data?.docs[0]
                              .data() as Map<String, dynamic>);

                          User otherUsers = User.fromJson(
                              snapshot.data?.docs[index].data()
                                  as Map<String, dynamic>);

                          // treat the document with "sampleid1" as its id to be the main user
                          // do not include the main user in the list builder
                          // not case sensitive
                          if (otherUsers.id != mainUser.id &&
                              searchFriend.text != "" &&
                              otherUsers.username.toLowerCase().contains(
                                    searchFriend.text.toLowerCase(),
                                  )) {
                            print("FIRST USER: ${mainUser.id}");
                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.people),
                                title: Text("${otherUsers.name}"),
                                subtitle: SubstringHighlight(
                                  text: otherUsers.username,
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
    );
  }

  Widget buildTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          onPressed: () {
            // clear search
            controller.clear();
            setState(() {
              controller.text;
            });
          },
          icon: const Icon(Icons.clear),
        ), // Show the clear button if the text field has something
        hintText: 'Search User',
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
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
      User user, String type, String text1, Color color, Color color2) {
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
  Widget twoButtonStatus(User user) {
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
      User user, String type, String text, Color bg, Color textColor) {
    return SingleChildScrollView(
        child: textButtonStyle(user, type, text, bg, textColor));
  }

  // the button that will appear depends on the contents of the array in the database
  // if the userid is not present in all the arrays, the default "Add User" will be prompted
  Widget textButtonPerUser(User user, User mainUser) {
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
}
