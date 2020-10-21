import 'package:munch/api/munch_api.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/model/restaurant.dart';
import 'package:munch/model/user.dart';

class MunchRepo {
  static MunchRepo _instance;

  MunchApi _munchApi = MunchApi();

  Map<MunchStatus, List<Munch>> munchStatusLists;
  Map<String, Munch> munchMap;

  MunchRepo._internal(){
    munchStatusLists = Map<MunchStatus, List<Munch>>();

    for(int i = 0; i < MunchStatus.values.length; i++){
      munchStatusLists[MunchStatus.values[i]] = List<Munch>();
    }

    munchMap = Map<String, Munch>();
  }

  factory MunchRepo.getInstance() {
    if (_instance == null) {
      _instance = MunchRepo._internal();
    }
    return _instance;
  }

  void _clearMunchCache(){
    for(int i = 0; i < MunchStatus.values.length; i++){
      munchStatusLists[MunchStatus.values[i]].clear();
    }

    munchMap.clear();
  }

  void _deleteMunchFromCache(Munch munch){
    List<Munch> munchList = munchStatusLists[munch.munchStatus];

    munchList.removeWhere((element) => munch.id == element.id);

    munchMap[munch.id] = null;
  }

  void updateMunchCache(Munch newMunch){
    Munch currentMunch = munchMap[newMunch.id];
    List<Munch> newMunchList = munchStatusLists[newMunch.munchStatus];

    if(currentMunch != null) {
      List<Munch> currentMunchList = munchStatusLists[currentMunch.munchStatus];

      if(currentMunchList != newMunchList) {
        _deleteMunchFromCache(currentMunch);

        newMunchList.insert(0, currentMunch);

        // _delete is removing it from map
        munchMap[newMunch.id] = currentMunch;
      }

      currentMunch.merge(newMunch);
    } else{
      newMunchList.insert(0, newMunch);

      munchMap[newMunch.id] = newMunch;
    }

  }

  Future getMunches() async{
    List<Munch> munches = await _munchApi.getMunches();

    _clearMunchCache();

    munchMap.clear();

    for(int i = 0; i < munches.length; i++){
      Munch munch = munches[i];

      munchStatusLists[munch.munchStatus].add(munch);

      munchMap[munch.id] = munch;
    }
  }

  Future<Munch> joinMunch(String munchCode) async{
    String munchId = await _munchApi.getMunchIdForCode(munchCode);

    Munch munch = await _munchApi.joinMunch(munchId);

    updateMunchCache(munch);

    return munch;
  }

  Future<Munch> createMunch(Munch munch) async{
    Munch createdMunch = await _munchApi.createMunch(munch);

    updateMunchCache(createdMunch);

    return createdMunch;
  }

  Future<Munch> getDetailedMunch(String munchId) async{
    Munch munch = await _munchApi.getDetailedMunch(munchId);

    updateMunchCache(munch);

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

    updateMunchCache(munch);

    return munch;
  }

  Future<Munch> saveMunchPreferences({String munchId, String munchName, bool notificationsEnabled}) async {
    Munch munch = await _munchApi.saveMunchPreferences(
      munchId: munchId,
      munchName: munchName,
      notificationsEnabled: notificationsEnabled,
    );

    updateMunchCache(munch);

    return munch;
  }

  Future<Munch> kickMember({String munchId, String userId}) async{
    Munch munch = await _munchApi.removeUserFromMunch(
        munchId: munchId,
        userId: userId
    );

    /*
        This must be done, because otherwise after updateMunchCache user can exists in Munch even if kicked, if partial response received on Kick
     */
    // if response munch has empty members array (partial result 206)
    if(munch.members.length == 0){
      Munch currentMunch = munchMap[munchId];
      // manually remove user from members list, after that we can merge munches
      currentMunch.members.removeWhere((User user)=> user.uid == userId);
      currentMunch.numberOfMembers--;
    }

    updateMunchCache(munch);

    return munch;
  }

  Future leaveMunch({String munchId}) async{
    await _munchApi.deleteSelfFromMunch(munchId: munchId);

    _deleteMunchFromCache(munchMap[munchId]);
  }

  Future<Munch> cancelMunchDecision({String munchId}) async {
    Munch munch = await _munchApi.cancelMunchDecision(
      munchId: munchId,
    );

    updateMunchCache(munch);

    return munch;
  }
}