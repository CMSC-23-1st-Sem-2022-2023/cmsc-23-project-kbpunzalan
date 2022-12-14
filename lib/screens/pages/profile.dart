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
          buildListTile(Icons.person, 'Profile', '/user-profile'),
          buildListTile(Icons.notifications_active_sharp, 'Notification', '/'),
          buildListTile(Icons.people_alt_sharp, 'Friends', '/friends'),
          buildListTile(Icons.person_add_alt_sharp, 'Friend Requests',
              '/friend-requests'),
          buildListTile(Icons.logout, 'Logout', '/logout'),
        ],
      ),
    );
  }

  // friends profile
  buildListTile(IconData icon, String title, String route) {
    return ListTile(
        leading: Icon(
          icon,
          color: Colors.black,
        ),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        onTap: () => (route == '/logout')
            ? context.read<AuthProvider>().signOut()
            : Navigator.pushNamed(context, route));
  }
}
