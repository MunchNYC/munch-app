import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:munch/api/Api.dart';
import 'package:munch/api/authentication_api.dart';
import 'package:munch/model/user.dart';
import 'package:munch/repository/user_repository.dart';
import 'package:munch/util/app.dart';

class AuthRepo {
  static AuthRepo _instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthenticationApi _authenticationApi = AuthenticationApi();

  AuthRepo._internal();

  factory AuthRepo.getInstance() {
    if (_instance == null) {
      _instance = AuthRepo._internal();
    }
    return _instance;
  }

  Future<FirebaseUser> _signIn(AuthCredential credentials) async {
    var authResult;

    try {
      authResult = await _auth.signInWithCredential(credentials);

    } catch (error) {
      if (error is PlatformException && error.code == "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL") {
        throw UnauthorisedException(401, {"message": App.translate("firebase_auth.credentials_clash.error")});
      }

      print("AuthRepo::signIn No user found; " + error.toString());
    }

    if (authResult != null && authResult.user != null) {
      return authResult.user;
    } else{
      throw UnauthorisedException(401, {"message": App.translate("firebase_auth.no_account.error")});
    }
  }

  Future<FirebaseUser> signInWithGoogle(GoogleSignInAccount account) async {
    final authentication = await account.authentication;
    final credentials = GoogleAuthProvider.getCredential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken);

    return await _signIn(credentials);
  }


  Future<bool> signOut() async {
    return _auth.signOut().catchError((error) {
      print("LoginRepo::logout() encountered an error:\n${error.error}");
      return false;
    }).then((value) {
      return true;
    });
  }

  // gets called after signIn with Social Networks in order to preserve user in our private DB
  // need to specify name as a separated parameter, because apple login doesn't auto-fill firebase user's name well
  Future registerSocial(FirebaseUser firebaseUser) async {
    User user = await _authenticationApi.registerSocial(firebaseUser.email);

    UserUpdateInfo updateUser = UserUpdateInfo();

    // preserve name from backend, must do that because name is auto-changed in Firebase on login with social provider
    updateUser.displayName = user.displayName;

    firebaseUser.updateProfile(updateUser);
  }


  Future onSuccessfulFirebaseLogin(FirebaseUser firebaseUser) async {
     // fetch user from backend to be sure we have it on home screen
     await UserRepo.getInstance().getCurrentUser(forceRefresh: true);
  }
}
