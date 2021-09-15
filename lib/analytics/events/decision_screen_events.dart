import 'package:munch/analytics/events/event.dart';

class DecisionScreenEvents {
  static Event call(String restaurantName, String munchId) {
    return Event('CallRestaurantTapped', {
      'restaurantName': restaurantName,
      'munchId': munchId
    });
  }

  static Event viewMap(String restaurantName, String munchId) {
    return Event('ViewMapTapped', {
      'restaurantName': restaurantName,
      'munchId': munchId
    });
  }

  static Event yelpTapped(String restaurantName, String munchId) {
    return Event('YelpTapped', {
      'restaurantName': restaurantName,
      'munchId': munchId
    });
  }

  static Event deliverZeroTapped(String restaurantName, String munchId) {
    return Event('DeliverZeroTapped', {
      'restaurantName': restaurantName,
      'munchId': munchId
    });
  }
}
