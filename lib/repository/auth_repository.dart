import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:munch/api/api.dart';
import 'package:munch/api/facebook_graph_api.dart';
import 'package:munch/config/constants.dart';
import 'package:munch/api/google_sign_in_api.dart';
import 'package:munch/model/response/facebook_graph_profile_response.dart';
import 'package:munch/model/response/google_sign_in_response.dart';
import 'package:munch/model/user.dart';
import 'package:munch/repository/user_repository.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/notifications_handler.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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

  Future<firebase_auth.User> _firebaseSignIn(firebase_auth.AuthCredential credentials) async {
    firebase_auth.UserCredential userCredential;

    try {
      userCredential = await _auth.signInWithCredential(credentials);

      String accessToken = await userCredential.user.getIdToken();

      UserRepo.getInstance().setAccessToken(accessToken);

      return userCredential.user;
    } catch (error) {
      print(error);
      if (error.code.toUpperCase() == "ACCOUNT-EXISTS-WITH-DIFFERENT-CREDENTIAL") {
        throw UnauthorisedException(401, {"message": App.translate("firebase_auth.credentials_clash.error")});
      }

      print("AuthRepo::signIn No user found; " + error.toString());
    }

    throw UnauthorisedException(401, {"message": App.translate("firebase_auth.no_account.error")});
  }

  Future _synchronizeCurrentUser({Function registerUserCallback, Function updateUserCallback}) async {
    User user = await _userRepo.getCurrentUser(forceRefresh: true);

    if (user == null) {
      user = await registerUserCallback();
      await _userRepo.setCurrentUser(user);
    } else if (updateUserCallback != null) {
      user = await updateUserCallback();
      await _userRepo.setCurrentUser(user);
    }
  }

  Future<User> _registerGoogleUser(GoogleSignInAccount account, firebase_auth.User firebaseUser) async {

    GoogleSignInApi googleSignInApi = GoogleSignInApi();
    GoogleSignInResponse googleSignInResponse = await googleSignInApi.getUserProfile(await account.authHeaders);

    User user = User(uid: firebaseUser.uid, displayName: account.displayName, email: account.email, imageUrl: account.photoUrl);

    user = await _userRepo.registerUser(user);

    return user;
  }

  Future<User> signInWithGoogle() async {
    // VERY IMPORTANT TO SET hostedDomain TO EMPTY STRING OTHERWISE GOOGLE SIGN IN WIDGET WILL CRASH ON iOS 9 and 10
    GoogleSignIn googleSignIn = GoogleSignIn(signInOption: SignInOption.standard, scopes: ["profile", "email", "gender", "birthday"], hostedDomain: "");

    try {
      GoogleSignInAccount account = await googleSignIn.signIn();

      if(account != null) {
        final authentication = await account.authentication;
        final credentials = firebase_auth.GoogleAuthProvider.credential(
            idToken: authentication.idToken,
            accessToken: authentication.accessToken);

        firebase_auth.User firebaseUser = await _firebaseSignIn(credentials);

        await _synchronizeCurrentUser(registerUserCallback: () => _registerGoogleUser(account, firebaseUser));

        await _userRepo.setCurrentUserSocialProvider(SocialProvider.GOOGLE);
        
        return await _onSignInSuccessful();
      } else{
        return null;
      }
    } catch(error, stacktrace){
      if(error is PlatformException){
        if(error.code == "network_error"){
          throw InternetConnectionException();
        } else {
          print(stacktrace.toString());
          // TODO remove after confirmed fixed for users https://github.com/mogol/flutter_secure_storage/issues/43
          FlutterSecureStorage().delete(key: StorageKeys.ACCESS_TOKEN);
          throw FetchDataException.fromMessage(App.translate("google_login.platform_exception.text"));
        }
      } else{
        // just forward the error if it's not PlatformException
        throw error;
      }
    }
  }

  Future<User> _registerFacebookUser(FacebookLoginResult facebookLoginResult, firebase_auth.User firebaseUser) async {
    String accessToken = facebookLoginResult.accessToken.token;

    FacebookGraphApi facebookGraphApi = FacebookGraphApi();

    FacebookGraphProfileResponse profile = await facebookGraphApi.getUserProfile(accessToken);

    User user = User(uid: firebaseUser.uid, displayName: profile.name, email: profile.email, gender: User.stringToGender(profile.gender), birthday: profile.birthday, imageUrl: profile.photoUrl);

    user = await _userRepo.registerUser(user);

    return user;
  }

  Future<User> _updateFacebookUser(FacebookLoginResult facebookLoginResult, firebase_auth.User firebaseUser) async {
    User currentUser = await _userRepo.getCurrentUser(forceRefresh: true);

    String accessToken = facebookLoginResult.accessToken.token;
    FacebookGraphApi facebookGraphApi = FacebookGraphApi();
    FacebookGraphProfileResponse profile = await facebookGraphApi.getUserProfile(accessToken);

    User user = User(uid: firebaseUser.uid, displayName: profile.name, email: profile.email, gender: User.stringToGender(profile.gender), imageUrl: profile.photoUrl);

    Map<String, dynamic> fields;
    if (currentUser.displayName == null) {
      fields["displayName"] = profile.name;
    } else {
      user.displayName = currentUser.displayName;
    }
    if (currentUser.email == null) {
      fields["email"] = profile.email;
    } else {
      user.email = currentUser.email;
    }
    if (currentUser.gender == null) {
      fields["gender"] = User.stringToGender(profile.gender).toString().split(".").last;
    } else {
      user.gender = currentUser.gender;
    }

    user = await _userRepo.updateCurrentUser(fields);

    return user;
  }

  Future<User> signInWithFacebook() async {
    FacebookLogin facebookLogin = FacebookLogin();
    FacebookLoginResult facebookLoginResult = await facebookLogin.logIn(['email']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.loggedIn:
        final credentials = firebase_auth.FacebookAuthProvider.credential(facebookLoginResult.accessToken.token);

        firebase_auth.User firebaseUser = await _firebaseSignIn(credentials);

        await _synchronizeCurrentUser(
            registerUserCallback: () => _registerFacebookUser(facebookLoginResult, firebaseUser),
            updateUserCallback: () => _updateFacebookUser(facebookLoginResult, firebaseUser)
        );
        
        await _userRepo.setCurrentUserSocialProvider(SocialProvider.FACEBOOK);

        return await _onSignInSuccessful();
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        if(facebookLoginResult.errorMessage == "net::ERR_INTERNET_DISCONNECTED"){
          throw InternetConnectionException();
        } else {
          throw FetchDataException.fromMessage(App.translate("facebook_login.platform_exception.text"));
        }
        break;
    }

    return null;
  }

  Future<User> _registerAppleUser(AuthorizationCredentialAppleID credentialAppleID, firebase_auth.User firebaseUser) async {
    String fullName = firebaseUser.displayName ?? ((credentialAppleID.givenName ?? "") + " " + (credentialAppleID.familyName ?? ""));

    User user = User(
        uid: firebaseUser.uid,
        displayName: fullName == " " ? "Private Muncher" : fullName,
        email: (firebaseUser.email ?? credentialAppleID.email) ?? ""
    );

    user = await _userRepo.registerUser(user);

    return user;
  }

  Future<User> signInWithApple() async {
    try {
      final AuthorizationCredentialAppleID credentialAppleID = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      firebase_auth.OAuthProvider oAuthProvider = firebase_auth.OAuthProvider("apple.com");

      final firebase_auth.AuthCredential credential = oAuthProvider.credential(
          idToken: credentialAppleID.identityToken,
          accessToken: credentialAppleID.authorizationCode
      );

      firebase_auth.User firebaseUser = await _firebaseSignIn(credential);

      await _synchronizeCurrentUser(registerUserCallback: () => _registerAppleUser(credentialAppleID, firebaseUser));

      await _userRepo.setCurrentUserSocialProvider(SocialProvider.APPLE);

      return await _onSignInSuccessful();
    } catch(exception){
      print("Error signing in with Apple: " + exception.toString());

      if(exception is SignInWithAppleAuthorizationException){
        if(exception.code == AuthorizationErrorCode.canceled){
          return null;
        }
      } else{
        throw FetchDataException.fromMessage(App.translate("apple_login.platform_exception.text"));
      }
    }
  }

  Future<User> _onSignInSuccessful() async {
    await NotificationsHandler.getInstance().initializeNotifications();

    return _userRepo.currentUser;
  }

  Future signOut() async {
    User currentUser = UserRepo.getInstance().currentUser;

    SocialProvider socialProvider;

    if(currentUser != null) {
      socialProvider = currentUser.socialProvider;
      // clearCurrentUser must be called before signOut, because user has to be authenticated to delete some data
      // must be wrapped inside try catch to prevent breaking of the script if this call is failed
      try {
        await _userRepo.signOutUser();
      } catch(error){}
    } else{
      socialProvider = await _userRepo.getStoredSocialProvider();
    }

    switch (socialProvider) {
      case SocialProvider.GOOGLE:
        await GoogleSignIn(signInOption: SignInOption.standard, scopes: ["profile", "email"], hostedDomain: "").signOut();
        break;
      case SocialProvider.FACEBOOK:
        await FacebookLogin().logOut();
        break;
      case SocialProvider.APPLE:
        break;
    }

    NotificationsHandler.getInstance().stopNotifications();

    if(_auth.currentUser != null) {
      return _auth.signOut().catchError((error) {
        print("LoginRepo::logout() encountered an error:\n${error.error}");
        return false;
      }).then((value) {
        return true;
      });
    }
  }

}
