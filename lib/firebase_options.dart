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
    apiKey: 'AIzaSyCy8GlXof-O6-aqUis04cWFKyDGM9Y2GAU',
    appId: '1:802592535097:web:b1b711448c723bd671d3e8',
    messagingSenderId: '802592535097',
    projectId: 'experiencezone-8a3a5',
    authDomain: 'experiencezone-8a3a5.firebaseapp.com',
    databaseURL: 'https://experiencezone-8a3a5-default-rtdb.firebaseio.com',
    storageBucket: 'experiencezone-8a3a5.appspot.com',
    measurementId: 'G-PPPBBQN85L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAUvdt_qjGfUz18Xz-aP5gOsMpIuGpxueA',
    appId: '1:802592535097:android:9a3b951025a9e2d971d3e8',
    messagingSenderId: '802592535097',
    projectId: 'experiencezone-8a3a5',
    databaseURL: 'https://experiencezone-8a3a5-default-rtdb.firebaseio.com',
    storageBucket: 'experiencezone-8a3a5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB-qQnWI0cnzauD9Sf7-i9d8_S5V0UDDm0',
    appId: '1:802592535097:ios:e5e313ccf763544671d3e8',
    messagingSenderId: '802592535097',
    projectId: 'experiencezone-8a3a5',
    databaseURL: 'https://experiencezone-8a3a5-default-rtdb.firebaseio.com',
    storageBucket: 'experiencezone-8a3a5.appspot.com',
    androidClientId:
        '802592535097-7jpbidhaparl5hkb7j6la6a5gc17l0bi.apps.googleusercontent.com',
    iosClientId:
        '802592535097-j22686sruq5o0aj77crpp6tme0ll930d.apps.googleusercontent.com',
    iosBundleId: 'com.example.experiencezone',
  );
}
