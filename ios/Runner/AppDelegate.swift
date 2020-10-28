import UIKit
import Flutter
import GoogleMaps
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private var methodChannel: FlutterMethodChannel?
  private var eventChannel: FlutterEventChannel?
    
  private let linkStreamHandler = LinkStreamHandler()

  private var absoluteStartUrl: String? = nil;
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyAnHswwvOR8G-m1GrXMMVx9ScQG6WVPLBE")
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    let controller = window.rootViewController as! FlutterViewController
    methodChannel = FlutterMethodChannel(name: "https.munch-app.com/channel", binaryMessenger: controller.binaryMessenger)
    eventChannel = FlutterEventChannel(name: "https.munch-app.com/events", binaryMessenger: controller.binaryMessenger)

    methodChannel?.setMethodCallHandler({ (call: FlutterMethodCall, result: FlutterResult) in
      guard call.method == "initialLink" else {
        result(FlutterMethodNotImplemented)
        return
      }
    
      result(self.absoluteStartUrl)
    })

    eventChannel?.setStreamHandler(linkStreamHandler)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    eventChannel?.setStreamHandler(linkStreamHandler)
    absoluteStartUrl = url.absoluteString
    return linkStreamHandler.handleLink(url.absoluteString)
  }
}

class LinkStreamHandler:NSObject, FlutterStreamHandler {
  var eventSink: FlutterEventSink?

  // links will be added to this queue until the sink is ready to process them
  var queuedLinks = [String]()

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    self.eventSink = events
    queuedLinks.forEach({ events($0) })
    queuedLinks.removeAll()
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    self.eventSink = nil
    return nil
  }

  func handleLink(_ link: String) -> Bool {
    guard let eventSink = eventSink else {
      queuedLinks.append(link)
      return false
    }
    eventSink(link)
    return true
  }
}
