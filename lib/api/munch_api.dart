import 'package:munch/model/munch.dart';
import 'package:munch/model/response/get_munches_response.dart';
import 'package:munch/model/restaurant.dart';

import 'api.dart';

class MunchApi extends Api {
  static const String ENDPOINT_SET_PREFIX = 'munch';
  static const int API_VERSION = 1;

  MunchApi(): super(endpointSetPrefix: ENDPOINT_SET_PREFIX, version: API_VERSION);

  Future<GetMunchesResponse> getMunches() async {
    String getUrl = "/munches";

    var data = await get(getUrl);

    GetMunchesResponse getMunchesResponse = GetMunchesResponseJsonSerializer().fromMap(data);

    return getMunchesResponse;
  }

  Future<String> getMunchIdForCode(String munchCode) async {
    String postUrl = "/code";

    Map<String, dynamic> fields = {
      "munchCode": munchCode,
    };

    var data = await post(postUrl, fields);

    String munchId = data['munchId'];

    return munchId;
  }

  Future<Munch> joinMunch(String munchId) async {
    String postUrl = "/join?munchId=$munchId";

    Map<String, dynamic> fields = {
      "munchId": munchId,
    };

    var data = await post(postUrl, fields);

    Munch munch = MunchJsonSerializer().fromMap(data['munchDetailed']);

    return munch;
  }

  Future<Munch> createMunch(Munch munch) async {
    String postUrl = "/create";

    Map<String, dynamic> fields = MunchJsonSerializer().toMap(munch);

    var data = await post(postUrl, fields);

    Munch createdMunch = MunchJsonSerializer().fromMap(data['munchDetailed']);

    return createdMunch;
  }

  Future<Munch> getDetailedMunch(String munchId) async {
    String getUrl = "/munch?munchId=$munchId";

    var data = await get(getUrl);

    Munch munch = MunchJsonSerializer().fromMap(data['munchDetailed']);

    return munch;
  }

  Future<List<Restaurant>> getSwipeRestaurantsPage(String munchId) async {
    String getUrl = "/restaurants?munchId=$munchId";

    var data = await get(getUrl);

    List<Restaurant> restaurantList = List<Restaurant>.from(data['restaurants'].map((restaurantData){
      return RestaurantJsonSerializer().fromMap(restaurantData);
    }));

    return restaurantList;
  }

  Future<Munch> swipeRestaurant({String munchId, String restaurantId, bool liked}) async {
    String postUrl = "/swipe?munchId=$munchId";

    Map<String, dynamic> fields = {
      "restaurantId": restaurantId,
      "liked": liked
    };

    var data = await post(postUrl, fields);

    Munch munch = MunchJsonSerializer().fromMap(data['munchDetailed']);

    return munch;
  }

  Future<Munch> saveMunchPreferences({String munchId, String munchName, bool notificationsEnabled}) async {
    String putUrl = "/preferences?munchId=$munchId";

    Map<String, dynamic> fields = {
      "name": munchName,
      "receivePushNotifications": notificationsEnabled
    };

    var data = await put(putUrl, fields);

    Munch munch = MunchJsonSerializer().fromMap(data['munchDetailed']);

    return munch;
  }

  Future<Munch> removeUserFromMunch({String munchId, String userId}) async {
    String postUrl = "/user/remove?munchId=$munchId";

    Map<String, dynamic> fields = {
      "userId": userId,
    };

    var data = await post(postUrl, fields);

    Munch munch = MunchJsonSerializer().fromMap(data['munchDetailed']);

    return munch;
  }

  Future deleteSelfFromMunch({String munchId}) async {
    String deleteUrl = "/munch/user?munchId=$munchId";

    await delete(deleteUrl);
  }

  Future<Munch> cancelMunchDecision({String munchId}) async {
    String deleteUrl = "/match?munchId=$munchId";

    var data = await delete(deleteUrl);

    Munch munch = MunchJsonSerializer().fromMap(data['munchDetailed']);

    return munch;
  }

  Future<Munch> reviewMunch({String reviewValue, String munchId}) async {
    String postUrl = "/review?munchId=$munchId";

    Map<String, dynamic> fields = {
      "review": reviewValue,
    };

    var data = await post(postUrl, fields);

    Munch munch = MunchJsonSerializer().fromMap(data['munchDetailed']);

    return munch;
  }
}