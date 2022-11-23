// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCkBC7SjH6Bl2Tucd6GsL36IpkmyelUbzc',
    appId: '1:969281977603:web:13056767ac429a9a21bd36',
    messagingSenderId: '969281977603',
    projectId: 'cmsc23-todo-app-kbbpunzalan',
    authDomain: 'cmsc23-todo-app-kbbpunzalan.firebaseapp.com',
    storageBucket: 'cmsc23-todo-app-kbbpunzalan.appspot.com',
    measurementId: 'G-SSPZ014R86',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA7GZ3zyqmblMMOqGkvAnTu9hk5uVhqCK4',
    appId: '1:969281977603:android:d85657729fd0e65f21bd36',
    messagingSenderId: '969281977603',
    projectId: 'cmsc23-todo-app-kbbpunzalan',
    storageBucket: 'cmsc23-todo-app-kbbpunzalan.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDEZLGB_LJh8oTBf_fpEgoR3TmCjDn5hWQ',
    appId: '1:969281977603:ios:163f63f79f42b99b21bd36',
    messagingSenderId: '969281977603',
    projectId: 'cmsc23-todo-app-kbbpunzalan',
    storageBucket: 'cmsc23-todo-app-kbbpunzalan.appspot.com',
    iosClientId:
        '969281977603-noln212d0s41void65bc688ath7vffmh.apps.googleusercontent.com',
    iosBundleId: 'com.example.week7NetworkingDiscussion',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDEZLGB_LJh8oTBf_fpEgoR3TmCjDn5hWQ',
    appId: '1:969281977603:ios:163f63f79f42b99b21bd36',
    messagingSenderId: '969281977603',
    projectId: 'cmsc23-todo-app-kbbpunzalan',
    storageBucket: 'cmsc23-todo-app-kbbpunzalan.appspot.com',
    iosClientId:
        '969281977603-noln212d0s41void65bc688ath7vffmh.apps.googleusercontent.com',
    iosBundleId: 'com.example.week7NetworkingDiscussion',
  );
}