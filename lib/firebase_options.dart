// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/* Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
*/ 
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAhuKFGJjT44SKJgTb6JqlBxKNXWegE3a8',
    appId: '1:40978170905:web:a32039e4a69a9b8041d688',
    messagingSenderId: '40978170905',
    projectId: 'aedp-project-app',
    authDomain: 'aedp-project-app.firebaseapp.com',
    storageBucket: 'aedp-project-app.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCRRfJd6U4J8YM7i5K69-Bg7np7PhpdRLk',
    appId: '1:40978170905:android:afd158a97a0ba14b41d688',
    messagingSenderId: '40978170905',
    projectId: 'aedp-project-app',
    storageBucket: 'aedp-project-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAow3fdUB9AcZ4sKYHfyFdoT2QIf44Oz5o',
    appId: '1:40978170905:ios:d1a5814022de673941d688',
    messagingSenderId: '40978170905',
    projectId: 'aedp-project-app',
    storageBucket: 'aedp-project-app.firebasestorage.app',
    iosBundleId: 'com.example.projectAedp',
  );

}