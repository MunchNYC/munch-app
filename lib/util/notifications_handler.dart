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
      _registerFCMTokenListener();
    }
  }

  void stopNotifications(){
    _disposeFCMTokenListener();
  }

  void _registerFCMTokenListener(){
    _fcmTokenListener = firebaseMessaging.onTokenRefresh.listen((token) {
      UserRepo.getInstance().setFCMToken(token);
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