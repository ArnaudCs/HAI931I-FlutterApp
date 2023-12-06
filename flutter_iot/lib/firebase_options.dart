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
    apiKey: 'AIzaSyDSFwucP3YHwPjfLnNGv9vZWRd_5PzjtUw',
    appId: '1:682735940971:web:56343ddb8e76c8f5bc482e',
    messagingSenderId: '682735940971',
    projectId: 'leaflink-ef836',
    authDomain: 'leaflink-ef836.firebaseapp.com',
    storageBucket: 'leaflink-ef836.appspot.com',
    measurementId: 'G-48R4E9S1DM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCddnqZTf1xhCVv-M3051lgFjFEoMex6Cg',
    appId: '1:682735940971:android:036a296edfd7363abc482e',
    messagingSenderId: '682735940971',
    projectId: 'leaflink-ef836',
    storageBucket: 'leaflink-ef836.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBGQUN1Wj1X-XpvGrC2HWcEtGSZiBm8-_E',
    appId: '1:682735940971:ios:7f57db350bf3f9b9bc482e',
    messagingSenderId: '682735940971',
    projectId: 'leaflink-ef836',
    storageBucket: 'leaflink-ef836.appspot.com',
    iosBundleId: 'com.example.flutterIot',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBGQUN1Wj1X-XpvGrC2HWcEtGSZiBm8-_E',
    appId: '1:682735940971:ios:2f06c434fc4051bbbc482e',
    messagingSenderId: '682735940971',
    projectId: 'leaflink-ef836',
    storageBucket: 'leaflink-ef836.appspot.com',
    iosBundleId: 'com.example.flutterIot.RunnerTests',
  );
}
