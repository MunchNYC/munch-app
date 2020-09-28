import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:munch/api/Api.dart';
import 'package:munch/model/user.dart';
import 'package:munch/repository/user_repository.dart';
import 'package:munch/util/app.dart';
import 'package:apple_sign_in/apple_sign_in.dart';

class AuthRepo {
  static AuthRepo _instance;
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  AuthRepo._internal();

  factory AuthRepo.getInstance() {
    if (_instance == null) {
      _instance = AuthRepo._internal();
    }
    return _instance;
  }

  final UserRepo _userRepo = UserRepo.getInstance();

  Future<User> _signIn(firebase_auth.AuthCredential credentials) async {
    firebase_auth.UserCredential userCredential;

    try {
      userCredential = await _auth.signInWithCredential(credentials);

      await _userRepo.setCurrentUser(userCredential.user);

      return _userRepo.currentUser;
    } catch (error) {
      if (error.code.toUpperCase() == "ACCOUNT-EXISTS-WITH-DIFFERENT-CREDENTIAL") {
        throw UnauthorisedException(401, {"message": App.translate("firebase_auth.credentials_clash.error")});
      }

      print("AuthRepo::signIn No user found; " + error.toString());
    }

    throw UnauthorisedException(401, {"message": App.translate("firebase_auth.no_account.error")});
  }

  Future<User> signInWithGoogle() async {
    // VERY IMPORTANT TO SET hostedDomain TO EMPTY STRING OTHERWISE GOOGLE SIGN IN WIDGET WILL CRASH ON iOS 9 and 10
    GoogleSignIn googleSignInRepo = GoogleSignIn(signInOption: SignInOption.standard, scopes: ["profile", "email"], hostedDomain: "");

    GoogleSignInAccount account = await googleSignInRepo.signIn();

    if(account != null) {
      final authentication = await account.authentication;
      final credentials = firebase_auth.GoogleAuthProvider.credential(
          idToken: authentication.idToken,
          accessToken: authentication.accessToken);

      return await _signIn(credentials);
    } else{
      return null;
    }
  }

  Future<User> signInWithFacebook() async {
    FacebookLogin facebookLogin = FacebookLogin();
    FacebookLoginResult facebookLoginResult = await facebookLogin.logIn(['email']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.loggedIn:
        final credentials = firebase_auth.FacebookAuthProvider.credential(facebookLoginResult.accessToken.token);

        return await _signIn(credentials);
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        throw Exception(facebookLoginResult.errorMessage);
        break;
    }

    return null;
  }

  Future<User> signInWithApple() async {
    final AuthorizationResult authorizationResult = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (authorizationResult.status) {
      case AuthorizationStatus.authorized:
        firebase_auth.OAuthProvider oAuthProvider = firebase_auth.OAuthProvider("apple.com");

        final firebase_auth.AuthCredential credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(authorizationResult.credential.identityToken),
            accessToken: String.fromCharCodes(authorizationResult.credential.authorizationCode)
        );

        return await _signIn(credential);
        break;
      case AuthorizationStatus.cancelled:
        break;
      case AuthorizationStatus.error:
        throw Exception(authorizationResult.error.localizedDescription);
        break;
    }

    return null;
  }

  Future<bool> signOut() async {
    // clearCurrentUser must be called before signOut, because user has to be authenticated to delete some data
    await _userRepo.clearCurrentUser();

    return _auth.signOut().catchError((error) {
      print("LoginRepo::logout() encountered an error:\n${error.error}");
      return false;
    }).then((value) {
      return true;
    });
  }
}
