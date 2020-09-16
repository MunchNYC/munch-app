import 'package:munch/model/munch.dart';
import 'package:munch/model/restaurant.dart';

import 'api.dart';

class MunchApi extends Api {
  Future<List<Munch>> getMunches() async {
    String getUrl = "/munches";

    var data = await get(getUrl);

    List<Munch> munchesList = List<Munch>.from(data['compactMunches'].map((munchData){
      return MunchJsonSerializer().fromMap(munchData);
    }));

    return munchesList;
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
}