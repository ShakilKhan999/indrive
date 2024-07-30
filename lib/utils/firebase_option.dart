import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('DefaultFirebase option has not been configured'
          'configure firebase cli again.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError('No mac platform');
      case TargetPlatform.windows:
        throw UnsupportedError('sdfdsfsdf');
      case TargetPlatform.linux:
        throw UnsupportedError('sdfsdfsdfdf');
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC_QMYEnzNIUeW73N0ye9CC8MuIr8nDS18',
    appId: '1:59849463899:android:90c90348615fabdc3e077e',
    messagingSenderId: '59849463899',
    projectId: 'callandgo',
    storageBucket: "gs://callandgo.appspot.com",
  );
  static const FirebaseOptions ios = FirebaseOptions(
      apiKey: 'AIzaSyCnAWLYFi05RksnO7OEyWsBHkbMuGfDjrQ',
      appId: '1:356611008427:ios:4b5cf8d14fdee156a014ee',
      messagingSenderId: '356611008427',
      projectId: 'wholesaleclubltd');
}
