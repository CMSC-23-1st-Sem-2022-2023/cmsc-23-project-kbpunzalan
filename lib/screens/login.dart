import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/screens/signup.dart';
import 'package:email_validator/email_validator.dart';
import '../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    final email = TextFormField(
      key: const Key('emailField'),
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
      key: const Key('pwField'),
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

    final loginButton = Padding(
      key: const Key('loginButton'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            //check if form data are valid,
            // your process task ahed if all data are valid
            context
                .read<AuthProvider>()
                .signIn(emailController.text, passwordController.text);
          }
        },
        child: const Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final signUpButton = Padding(
      key: const Key('signUpButton'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SignupPage(),
            ),
          );
        },
        child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: formKey, //key for form,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            children: <Widget>[
              const Text(
                "Login",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              email,
              password,
              loginButton,
              signUpButton,
            ],
          ),
        ),
      ),
    );
  }
}
