import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:munch/config/constants.dart';
import 'package:munch/model/user.dart';

class UserRepo {
  static UserRepo _instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User _currentUser;

  UserRepo._internal();

  factory UserRepo.getInstance() {
    if (_instance == null) {
      _instance = UserRepo._internal();
    }
    return _instance;
  }

  User get currentUser => _currentUser;

  Future setCurrentUser(FirebaseUser firebaseUser) async {
    final idToken = await firebaseUser.getIdToken();

    _currentUser = User.fromFirebaseUser(firebaseUser: firebaseUser, accessToken: idToken.token);
  }

  Future<User> fetchCurrentUser() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

    // User is not logged in
    if(firebaseUser == null){
      return null;
    }

    await setCurrentUser(firebaseUser);

    return _currentUser;
  }

  Future clearCurrentUser() async {
    clearAccessToken();

    _currentUser = null;
  }

  Future<String> refreshAccessToken() async {
    print("Refreshing access token");

    FirebaseUser currentFirebaseUser = await _firebaseAuth.currentUser();
    String newAuthToken = (await currentFirebaseUser.getIdToken(refresh: true)).token;

    await setAccessToken(newAuthToken);

    return newAuthToken;
  }

  Future clearAccessToken() async {
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

    if (_currentUser != null) {
      _currentUser.accessToken = token;
    }
    FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
    await flutterSecureStorage.write(key: StorageKeys.ACCESS_TOKEN, value: token);
  }
}
