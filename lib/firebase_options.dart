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
    apiKey: 'AIzaSyBxXep_GV5RdPgdtBR7Mn8WUsTQhHaQ86A',
    appId: '1:463965433199:web:f3c946b4880b68bb070c9a',
    messagingSenderId: '463965433199',
    projectId: 'inso2-855f9',
    authDomain: 'inso2-855f9.firebaseapp.com',
    storageBucket: 'inso2-855f9.firebasestorage.app',
    measurementId: 'G-79ZW594P5Z',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDmps46KWS98dHGgs95O_6HTI0w3XbINvg',
    appId: '1:463965433199:android:310a14748cea854b070c9a',
    messagingSenderId: '463965433199',
    projectId: 'inso2-855f9',
    storageBucket: 'inso2-855f9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCoA4Xu6DDKRO8CCQwmRU9N2xz7_3OEmx0',
    appId: '1:463965433199:ios:1ae256ba7bdd86dc070c9a',
    messagingSenderId: '463965433199',
    projectId: 'inso2-855f9',
    storageBucket: 'inso2-855f9.firebasestorage.app',
    iosBundleId: 'com.example.fismaInso2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCoA4Xu6DDKRO8CCQwmRU9N2xz7_3OEmx0',
    appId: '1:463965433199:ios:1ae256ba7bdd86dc070c9a',
    messagingSenderId: '463965433199',
    projectId: 'inso2-855f9',
    storageBucket: 'inso2-855f9.firebasestorage.app',
    iosBundleId: 'com.example.fismaInso2',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBxXep_GV5RdPgdtBR7Mn8WUsTQhHaQ86A',
    appId: '1:463965433199:web:9cb75f11a8d28d49070c9a',
    messagingSenderId: '463965433199',
    projectId: 'inso2-855f9',
    authDomain: 'inso2-855f9.firebaseapp.com',
    storageBucket: 'inso2-855f9.firebasestorage.app',
    measurementId: 'G-H2744936JN',
  );
}
