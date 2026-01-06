import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCAEQF89Gq8kFmdFDYm-KhQLdDLNHgp2W8',
    appId: '1:645125523636:android:3d62f606ab3dc9a6a66fe1',
    messagingSenderId: '645125523636',
    projectId: 'meet-a38e7',
    storageBucket: 'meet-a38e7.firebasestorage.app',
  );
}
