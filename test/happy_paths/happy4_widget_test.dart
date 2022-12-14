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

    final loginButton = find.byKey(const Key("loginButton"));
    final emailField = find.byKey(const Key("emailField"));
    final pwField = find.byKey(const Key("pwField"));

    final emailError = find.text('Please enter a valid email');
    final pwError =
        find.text('Password field must be at least 8 characters long!');

    await tester.pumpWidget(MaterialApp(
      home: LoginPage(),
    ));

    await tester.enterText(emailField, "kbpunzalan@gmail.com");
    await tester.pump();

    await tester.enterText(pwField, "11111Aa-");
    await tester.pump();

    expect(loginButton, findsOneWidget);

    //! to use this, temporarily comment the use of provider in login.dart
    await tester.pump();
    await tester.tap(loginButton);
    // expect(signupDisplay, findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));

    //! must provide testing error since there is no error in the validation
    expect(emailError, findsOneWidget);
    expect(pwError, findsOneWidget);
  });
}
