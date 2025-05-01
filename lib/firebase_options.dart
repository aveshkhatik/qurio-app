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
    apiKey: 'AIzaSyBh5i5dM3EcwQrk6FHUitzGuPpnXE_ytKs',
    appId: '1:544631597729:web:0ec21d609fb51d46c65ee0',
    messagingSenderId: '544631597729',
    projectId: 'qurio-d6053',
    authDomain: 'qurio-d6053.firebaseapp.com',
    storageBucket: 'qurio-d6053.firebasestorage.app',
    measurementId: 'G-CN42RLXSNQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB6Sq66YYStSzSuVVMOJmQOwQC3nMbXJpE',
    appId: '1:544631597729:android:799de2d3293a323ec65ee0',
    messagingSenderId: '544631597729',
    projectId: 'qurio-d6053',
    storageBucket: 'qurio-d6053.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAjJhxEmswkJfGhPSmJX1acd1iegubyAkU',
    appId: '1:544631597729:ios:99ff6dcd6a7b9fbec65ee0',
    messagingSenderId: '544631597729',
    projectId: 'qurio-d6053',
    storageBucket: 'qurio-d6053.firebasestorage.app',
    iosBundleId: 'com.example.qurio',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAjJhxEmswkJfGhPSmJX1acd1iegubyAkU',
    appId: '1:544631597729:ios:99ff6dcd6a7b9fbec65ee0',
    messagingSenderId: '544631597729',
    projectId: 'qurio-d6053',
    storageBucket: 'qurio-d6053.firebasestorage.app',
    iosBundleId: 'com.example.qurio',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBh5i5dM3EcwQrk6FHUitzGuPpnXE_ytKs',
    appId: '1:544631597729:web:468b7ae344af61cec65ee0',
    messagingSenderId: '544631597729',
    projectId: 'qurio-d6053',
    authDomain: 'qurio-d6053.firebaseapp.com',
    storageBucket: 'qurio-d6053.firebasestorage.app',
    measurementId: 'G-BWD5DSRLZZ',
  );
}
