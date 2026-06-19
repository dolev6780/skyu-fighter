// STUB: Replace this file by running `flutterfire configure`
// in your terminal to generate your actual Firebase configuration.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return windows;
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
    apiKey: 'AIzaSyCJamCUQJPN7Yaw-jGcf8wHMD44WC-dZx4',
    appId: '1:275148231198:web:9308454fa7cfcec687140f',
    messagingSenderId: '275148231198',
    projectId: 'skyu-fighter',
    authDomain: 'skyu-fighter.firebaseapp.com',
    storageBucket: 'skyu-fighter.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCwF8go97OeqjWMcTIO9mtPPU_sQky33AI',
    appId: '1:275148231198:android:4504e762a0a3466a87140f',
    messagingSenderId: '275148231198',
    projectId: 'skyu-fighter',
    storageBucket: 'skyu-fighter.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBCzaaOg4Rxi__ULjveB2Hl4O6nxNjs5sI',
    appId: '1:275148231198:ios:e1b1a7a97bc6770f87140f',
    messagingSenderId: '275148231198',
    projectId: 'skyu-fighter',
    storageBucket: 'skyu-fighter.firebasestorage.app',
    androidClientId: '275148231198-dssar534vpcip2llr4s9jph5ag57g770.apps.googleusercontent.com',
    iosClientId: '275148231198-5uji3f2t2o79sboh9skc3nbv0p24b3ct.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterFlameGame',
  );
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBCzaaOg4Rxi__ULjveB2Hl4O6nxNjs5sI',
    appId: '1:275148231198:ios:e1b1a7a97bc6770f87140f',
    messagingSenderId: '275148231198',
    projectId: 'skyu-fighter',
    storageBucket: 'skyu-fighter.firebasestorage.app',
    androidClientId: '275148231198-dssar534vpcip2llr4s9jph5ag57g770.apps.googleusercontent.com',
    iosClientId: '275148231198-5uji3f2t2o79sboh9skc3nbv0p24b3ct.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterFlameGame',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCJamCUQJPN7Yaw-jGcf8wHMD44WC-dZx4',
    appId: '1:275148231198:web:0ba5057af08010b587140f',
    messagingSenderId: '275148231198',
    projectId: 'skyu-fighter',
    authDomain: 'skyu-fighter.firebaseapp.com',
    storageBucket: 'skyu-fighter.firebasestorage.app',
  );
}
