import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
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

  Future<firebase_auth.User> _signIn(firebase_auth.AuthCredential credentials) async {
    firebase_auth.UserCredential userCredential;

    try {
      userCredential = await _auth.signInWithCredential(credentials);

      String accessToken = await userCredential.user.getIdToken();

      UserRepo.getInstance().setAccessToken(accessToken);

      return userCredential.user;
    } catch (error) {
      if (error.code.toUpperCase() == "ACCOUNT-EXISTS-WITH-DIFFERENT-CREDENTIAL") {
        throw UnauthorisedException(401, {"message": App.translate("firebase_auth.credentials_clash.error")});
      }

      print("AuthRepo::signIn No user found; " + error.toString());
    }

    throw UnauthorisedException(401, {"message": App.translate("firebase_auth.no_account.error")});
  }

  Future _onSignedInGoogleUser(GoogleSignInAccount account, firebase_auth.User firebaseUser) async{
    User user = User.fromFirebaseUser(firebaseUser: firebaseUser);

    user = await _userRepo.registerUser(user);

    _userRepo.setCurrentUser(user);
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

      firebase_auth.User firebaseUser = await _signIn(credentials);

      await _onSignedInGoogleUser(account, firebaseUser);

      return _userRepo.currentUser;
    } else{
      return null;
    }
  }

  Future _onSignedInFacebookUser(FacebookLoginResult facebookLoginResult, firebase_auth.User firebaseUser) async {
    User user = User.fromFirebaseUser(firebaseUser: firebaseUser);

    user = await _userRepo.registerUser(user);

    _userRepo.setCurrentUser(user);
  }

  Future<User> signInWithFacebook() async {
    FacebookLogin facebookLogin = FacebookLogin();
    FacebookLoginResult facebookLoginResult = await facebookLogin.logIn(['email']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.loggedIn:
        final credentials = firebase_auth.FacebookAuthProvider.credential(facebookLoginResult.accessToken.token);

        firebase_auth.User firebaseUser = await _signIn(credentials);

        await _onSignedInFacebookUser(facebookLoginResult, firebaseUser);

        return _userRepo.currentUser;
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        throw Exception(facebookLoginResult.errorMessage);
        break;
    }

    return null;
  }

  Future _onSignedInAppleUser(AuthorizationResult authorizationResult, firebase_auth.User firebaseUser) async {
    User user = User.fromFirebaseUser(firebaseUser: firebaseUser);

    // Apple returns email and full name just on first successful login to app, after that it returns null for that fields if user logs in again
    // Apple login doesn't auto-fill firebase user's name well
    user.email = authorizationResult.credential.email;
    user.displayName = authorizationResult.credential.fullName.givenName ?? "" +
        " " + authorizationResult.credential.fullName.familyName ?? "";

    user = await _userRepo.registerUser(user);

    _userRepo.setCurrentUser(user);
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

        firebase_auth.User firebaseUser = await _signIn(credential);

        await _onSignedInAppleUser(authorizationResult, firebaseUser);

        return _userRepo.currentUser;
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
