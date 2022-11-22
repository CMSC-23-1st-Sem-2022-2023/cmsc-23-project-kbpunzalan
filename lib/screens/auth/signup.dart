// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:email_validator/email_validator.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    //! added specifications (first name and last name text fields)
    final firstName = TextFormField(
      key: const Key('fNameField'),
      controller: firstNameController,
      decoration: const InputDecoration(
        hintText: 'First Name',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'First name field cannot be empty!';
        }
        return null;
      },
    );

    final lastName = TextFormField(
      key: const Key('lNameField'),
      controller: lastNameController,
      decoration: const InputDecoration(
        hintText: 'Last Name',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Last name field cannot be empty!';
        }
        return null;
      },
    );

    final email = TextFormField(
      controller: emailController,
      decoration: const InputDecoration(
        hintText: "Email",
      ),
      // autovalidate package (check dependencies)
      validator: (value) {
        if (!EmailValidator.validate(value)) {
          return "Please enter a valid email";
        }
        return null;
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
              firstNameController.text,
              lastNameController.text,
              emailController.text,
              passwordController.text);
        }
      },
      child: const Text('Let\'s Do This!'),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Form(
          key: formKey,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            children: <Widget>[
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
              const SizedBox(height: 10),
              firstName,
              lastName,
              email,
              password,
              const SizedBox(height: 20),
              signupButton,
              backButton
            ],
          ),
        ),
      ]),
    );
  }
}
