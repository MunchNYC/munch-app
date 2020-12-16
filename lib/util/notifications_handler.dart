import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:munch/repository/user_repository.dart';
import 'package:munch/service/notification/notifications_bloc.dart';
import 'package:munch/service/notification/notifications_event.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/util/deep_link_handler.dart';
import 'package:munch/util/utility.dart';

class NotificationsHandler {
  static const ANDROID_NOTIFICATION_CHANNEL_DEFAULT_NAME = "MUNCH-NOTIFICATION-CHANNEL";

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Map<NotificationEventType, Function> notificationsEventTypeMap;

  NotificationsBloc notificationsBloc;

  StreamSubscription<String> _fcmTokenListener;

  static NotificationsHandler _instance;

  NotificationsHandler._internal() {
    _configureNotificationsReceiveCallbacks();

    notificationsEventTypeMap = Map.of({
      NotificationEventType.DECISION_MADE: _generateDecisionMadeNotificationEvent,
      NotificationEventType.MATCH_CLEARED: _generateNewRestaurantNotificationEvent,
      NotificationEventType.NEW_MUNCHER: _generateNewMuncherNotificationEvent,
      NotificationEventType.USER_REMOVED: _generateKickMemberNotificationEvent,
      NotificationEventType.INFORMATION: () => null
    });
  }

  factory NotificationsHandler.getInstance() {
    if (_instance == null) {
      _instance = NotificationsHandler._internal();
    }
    return _instance;
  }

  Future initializeNotifications() async {
    notificationsBloc = NotificationsBloc();

    // It will return null for Android
    bool permissionRequestResult = await _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    );

    if (permissionRequestResult == null || permissionRequestResult) {
      await _initializeLocalNotifications();
      await _setCurrentFCMToken();
      await _registerFCMTokenListener();
    }
  }

  Future _initializeLocalNotifications() async {
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _onNotificationTapped);
  }

  void stopNotifications() {
    _disposeFCMTokenListener();

    notificationsBloc?.close();
  }

  Future _saveFCMToken(String fcmToken) async {
    await UserRepo.getInstance().setFCMToken(fcmToken);
  }

  Future _setCurrentFCMToken() async {
    String fcmToken = await _firebaseMessaging.getToken();

    if (fcmToken != null) {
      await _saveFCMToken(fcmToken);
    }
  }

  Future _registerFCMTokenListener() async {
    _fcmTokenListener = _firebaseMessaging.onTokenRefresh.listen((fcmToken) async {
      await _saveFCMToken(fcmToken);
    });
  }

  void _disposeFCMTokenListener() {
    _fcmTokenListener?.cancel();
  }

  Future _onNotificationTapped(var payload) async {
    DeepLinkHandler.getInstance().onDeepLinkReceived(payload);
  }

  NotificationsEvent _generateDecisionMadeNotificationEvent(Map messageData) {
    return DecisionMadeNotificationEvent(
        munchId: messageData['munchId'],
        timestampUTC: Utility.convertUnixTimestampToUTC(int.parse(messageData['timestamp'])));
  }

  NotificationsEvent _generateNewRestaurantNotificationEvent(Map messageData) {
    return NewRestaurantNotificationEvent(
        munchId: messageData['munchId'],
        timestampUTC: Utility.convertUnixTimestampToUTC(int.parse(messageData['timestamp'])));
  }

  NotificationsEvent _generateNewMuncherNotificationEvent(Map messageData) {
    return NewMuncherNotificationEvent(
        munchId: messageData['munchId'],
        timestampUTC: Utility.convertUnixTimestampToUTC(int.parse(messageData['timestamp'])));
  }

  NotificationsEvent _generateKickMemberNotificationEvent(Map messageData) {
    return KickMemberNotificationEvent(
        munchId: messageData['munchId'],
        timestampUTC: Utility.convertUnixTimestampToUTC(int.parse(messageData['timestamp'])));
  }

  NotificationsEvent _mapNotificationEventType(Map messageData) {
    NotificationEventType notificationEventType =
        NotificationEventType.values.firstWhere((type) => type.toString().split(".").last == messageData['eventType']);
    return notificationsEventTypeMap[notificationEventType](messageData);
  }

  void _configureNotificationsReceiveCallbacks() {
    try {
      _firebaseMessaging.configure(
          // App in Foreground
          onMessage: (Map<String, dynamic> message) {
            print('onMessage: $message');

            NotificationsEvent notificationsEvent = Platform.isAndroid
                ? _mapNotificationEventType(message['data']) // message structure is different for Android and iOS
                : _mapNotificationEventType(message);

            // INFORMATION is returning NULL event
            if (notificationsEvent != null) {
              notificationsBloc.add(notificationsEvent);
            }

            Platform.isAndroid
                ? _showNotification(
                    message['notification'], message['data']) // message structure is different for Android and iOS
                : _showNotification(message['notification'] ?? message['aps']['alert'], message);

            return;
          },
          onBackgroundMessage: null,
          /*
              App in Background, Notification will be shown without manual call of the method showNotifications
              Kernel's function handles display of notification title and body.
              Method is called when notification is tapped
            */
          onResume: (Map<String, dynamic> message) {
            print('onResume: $message');

            Platform.isAndroid
                ? _onNotificationTapped(
                    message['data']['deeplink']) // message structure is different for Android and iOS
                : _onNotificationTapped(message['deeplink']);

            return;
          },
          /*
              App Terminated, Notification will be shown without manual call of the method showNotifications
              Kernel's function handles display of notification title and body.
              Method is called when notification is tapped
            */
          onLaunch: (Map<String, dynamic> message) {
            print('onLaunch: $message');

            Platform.isAndroid
                ? _onNotificationTapped(
                    message['data']['deeplink']) // message structure is different for Android and iOS
                : _onNotificationTapped(message['deeplink']);

            return;
          });

      print("Notifications listener configured");
    } on Exception catch (e, s) {
      print(s);
    }
  }

  void _showNotification(Map notification, Map data) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      ANDROID_NOTIFICATION_CHANNEL_DEFAULT_NAME,
      ANDROID_NOTIFICATION_CHANNEL_DEFAULT_NAME,
      ANDROID_NOTIFICATION_CHANNEL_DEFAULT_NAME,
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
      color: Palette.secondaryDark,
      ledColor: Palette.secondaryDark,
      ledOnMs: 1000,
      ledOffMs: 1000,
      enableLights: true,
      styleInformation: BigTextStyleInformation(''),
    );

    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      notification['title'],
      notification['body'],
      platformChannelSpecifics,
      payload: data['deeplink'],
    );
  }
}

enum NotificationEventType { MATCH_CLEARED, DECISION_MADE, NEW_MUNCHER, USER_REMOVED, INFORMATION }
