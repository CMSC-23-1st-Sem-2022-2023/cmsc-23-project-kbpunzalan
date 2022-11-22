import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:date_field/date_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController birthdateController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController userNameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    final name = TextFormField(
      key: const Key('nameField'),
      controller: nameController,
      decoration: const InputDecoration(
        hintText: 'Name',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Name field cannot be empty!';
        }
        return null;
      },
    );

    final location = TextFormField(
      key: const Key('locationField'),
      controller: locationController,
      decoration: const InputDecoration(
        hintText: 'Location',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Location field cannot be empty!';
        }
        return null;
      },
    );

    final userName = TextFormField(
      key: const Key('usernameField'),
      controller: userNameController,
      decoration: const InputDecoration(
        hintText: 'Username',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Username field cannot be empty!';
        }
        return null;
      },
    );

    final dateInput = DateTimeFormField(
      key: const Key('dateField'),
      decoration: const InputDecoration(
        hintStyle: TextStyle(color: Colors.black),
        labelText: 'Birthdate',
      ),
      mode: DateTimeFieldPickerMode.date,
      validator: (value) {
        // TODO: change to string
        if (value == null) {
          return "Birthdate field cannot be empty!";
        } else {
          birthdateController.text = value.toString();
          return null;
        }
      },
    );

    final password = TextFormField(
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
      validator: (value) {
        // requirement is at least 6 characters
        if (value!.length < 6) {
          return 'Password must be at least 6 characters long!';
        }
        return null;
      },
    );

    final backButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Go Back', style: TextStyle(color: Colors.white)),
      ),
    );

    final signupButton = TextButton(
      style: TextButton.styleFrom(
          backgroundColor: Colors.black,
          padding: const EdgeInsets.all(16.0),
          textStyle: const TextStyle(fontSize: 20),
          foregroundColor: Colors.white),
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          //check if form data are valid,
          // your process task ahed if all data are valid
          //call the auth provider here
          Navigator.pop(context);
          context.read<AuthProvider>().signUp(
                nameController.text,
                birthdateController.text,
                locationController.text,
                userNameController.text,
                passwordController.text,
              );
        }
      },
      child: const Text('Let\'s Do This!'),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 40.0, right: 40.0),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/todo.png',
                      height: 90,
                      width: 90,
                    ),
                    const Text(
                      "Sign Up",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                        // color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            name,
            dateInput,
            location,
            userName,
            password,
            const SizedBox(height: 20),
            signupButton,
            backButton
          ],
        ),
      ),
    );
  }
}
