// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyATR-WYRvt3hdZdOZ3BTt4ldEnveP88qAo',
    appId: '1:556938285930:web:c809c5e12d9a757294cb13',
    messagingSenderId: '556938285930',
    projectId: 'tianguccibd',
    authDomain: 'tianguccibd.firebaseapp.com',
    storageBucket: 'tianguccibd.appspot.com',
    measurementId: 'G-5L4MXL2LKF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD3xXhUd58r5ci1pXGrV6PeGkBcMyBv-dY',
    appId: '1:556938285930:android:3fa18b6f2eabbfa694cb13',
    messagingSenderId: '556938285930',
    projectId: 'tianguccibd',
    storageBucket: 'tianguccibd.appspot.com',
  );

}