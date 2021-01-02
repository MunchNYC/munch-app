import 'package:flutuate_mixpanel/flutuate_mixpanel.dart';
import 'package:munch/analytics/events.dart';
import 'package:munch/model/user.dart';
import 'package:munch/repository/user_repository.dart';

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

  void _initializeMixpanel() async {
    await MixpanelAPI.getInstance(_token).then((mixpanel) {
      _mixpanel = mixpanel;
    });
    _mixpanel.registerSuperProperties(_superProperties());
  }

  void track(Event event) async {
    if (_mixpanel == null) await _initializeMixpanel();
    _mixpanel.track(event.eventName, event.properties);
  }

  Map<String, String> _superProperties() {
    User user = UserRepo.getInstance().currentUser;
    return {
      "gender": user.gender.toString(),
      "birthday": user.birthday
    };
  }


}
