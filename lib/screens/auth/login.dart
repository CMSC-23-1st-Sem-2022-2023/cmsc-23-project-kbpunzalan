import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
// import '../../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController userNameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    final email = TextFormField(
      key: const Key('emailField'),
      controller: userNameController,
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

    final password = TextFormField(
      key: const Key('pwField'),
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
      validator: (value) {
        // requirement is at least 6 characters
        if (value!.length < 8) {
          return 'Password must be at least 6 characters long!';
        }
        return null;
      },
    );

    final loginButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextButton(
        key: const Key('loginUpButton'),
        style: TextButton.styleFrom(
            backgroundColor: Colors.black,
            padding: const EdgeInsets.all(16.0),
            textStyle: const TextStyle(fontSize: 20),
            foregroundColor: Colors.white),
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            //check if form data are valid,
            // your process task ahed if all data are valid
            var message = await context
                .read<AuthProvider>()
                .signIn(userNameController.text, passwordController.text);

            if (message.isEmpty) {
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: Theme.of(context).errorColor,
                ),
              );
            }
          }
        },
        child: const Text('Login'),
      ),
    );

    final backButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.pop(context);
        },
        child: const Text('Go Back', style: TextStyle(color: Colors.white)),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/todo.png',
                    height: 90,
                    width: 90,
                  ),
                  const Text(
                    "Login",
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
              email,
              password,
              const SizedBox(height: 20),
              loginButton,
              backButton,
            ],
          ),
        ),
      ),
    );
  }
}
