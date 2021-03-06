// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAbkqKpFqojQ24CJCUDqdkzydCO1rVnk-c',
    appId: '1:142409625584:web:cb93dc4db4b342e956b735',
    messagingSenderId: '142409625584',
    projectId: 'crypto-wallet-5727c',
    authDomain: 'crypto-wallet-5727c.firebaseapp.com',
    storageBucket: 'crypto-wallet-5727c.appspot.com',
    measurementId: 'G-MW6984G7ZY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDv1RacpZe08JN8iy703fBUqQxJVkcYzH0',
    appId: '1:142409625584:android:2ac5c5b0aaaa60b256b735',
    messagingSenderId: '142409625584',
    projectId: 'crypto-wallet-5727c',
    storageBucket: 'crypto-wallet-5727c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAffOiw3VZ6gPBIvYseQd7SJa5xR3iMVFs',
    appId: '1:142409625584:ios:760aaa69f08e458956b735',
    messagingSenderId: '142409625584',
    projectId: 'crypto-wallet-5727c',
    storageBucket: 'crypto-wallet-5727c.appspot.com',
    iosClientId: '142409625584-448j8bpj5f8v2ab8sl905u18f48qokco.apps.googleusercontent.com',
    iosBundleId: 'com.example.cryptoWallet',
  );
}
