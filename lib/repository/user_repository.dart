import 'dart:async';
// firebase recommends to prefix this import with namespace to avoid collisions
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:munch/api/users_api.dart';
import 'package:munch/config/constants.dart';
import 'package:munch/model/user.dart';
import 'package:munch/util/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepo {
  static UserRepo _instance;
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final UsersApi _usersApi = UsersApi();

  User _currentUser;

  UserRepo._internal();

  factory UserRepo.getInstance() {
    if (_instance == null) {
      _instance = UserRepo._internal();
    }
    return _instance;
  }

  User get currentUser => _currentUser;

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
      User user = await _usersApi.getAuthenticatedUser();

      setCurrentUser(user);

      return _currentUser;
    }
  }

  Future setCurrentUser(User user) async {
    // assign current accessToken
    user.accessToken = await getAccessToken();
    user.fcmToken = await getFCMToken();

    _currentUser = user;
  }

  Future signOutUser() async {
    await _usersApi.signOut(App.deviceId);

    await _clearAccessToken();
    await _clearFCMToken();

    _currentUser = null;
  }

  Future<String> refreshAccessToken() async {
    print("Refreshing access token");

    firebase_auth.User currentFirebaseUser = _firebaseAuth.currentUser;
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
      _currentUser.fcmToken = null;
    }
  }

  Future<String> getFCMToken() async {
    if (_currentUser != null && _currentUser.fcmToken != null) {
      return _currentUser.fcmToken;
    } else {
      FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
      return flutterSecureStorage.read(key: StorageKeys.FCM_TOKEN);
    }
  }

  void setFCMToken(String token) async {
    print("Setting fcm token: " + token);

    FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();

    await flutterSecureStorage.write(key: StorageKeys.FCM_TOKEN, value: token);

    if (_currentUser != null) {
      _currentUser.fcmToken = token;

      await _usersApi.updateFCMToken(App.deviceId, token);
    }
  }

  Future deleteFCMToken() async {
    _clearFCMToken();
  }

  Future<User> registerUser(User user) async{
    user.fcmToken = await getFCMToken();

    User registeredUser = await _usersApi.registerUser(user);

    return registeredUser;
  }
}
