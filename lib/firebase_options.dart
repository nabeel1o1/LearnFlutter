import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBP3gmNjnIeIbwPn5MN0t4v28qYukJacDU',
    appId: '1:156512188752:android:def0405c3fc6896f115455',
    messagingSenderId: '156512188752',
    projectId: 'flutter-prep-f57ce',
    databaseURL: 'https://flutter-prep-f57ce-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-prep-f57ce.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD6V_ZKkdC9d7lhCHb9bVJvc6cc_yaW0bA',
    appId: '1:156512188752:ios:746e5c4e405dc984115455',
    messagingSenderId: '156512188752',
    projectId: 'flutter-prep-f57ce',
    databaseURL: 'https://flutter-prep-f57ce-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-prep-f57ce.appspot.com',
    iosBundleId: 'com.example.flutteroid.flutteroidApp',
  );

}