import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:munch/api/users_api.dart';
import 'package:munch/config/constants.dart';
import 'package:munch/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepo {
  static UserRepo _instance;
  UsersApi _usersApi = UsersApi();
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

  Future<User> getCurrentUser({bool forceRefresh = false}) async {
    if (_currentUser != null && !forceRefresh) {
      return _currentUser;
    } else {
      // to be sure user is not null, to avoid race condition, it's enough to fetch firebase user because we need only uid
      FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

      // User is not logged in
      if(firebaseUser == null){
        return null;
      }

      // Refresh user data by fetching it from backend
      User _fetchedById = await _usersApi.fetchUserById(firebaseUser.uid);
      print("Refreshed from backend: " + _fetchedById.toString());
      await updateCurrentUser(_fetchedById);
      return _currentUser;
    }
  }

  Future updateCurrentUser(User backendUser) async {
    print("User from backend: " + backendUser.toString());

    // assign current accessToken
    backendUser.accessToken = await getAccessToken();

    _currentUser = backendUser;
    print("Current User after backend call: " + _currentUser.toString());
  }

  Future clearCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _currentUser = null;
  }

  Future<String> refreshAccessToken() async {
    print("Refreshing access token");

    FirebaseUser currentFirebaseUser = await _firebaseAuth.currentUser();
    String newAuthToken = (await currentFirebaseUser.getIdToken(refresh: true)).token;

    await setAccessToken(newAuthToken);

    return newAuthToken;
  }

  Future<String> getAccessToken() async {
    if (_currentUser != null && _currentUser.accessToken != null) {
      return _currentUser.accessToken;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(StorageKeys.ACCESS_TOKEN);
    }
  }

  Future setAccessToken(String token) async {
    print("Setting access token: " + token);

    if (_currentUser != null) {
      _currentUser.accessToken = token;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.ACCESS_TOKEN, token);
  }
}
