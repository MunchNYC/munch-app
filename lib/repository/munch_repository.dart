import 'package:munch/api/munch_api.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/model/restaurant.dart';

class MunchRepo {
  static MunchRepo _instance;

  MunchRepo._internal();

  factory MunchRepo.getInstance() {
    if (_instance == null) {
      _instance = MunchRepo._internal();
    }
    return _instance;
  }

  MunchApi _munchApi = MunchApi();

  Future<Map<MunchStatus, List<Munch>>> getMunches() async{
    List<Munch> munches = await _munchApi.getMunches();

    Map<MunchStatus, List<Munch>> munchesMap = Map<MunchStatus, List<Munch>>();

    for(int i = 0; i < MunchStatus.values.length; i++){
      munchesMap[MunchStatus.values[i]] = List<Munch>();
    }

    for(int i = 0; i < munches.length; i++){
      Munch munch = munches[i];

      munchesMap[munch.munchStatus].add(munch);
    }

    return munchesMap;
  }

  Future<Munch> joinMunch(String munchCode) async{
    String munchId = await _munchApi.getMunchIdForCode(munchCode);

    Munch munch = await _munchApi.joinMunch(munchId);

    return munch;
  }

  Future<Munch> createMunch(Munch munch) async{
    Munch createdMunch = await _munchApi.createMunch(munch);

    return createdMunch;
  }

  Future<Munch> getDetailedMunch(String munchId) async{
    Munch munch = await _munchApi.getDetailedMunch(munchId);

    return munch;
  }

  Future<List<Restaurant>> getSwipeRestaurantsPage(String munchId) async{
    List<Restaurant> restaurantList = await _munchApi.getSwipeRestaurantsPage(munchId);

    return restaurantList;
  }

  Future<Munch> swipeRestaurant({String munchId, String restaurantId, bool liked}) async {
    Munch munch = await _munchApi.swipeRestaurant(
        munchId: munchId,
        restaurantId: restaurantId,
        liked: liked
    );

    return munch;
  }

  Future<Munch> saveMunchPreferences({String munchId, String munchName, bool notificationsEnabled}) async {
    Munch munch = await _munchApi.saveMunchPreferences(
      munchId: munchId,
      munchName: munchName,
      notificationsEnabled: notificationsEnabled,
    );

    return munch;
  }

  Future<Munch> kickMember({String munchId, String userId}) async{
    Munch munch = await _munchApi.removeUserFromMunch(
        munchId: munchId,
        userId: userId
    );

    return munch;
  }

  Future leaveMunch({String munchId}) async{
    await _munchApi.deleteSelfFromMunch(munchId: munchId,);
  }
}