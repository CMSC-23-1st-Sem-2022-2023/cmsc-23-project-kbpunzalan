import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          ListTile(
              leading: const Icon(
                Icons.person,
                color: Colors.black,
              ),
              title: const Text(
                'Profile',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () => Navigator.pushNamed(context, '/user-profile')),
          ListTile(
            leading: const Icon(
              Icons.people_alt_sharp,
              color: Colors.black,
            ),
            title: const Text(
              'Friends',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () => Navigator.pushNamed(context, '/friends'),
          ),
          ListTile(
            leading: const Icon(
              Icons.person_add_alt_sharp,
              color: Colors.black,
            ),
            title: const Text(
              'Friend Requests',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () => Navigator.pushNamed(context, '/friend-requests'),
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              context.read<AuthProvider>().signOut();
            },
          ),
        ],
      ),
    );
  }
}
