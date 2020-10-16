import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:munch/config/app_config.dart';
import 'package:munch/repository/user_repository.dart';

class NotificationsHandler{
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

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
    bool permissionRequestResult = await _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    );

    if(permissionRequestResult == null || permissionRequestResult) {
      await _initializeLocalNotifications();
      await _setCurrentFCMToken();
      await _registerFCMTokenListener();
    }
  }

  Future _initializeLocalNotifications() async{
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: _onNotificationTapped);
  }

  void stopNotifications(){
    _disposeFCMTokenListener();
  }

  Future _saveFCMToken(String fcmToken) async{
    await UserRepo.getInstance().setFCMToken(fcmToken);
  }

  Future _setCurrentFCMToken() async{
    String fcmToken = await _firebaseMessaging.getToken();

    if(fcmToken != null){
      await _saveFCMToken(fcmToken);
    }
  }

  Future _registerFCMTokenListener() async {
    _fcmTokenListener = _firebaseMessaging.onTokenRefresh.listen((fcmToken) async {
      await _saveFCMToken(fcmToken);
    });
  }

  void _disposeFCMTokenListener(){
    _fcmTokenListener?.cancel();
  }

  Future _onNotificationTapped(String payload) async {
    print(payload);
  }

  void _configureNotificationsReceiveCallbacks(){
    _firebaseMessaging.configure(
        // App in Foreground
        onMessage: (Map<String, dynamic> message) {
          print('onMessage: $message');

          Platform.isAndroid
              ? _showNotification(message['notification']) // message structure is different for Android and iOS
              : _showNotification(message['aps']['alert']);
          return;
        },
        onBackgroundMessage: null,
        // App in Background
        onResume: (Map<String, dynamic> message) {
          print('onResume: $message');

          // TODO HANDLE NOTIFICATIONS
          return;
        },
        // App Terminated
        onLaunch: (Map<String, dynamic> message) {
          print('onLaunch: $message');

          // TODO HANDLE NOTIFICATIONS
          return;
        }
    );
  }

  void _showNotification(Map<String, String> message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      AppConfig.getInstance().packageInfo.packageName,
      AppConfig.getInstance().packageInfo.packageName,
      AppConfig.getInstance().packageInfo.packageName,
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(0,
        message['title'].toString(),
        message['body'].toString(),
        platformChannelSpecifics,
        payload: message['deeplink']
    );
  }
}