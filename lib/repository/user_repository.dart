import 'dart:async';
// firebase recommends to prefix this import with namespace to avoid collisions
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:munch/api/api.dart';
import 'package:munch/api/users_api.dart';
import 'package:munch/config/constants.dart';
import 'package:munch/model/user.dart';
import 'package:munch/util/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepo {
  static UserRepo _instance;
  final UsersApi _usersApi = UsersApi();

  User _currentUser;
  String postLoginDeeplink;
  UserRepo._internal();

  factory UserRepo.getInstance() {
    if (_instance == null) {
      _instance = UserRepo._internal();
    }
    return _instance;
  }

  User get currentUser => _currentUser;

  Future<SocialProvider> getStoredSocialProvider() async {
    SocialProvider socialProvider;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    int socialProviderIndex = sharedPreferences.getInt(StorageKeys.SOCIAL_PROVIDER);

    if(socialProviderIndex != null) {
      socialProvider = SocialProvider.values[socialProviderIndex];
    } else{
      socialProvider = null;
    }

    return socialProvider;
  }

  Future setCurrentUserSocialProvider(SocialProvider socialProvider) async {
    if(socialProvider == null) {
      socialProvider = await getStoredSocialProvider();
    } else{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      await sharedPreferences.setInt(StorageKeys.SOCIAL_PROVIDER, socialProvider.index);
    }

    _currentUser.socialProvider = socialProvider;
  }

  Future<User> getCurrentUser({bool forceRefresh = false}) async {
    if (_currentUser != null && !forceRefresh) {
      return _currentUser;
    } else {
      // to be sure user is not null, to avoid race condition, it's enough to fetch firebase user because we need only uid
      firebase_auth.User firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;

      // User is not logged in
      if(firebaseUser == null){
        return null;
      }

      String accessToken = await firebaseUser.getIdToken();

      await setAccessToken(accessToken);

      // Refresh user data by fetching it from backend
      try {
        User user = await _usersApi.getAuthenticatedUser();

        await setCurrentUser(user);

        // null means it will be fetched from storage, we need it stored to local storage because user is remembered
        await setCurrentUserSocialProvider(null);

        print(_currentUser.socialProvider);

        return _currentUser;
      } catch(exception){
        if(exception is NotFoundException){
          return null;
        }

        throw exception;
      }
    }
  }

  Future setCurrentUser(User user) async {
    // assign current accessToken
    user.accessToken = await getAccessToken();
    String fcmToken = await getFCMToken();

    if(fcmToken != null){
      user.pushNotificationsInfo = PushNotificationsInfo(fcmToken: fcmToken, deviceId: App.deviceId);
    }

    _currentUser = user;
    FlutterUxcam.setUserIdentity(user.uid);
    FlutterUxcam.setUserProperty("email", user.email);
    FlutterUxcam.setUserProperty("name", user.displayName);
    print("current user set: " + _currentUser.toString());
  }

  Future updateCurrentUser(User user) async {
    try {
      User updatedUser = await _usersApi.updatePersonalInfo(user);
      _currentUser = updatedUser;
      print("current user updated: " + _currentUser.toString());

      return updatedUser;
    } catch (error) {

      throw error;
    }
  }

  Future signOutUser() async {
    await _usersApi.signOut(App.deviceId);

    await _clearAccessToken();
    await _clearFCMToken();

    _currentUser = null;
  }

  Future<String> refreshAccessToken() async {
    print("Refreshing access token");

    firebase_auth.User currentFirebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
    // getIdToken force refresh
    String newAuthToken = (await currentFirebaseUser.getIdToken(true));

    await setAccessToken(newAuthToken);

    return newAuthToken;
  }

  Future _clearAccessToken() async {
    FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();

    await flutterSecureStorage.delete(key: StorageKeys.ACCESS_TOKEN);

    if(_currentUser != null) {
      _currentUser.accessToken = null;
    }
  }

  Future<String> getAccessToken() async {
    if (_currentUser != null && _currentUser.accessToken != null) {
      return _currentUser.accessToken;
    } else {
      FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
      return await flutterSecureStorage.read(key: StorageKeys.ACCESS_TOKEN);
    }
  }

  Future setAccessToken(String token) async {
    print("Setting access token: " + token);

    FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
    await flutterSecureStorage.write(key: StorageKeys.ACCESS_TOKEN, value: token);

    if (_currentUser != null) {
      _currentUser.accessToken = token;
    }
  }

  Future _clearFCMToken() async {
    FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
    await flutterSecureStorage.delete(key: StorageKeys.FCM_TOKEN);

    if(_currentUser != null) {
      _currentUser.pushNotificationsInfo = null;
    }
  }

  Future<String> getFCMToken() async {
    if (_currentUser != null && _currentUser.pushNotificationsInfo != null) {
      return _currentUser.pushNotificationsInfo.fcmToken;
    } else {
      FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
      return flutterSecureStorage.read(key: StorageKeys.FCM_TOKEN);
    }
  }

  Future setFCMToken(String token) async {
    print("Setting fcm token: " + token);

    FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();

    await flutterSecureStorage.write(key: StorageKeys.FCM_TOKEN, value: token);

    if (_currentUser != null) {
      _currentUser.pushNotificationsInfo = PushNotificationsInfo(fcmToken: token, deviceId: App.deviceId);

      await _usersApi.updatePushNotificationsInfo(_currentUser.pushNotificationsInfo);
    }
  }

  Future deleteFCMToken() async {
    _clearFCMToken();
  }

  Future<User> registerUser(User user) async {
    if (_isValidUser(user)) {
      User registeredUser = await _usersApi.registerUser(user);
      return registeredUser;
    } else {
      throw (App.translate("register_user.required_field_missing.text"));
    }
  }

  bool _isValidUser(User user) {
    bool _hasValid(String string) {
      return (string != null && string != "");
    }

    if (_hasValid(user.displayName) && _hasValid(user.email)) {
      return true;
    }
    return false;
  }
}
