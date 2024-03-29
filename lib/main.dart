/*
  Author: Kurt Brian Daine B. Punzalan
  Section: C4-L
  Date Created: November 21, 2022
  Project
  Program Description: User Authentication and Automated Tests
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/screens/pages/feed.dart';
import 'package:week7_networking_discussion/screens/auth/signup.dart';
import 'package:week7_networking_discussion/screens/pages/friend_requests.dart';
import 'package:week7_networking_discussion/screens/pages/friends.dart';
import 'package:week7_networking_discussion/screens/todo/friend_todo_page.dart';
import 'package:week7_networking_discussion/screens/todo/todo_page.dart';
import 'package:week7_networking_discussion/screens/auth/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/pages/homepage.dart';
import 'screens/pages/my_profile.dart';
import 'firebase_options.dart';

import 'package:week7_networking_discussion/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => TodoListProvider())),
        ChangeNotifierProvider(create: ((context) => AuthProvider())),
        ChangeNotifierProvider(create: ((context) => UserProvider())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SimpleTodo',
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/signup': (context) => const SignupPage(),
        '/login': (context) => const LoginPage(),
        '/user-profile': (context) => const UserProfile(),
        '/friends': (context) => const FriendsPage(),
        '/friend-requests': (context) => const FriendsRequests(),
        '/friend-todos': (context) => const FriendTodoPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.watch<AuthProvider>().isAuthenticated) {
      return const Feed();
    } else {
      return const HomePage();
    }
  }
}
