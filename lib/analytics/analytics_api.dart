import 'package:flutuate_mixpanel/flutuate_mixpanel.dart';
import 'package:munch/analytics/events/event.dart';
import 'package:munch/model/user.dart';
import 'package:munch/repository/user_repository.dart';
import 'package:munch/util/utility.dart';

class Analytics {
  static Analytics _instance;

  Analytics._internal();

  factory Analytics.getInstance() {
    if (_instance == null) {
      _instance = Analytics._internal();
    }
    return _instance;
  }

  MixpanelAPI _mixpanel;
  final String _token = '9d7269369114f9104c6be9a08684ce06';
  bool identityConfigured = false;

  Future<void> _initializeMixpanel() async {
    if (_mixpanel == null) {
      await MixpanelAPI.getInstance(_token).then((mixpanel) {
        _mixpanel = mixpanel;
      });
    }
    User user = UserRepo.getInstance().currentUser;
    if (user != null && !identityConfigured) {
      String mixPanelDistinctId = await _mixpanel.getDistinctId();
      Map<String, String> userSuperProperties = _superPropertiesForUser(user);
      _mixpanel.alias(userSuperProperties["uid"], mixPanelDistinctId);
      _mixpanel.identify(userSuperProperties["uid"]);
      _mixpanel.people.set(userSuperProperties);
      _mixpanel.registerSuperProperties(userSuperProperties);
      identityConfigured = true;
    }
  }

  Future<void> track(Event event) async {
    await _initializeMixpanel();
    _mixpanel.track(event.eventName, event.properties);
    print("tracking event: " + event.eventName + " with properties: ");
    print(event.properties);
  }

  Future<void> resetMixpanel() async {
    await _initializeMixpanel();
    _mixpanel.reset();
    identityConfigured = false;
  }

  Map<String, String> _superPropertiesForUser(User user) {
    return {
      "uid": user.uid,
      "\$email": user.email,
      "gender": Utility.convertEnumValueToString(user.gender),
      "birthday": user.birthday
    };
  }
}
