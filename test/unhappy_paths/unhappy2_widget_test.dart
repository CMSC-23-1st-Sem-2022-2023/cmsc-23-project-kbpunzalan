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
    final passwordField = find.byKey(const Key("pwField"));

    // is not at least 8 characters long
    final passwordError1 =
        find.text('Password must be at least 8 characters long!');

    // does not have any number
    final passwordError2 = find.text('Password must have at least 1 number!');

    // has no lowercase
    final passwordError3 =
        find.text('Password must have at least 1 lowercase letter!');

    // has no uppercase
    final passwordError4 =
        find.text('Password must have at least 1 uppercase letter!');

    // has no uppercase
    final passwordError5 =
        find.text('Password must have at least 1 special character!');

    await tester.pumpWidget(const MaterialApp(
      home: SignupPage(),
    ));

    // passwordError1
    // await tester.enterText(passwordField, "a");

    // passwordError2
    // await tester.enterText(passwordField, "aaaaaaaa");

    // passwordError3
    // await tester.enterText(passwordField, "1AAAAAAA");

    // passwordError4
    // await tester.enterText(passwordField, "1aaaaaaa");

    // passwordError5
    await tester.enterText(passwordField, "1aAaaaaa");

    await tester.pump();

    expect(signUpButton, findsOneWidget);

    //! to use this, temporarily comment the use of provider in login.dart
    await tester.pump();
    await tester.tap(signUpButton);
    // expect(signupDisplay, findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));

    //! must not return any error since it is expected to have that error
    expect(passwordError5, findsOneWidget);

    // checks for the sign up button
    final signupDisplay = find.text("Sign Up");
    expect(signupDisplay, findsOneWidget);
  });
}
