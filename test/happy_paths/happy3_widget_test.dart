import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week7_networking_discussion/screens/auth/login.dart';
import 'package:week7_networking_discussion/screens/auth/signup.dart';
import '../../lib/main.dart' as app;
// import '../lib/screens/signup.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';

void main() {
  // Define a test
  testWidgets('Test Sign Up Widget', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it along with the provider the widget requires
    app.main();

    final signUpButton = find.byKey(const Key("signUpButton"));

    final firstNameField = find.byKey(const Key("firstNameField"));
    final lastNameField = find.byKey(const Key("lastNameField"));
    final usernameField = find.byKey(const Key("usernameField"));
    final locationField = find.byKey(const Key("locationField"));

    final firstNameError = find.text('Firstname field cannot be empty!');
    final lastNameError = find.text('Lastname field cannot be empty!');
    final usernameError = find.text('Lastname field cannot be empty!');
    final locationError = find.text('Location field cannot be empty!');

    await tester.pumpWidget(MaterialApp(
      home: SignupPage(),
    ));

    await tester.enterText(firstNameField, "Kurt");
    await tester.pump();
    await tester.enterText(lastNameField, "Punzalan");
    await tester.pump();
    await tester.enterText(usernameField, "kurtbrian");
    await tester.pump();
    await tester.enterText(locationField, "SPC");
    await tester.pump();

    expect(signUpButton, findsOneWidget);

    //! to use this, temporarily comment the use of provider in login.dart
    await tester.pump();
    await tester.tap(signUpButton);
    // expect(signupDisplay, findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));

    //! must provide testing error since there is no error in the validation
    // expect(firstNameError, findsOneWidget);
    // expect(lastNameError, findsOneWidget);
    // expect(usernameError, findsOneWidget);
    expect(locationError, findsOneWidget);
  });
}
