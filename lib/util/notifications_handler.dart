import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:munch/repository/user_repository.dart';

class NotificationsHandler{
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  StreamSubscription<String> _fcmTokenListener;

  static NotificationsHandler _instance;

  NotificationsHandler._internal(){
    _configureNotificationsReceiveCallbacks();
  }

  factory NotificationsHandler.getInstance() {
    if (_instance == null) {
      _instance = NotificationsHandler._internal();
    }
    return _instance;
  }

  Future initializeNotifications() async {
    // It will return null for Android
    bool permissionRequestResult = await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    );

    if(permissionRequestResult == null || permissionRequestResult) {
      await _setCurrentFCMToken();
      await _registerFCMTokenListener();
    }
  }

  void stopNotifications(){
    _disposeFCMTokenListener();
  }

  Future _saveFCMToken(String fcmToken) async{
    await UserRepo.getInstance().setFCMToken(fcmToken);
  }

  Future _setCurrentFCMToken() async{
    String fcmToken = await firebaseMessaging.getToken();

    if(fcmToken != null){
      await _saveFCMToken(fcmToken);
    }
  }

  Future _registerFCMTokenListener() async {
    _fcmTokenListener = firebaseMessaging.onTokenRefresh.listen((fcmToken) async {
      await _saveFCMToken(fcmToken);
    });
  }

  void _disposeFCMTokenListener(){
    _fcmTokenListener?.cancel();
  }

  void _configureNotificationsReceiveCallbacks(){
    firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) {
          print('onMessage: $message');

          // TODO HANDLE NOTIFICATIONS
          return;
        },
        onBackgroundMessage: null, // TODO: Check do we need this
        onResume: (Map<String, dynamic> message) {
          print('onResume: $message');

          // TODO HANDLE NOTIFICATIONS
          return;
        },
        onLaunch: (Map<String, dynamic> message) {
          print('onLaunch: $message');

          // TODO HANDLE NOTIFICATIONS
          return;
        }
    );
  }
}