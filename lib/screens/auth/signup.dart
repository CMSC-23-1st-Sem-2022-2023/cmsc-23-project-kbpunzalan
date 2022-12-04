import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:intl/intl.dart';

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
    // from: https://stackoverflow.com/questions/18057962/regex-pattern-including-all-special-characters
    String pattern = r'[^\w\s]';
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
    var message = "";

    final formKey = GlobalKey<FormState>();

    final firstName = TextFormField(
      key: const Key('firstNameField'),
      controller: firstNameController,
      decoration: const InputDecoration(
        icon: Icon(Icons.person), //icon of text field
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
        icon: Icon(Icons.person), //icon of text field
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
        icon: Icon(Icons.person), //icon of text field

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
        icon: Icon(Icons.location_on), //icon of text field

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
        icon: Icon(Icons.email), //icon of text field

        hintText: 'Email',
      ),
      validator: (value) {
        if (!EmailValidator.validate(value!)) {
          return "Please enter a valid email";
        }

        if (message == "The account already exists for that email.") {
          return "The account already exists for that email.";
        }

        return null;
      },
    );

    final birthdateInput = TextFormField(
      controller: birthdateController, //editing controller of this TextField
      decoration: const InputDecoration(
          icon: Icon(Icons.calendar_today), //icon of text field
          labelText: "Enter birthdate" //label text of field
          ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(), //get today's date
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );

        if (pickedDate != null) {
          print(
              pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
          String formattedDate = DateFormat('yyyy-MM-dd').format(
              pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
          print(
              formattedDate); //formatted date output using intl package =>  2022-07-04
          //You can format date as per your need

          birthdateController.text = formattedDate;
        } else {
          print("Date is not selected");
        }
      },
      validator: (value) {
        if (value == "") {
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
        icon: Icon(Icons.lock), //icon of text field
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

        if (!specialCharacter(value)) {
          return 'Password must have at least 1 special character!';
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
        message = await context.read<AuthProvider>().signUp(
              firstNameController.text,
              lastNameController.text,
              usernameController.text,
              birthdateController.text,
              locationController.text,
              emailController.text,
              passwordController.text,
            );

        if (formKey.currentState!.validate()) {
          //check if form data are valid,
          // your process task ahed if all data are valid
          //call the auth provider here

          if (message.isEmpty) {
            print("Successfully Signed Up User!");
            Navigator.pop(context);
          }
        }
      },
      child: const Text('Let\'s Do This!'),
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Form(
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
        ),
      ),
    );
  }
}
