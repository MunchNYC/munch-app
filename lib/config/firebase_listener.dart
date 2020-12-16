import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:munch/repository/user_repository.dart';

class FirebaseListener {
  StreamSubscription<firebase_auth.User> _authStateListener;

  void listen() {
    if (_authStateListener == null) {
      _authStateListener = firebase_auth.FirebaseAuth.instance
          .authStateChanges()
          .listen((user) async {
        // Receive [FirebaseUser] each time the user signIn, signOut, token is refreshed
        if (user != null) {
          final idToken = await user.getIdToken();
          UserRepo.getInstance().setAccessToken(idToken);
        }
      }, onError: (error) {
        print("FirebaseAuth onAuthStateChanged error: " + error.toString());
      });
    }
  }

  void stop() {
    if (_authStateListener != null) {
      _authStateListener.cancel();
      _authStateListener = null;
    }
  }
}
