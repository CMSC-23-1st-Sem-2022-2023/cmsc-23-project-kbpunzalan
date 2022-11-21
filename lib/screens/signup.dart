import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:email_validator/email_validator.dart';
import '../providers/auth_provider.dart';

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

    final signupButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            //check if form data are valid,
            // your process task ahed if all data are valid
            //call the auth provider here
            context.read<AuthProvider>().signUp(
                firstNameController.text,
                lastNameController.text,
                emailController.text,
                passwordController.text);
            Navigator.pop(context);
          }
        },
        child: const Text('Sign up', style: TextStyle(color: Colors.white)),
      ),
    );

    final backButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.pop(context);
        },
        child: const Text('Back', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: formKey,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            children: <Widget>[
              const Text(
                "Sign Up",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              firstName,
              lastName,
              email,
              password,
              signupButton,
              backButton
            ],
          ),
        ),
      ),
    );
  }
}
