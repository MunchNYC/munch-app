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
    int nextDeadEnd = impressions[Utility.convertEnumValueToString(ImpressionDirection.NEXTDEADEND)] ?? 0;
    int previousDeadEnd = impressions[Utility.convertEnumValueToString(ImpressionDirection.PREVIOUSDEADEND)] ?? 0;
    // starts at 0 to match carousel index, but first photo is always seen so we +1.
    int uniquePhotosSeen = (impressions[Utility.convertEnumValueToString(ImpressionDirection.UNIQUE)] ?? 0) + 1;

    return Event(
        'ImageImpressions',
        {
          'restaurantId': restaurantId,
          'totalImpressions': (nextPhoto + previousPhoto).toString(),
          'nextPhoto': nextPhoto.toString(),
          'previousPhoto': previousPhoto.toString(),
          'nextDeadEnd': nextDeadEnd.toString(),
          'previousDeadEnd': previousDeadEnd.toString(),
          'uniquePhotos': uniquePhotosSeen.toString()
        }
    );
  }
}