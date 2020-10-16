import 'package:flutter/services.dart';

class DeepLinkHandler{
  static const _methodChannel = const MethodChannel('munch.munchapp.io/channel');
  static const _eventChannel = const EventChannel('munch.munchapp.io/events');

  static DeepLinkHandler _instance;

  DeepLinkHandler._internal();

  factory DeepLinkHandler.getInstance() {
    if (_instance == null) {
      _instance = DeepLinkHandler._internal();
    }
    return _instance;
  }

  void initializeDeepLinkListeners(){
    print("INVOKE 1");

    startUri().then(_onRedirected);

    print("INVOKE 2");

    //Checking broadcast stream, if deep link was clicked in opened appication
    _eventChannel.receiveBroadcastStream().listen((d) => _onRedirected(d));

    print("INVOKE 3");
  }

  Future<String> startUri() async {
    print("INVOKE 4");
    try {
      return _methodChannel.invokeMethod('initialLink');
    } on PlatformException catch (e) {
      return "Failed to Invoke: '${e.message}'.";
    }
  }

  void _onRedirected(String uri) {
    print("REDIRECTED");
  }
}