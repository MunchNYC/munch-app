import 'package:munch/analytics/analytics_repository.dart';
import 'package:munch/util/utility.dart';

class Event {
  String eventName;
  Map<String, String> properties;

  Event(this.eventName,  this.properties);
}

class SwipeScreenEvents {
  static Event swipedRight(String restaurantId) {
    return Event('SwipedRight', { 'restaurantId': restaurantId });
  }

  static Event swipedLeft(String restaurantId) {
    return Event('SwipedLeft', { 'restaurantId': restaurantId });
  }

  static Event photoImpression(String restaurantId, Map<String, int> impressions) {
    int nextPhoto = impressions[Utility.convertEnumValueToString(ImpressionDirection.NEXT)] ?? 0;
    int previousPhoto = impressions[Utility.convertEnumValueToString(ImpressionDirection.PREVIOUS)] ?? 0;

    return Event(
        'ImageImpressions',
        {
          'restaurantId': restaurantId,
          'totalImpressions': (nextPhoto + previousPhoto).toString(),
          'nextPhoto': nextPhoto.toString(),
          'previousPhoto': previousPhoto.toString(),
          'deadEnd': (impressions[Utility.convertEnumValueToString(ImpressionDirection.DEADEND)] ?? 0).toString()
        }
    );
  }
}