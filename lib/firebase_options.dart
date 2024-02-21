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
    apiKey: 'AIzaSyCIPrGCLWMZyF8A7qgUdY6KWkpsfpXQ428',
    appId: '1:962712836791:web:5af51e26e239809f0f8b32',
    messagingSenderId: '962712836791',
    projectId: 'shopping-2697a',
    authDomain: 'shopping-2697a.firebaseapp.com',
    storageBucket: 'shopping-2697a.appspot.com',
    measurementId: 'G-1EEZ75TFCR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC3exbaCjK1eF8ZwDRtU6OxLqcPHeAZ42c',
    appId: '1:962712836791:android:0e60a480530030df0f8b32',
    messagingSenderId: '962712836791',
    projectId: 'shopping-2697a',
    storageBucket: 'shopping-2697a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBikECUVjEN5nxWjIGuCwksDjF4462AHvo',
    appId: '1:962712836791:ios:4d41b2ab18647a300f8b32',
    messagingSenderId: '962712836791',
    projectId: 'shopping-2697a',
    storageBucket: 'shopping-2697a.appspot.com',
    iosBundleId: 'com.example.shopping',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBikECUVjEN5nxWjIGuCwksDjF4462AHvo',
    appId: '1:962712836791:ios:4d41b2ab18647a300f8b32',
    messagingSenderId: '962712836791',
    projectId: 'shopping-2697a',
    storageBucket: 'shopping-2697a.appspot.com',
    iosBundleId: 'com.example.shopping',
  );
}
