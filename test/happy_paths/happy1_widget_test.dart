import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week7_networking_discussion/screens/auth/login.dart';
import 'package:week7_networking_discussion/screens/auth/signup.dart';
import '../../lib/main.dart' as app;
// import '../lib/screens/signup.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';

void main() {
  // Define a test
  testWidgets('Test Login Widget', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it along with the provider the widget requires
    app.main();

    final signUpButton = find.byKey(const Key("signUpButton"));
    final emailField = find.byKey(const Key("emailField"));

    final emailError = find.text('Please enter a valid email');

    await tester.pumpWidget(const MaterialApp(
      home: SignupPage(),
    ));

    await tester.enterText(emailField, "kbpunzalan@gmail.com");
    await tester.pump();

    expect(signUpButton, findsOneWidget);

    //! to use this, temporarily comment the use of provider in login.dart
    await tester.pump();
    await tester.tap(signUpButton);
    // expect(signupDisplay, findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));

    //! must provide testing error since there is no error in the validation
    expect(emailError, findsOneWidget);

    // checks for the sign up button
    final signupDisplay = find.text("Sign Up");
    expect(signupDisplay, findsOneWidget);
  });
}
