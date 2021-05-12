import 'package:munch/analytics/analytics_api.dart';
import 'package:munch/analytics/events.dart';

class AnalyticsRepo {
  static AnalyticsRepo _instance;

  AnalyticsRepo._internal();

  factory AnalyticsRepo.getInstance() {
    if (_instance == null) _instance = AnalyticsRepo._internal();
    return _instance;
  }

  void trackImpressions(String restaurantId, Map<String, int> impressions) {
    Analytics.getInstance().track(SwipeScreenEvents.photoImpression(restaurantId, impressions));
  }

  void trackSwipeScreenLeftSwipe(String restaurantId) {
    Analytics.getInstance().track(SwipeScreenEvents.swipedLeft(restaurantId));
  }

  void trackSwipeScreenRightSwipe(String restaurantId) {
    Analytics.getInstance().track(SwipeScreenEvents.swipedRight(restaurantId));
  }

  void trackShareGroupPostCreate(String munchId, String groupName) {
    Analytics.getInstance().track(Event('ShareGroupPostCreate', {
      'groupId': munchId,
      'groupName': groupName,
    }));
  }
  void trackShareGroupFromOptions(String munchId, String groupName) {
    Analytics.getInstance().track(Event('ShareGroupFromOptions', {
      'groupId': munchId,
      'groupName': groupName,
    }));
  }
  void trackInviteFriend() {
    Analytics.getInstance().track(Event('InviteFriend', {}));
  }
}

enum ImpressionDirection { NEXT, PREVIOUS, NEXTDEADEND, PREVIOUSDEADEND, UNIQUE }
