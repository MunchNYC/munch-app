import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:munch/repository/user_repository.dart';

class FirebaseListener{
  StreamSubscription<FirebaseUser> _authStateListener;

  void listen(){
    if (_authStateListener == null) {
      _authStateListener =
          FirebaseAuth.instance.onAuthStateChanged.listen((user) async {
            // Receive [FirebaseUser] each time the user signIn, signOut, token is refreshed
            if (user != null) {
              final idToken = await user.getIdToken();
              UserRepo.getInstance().setAccessToken(idToken.token);
            }
          }, onError: (error) {
            print("FirebaseAuth onAuthStateChanged error: " + error.toString());
          });
    }
  }

  void stop(){
    if(_authStateListener != null){
      _authStateListener.cancel();
      _authStateListener = null;
    }
  }
}