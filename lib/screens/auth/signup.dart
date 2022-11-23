import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:date_field/date_field.dart';
import 'package:email_validator/email_validator.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool hasNumber(String value) {
    String pattern = r'[0-9]';
    RegExp regExp = RegExp(pattern);
    if (regExp.hasMatch(value)) {
      return true;
    }
    return false;
  }

  bool hasLowercase(String value) {
    String pattern = r'[a-z]';
    RegExp regExp = RegExp(pattern);
    if (regExp.hasMatch(value)) {
      return true;
    }
    return false;
  }

  bool hasUppercase(String value) {
    String pattern = r'[A-Z]';
    RegExp regExp = RegExp(pattern);
    if (regExp.hasMatch(value)) {
      return true;
    }
    return false;
  }

  bool specialCharacter(String value) {
    // TODO: revise regex for special characters
    String pattern = r'[.+,*?\^\$()\[\]\{\}|, \]';
    RegExp regExp = RegExp(pattern);
    if (regExp.hasMatch(value)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    TextEditingController birthdateController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    final firstName = TextFormField(
      key: const Key('firstNameField'),
      controller: firstNameController,
      decoration: const InputDecoration(
        hintText: 'First Name',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Firstname field cannot be empty!';
        }
        return null;
      },
    );

    final lastName = TextFormField(
      key: const Key('lastNameField'),
      controller: lastNameController,
      decoration: const InputDecoration(
        hintText: 'Last Name',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Lastname field cannot be empty!';
        }
        return null;
      },
    );

    final username = TextFormField(
      key: const Key('usernameField'),
      controller: usernameController,
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

    final email = TextFormField(
      key: const Key('emailField'),
      controller: emailController,
      decoration: const InputDecoration(
        hintText: 'Email',
      ),
      validator: (value) {
        if (!EmailValidator.validate(value!)) {
          return "Please enter a valid email";
        }
        return null;
      },
    );

    final birthdateInput = DateTimeFormField(
      key: const Key('dateField'),
      decoration: const InputDecoration(
        hintStyle: TextStyle(color: Colors.black),
        labelText: 'Birthdate',
      ),
      mode: DateTimeFieldPickerMode.date,
      validator: (value) {
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
        if (value!.length < 8) {
          return 'Password must be at least 8 characters long!';
        }

        if (!hasNumber(value)) {
          return 'Password must have at least 1 number!';
        }

        if (!hasLowercase(value)) {
          return 'Password must have at least 1 lowercase letter!';
        }

        if (!hasUppercase(value)) {
          return 'Password must have at least 1 uppercase letter!';
        }

        // if (!specialCharacter(value)) {
        //   return 'Password must have at least 1 special character!';
        // }
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
                usernameController.text,
                birthdateController.text,
                locationController.text,
                emailController.text,
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
            firstName,
            lastName,
            username,
            birthdateInput,
            location,
            email,
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
