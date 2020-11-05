import 'package:munch/api/api.dart';
import 'package:munch/api/munch_api.dart';
import 'package:munch/model/coordinates.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/model/response/get_munches_response.dart';
import 'package:munch/model/restaurant.dart';
import 'package:munch/model/user.dart';
import 'package:munch/util/utility.dart';

class MunchRepo {
  static MunchRepo _instance;

  MunchApi _munchApi = MunchApi();

  Map<MunchStatus, List<Munch>> munchStatusLists;
  Map<String, Munch> munchMap;

  MunchRepo._internal(){
    munchStatusLists = Map<MunchStatus, List<Munch>>();

    munchStatusLists[MunchStatus.UNDECIDED] = List<Munch>();
    munchStatusLists[MunchStatus.DECIDED] = List<Munch>();
    munchStatusLists[MunchStatus.UNMODIFIABLE] = List<Munch>();
    munchStatusLists[MunchStatus.HISTORICAL] = List<Munch>();

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

  void deleteMunchFromCache(String munchId){
    Munch munch = munchMap[munchId];

    if(munch != null) {
      List<Munch> munchList = munchStatusLists[munch.munchStatus];

      munchList.removeWhere((element) => munch.id == element.id);

      munchMap[munch.id] = null;
    }
  }

  /*
    Insert munch to munchList sorted by creation timestamp
   */
  void _insertSortedToMunchList(List<Munch> munchList, Munch munch){
    int indexToInsert = munchList.length;

    for(int i = 0; i < munchList.length; i++){
      Munch currentMunch = munchList[i];

      if(currentMunch.creationTimestamp.isBefore(munch.creationTimestamp)){
        indexToInsert = i;
        break;
      }
    }

    munchList.insert(indexToInsert, munch);
  }

  void updateMunchCache(Munch newMunch){
    Munch currentMunch = munchMap[newMunch.id];
    List<Munch> newMunchList = munchStatusLists[newMunch.munchStatus];

    if(currentMunch != null) {
      List<Munch> currentMunchList = munchStatusLists[currentMunch.munchStatus];

      if(currentMunchList != newMunchList) {
        deleteMunchFromCache(currentMunch.id);

        _insertSortedToMunchList(newMunchList, currentMunch);

        // _delete is removing it from map
        munchMap[newMunch.id] = currentMunch;
      }

      currentMunch.merge(newMunch);
    } else{
      _insertSortedToMunchList(newMunchList, newMunch);

      munchMap[newMunch.id] = newMunch;
    }
  }

  void _addMunchToCache(Munch munch){
    munchStatusLists[munch.munchStatus].add(munch);

    munchMap[munch.id] = munch;
  }

  Future<GetMunchesResponse> getMunches() async{
    GetMunchesResponse getMunchesResponse = await _munchApi.getMunches();

    _clearMunchCache();

    for(int i = 0; i < getMunchesResponse.undecidedMunches.length; i++){
      _addMunchToCache(getMunchesResponse.undecidedMunches[i]);
    }

    for(int i = 0; i < getMunchesResponse.decidedMunches.length; i++){
      _addMunchToCache(getMunchesResponse.decidedMunches[i]);
    }

    return getMunchesResponse;
  }

  Future<List<Munch>> getHistoricalMunches({int page, int timestamp}) async{
    List<Munch> historicalMunchesList = await _munchApi.getHistoricalMunches(page: page, timestamp: timestamp);

    for(int i = 0; i < historicalMunchesList.length; i++){
      updateMunchCache(historicalMunchesList[i]);
    }

    return historicalMunchesList;
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
    try {
      Munch munch = await _munchApi.getDetailedMunch(munchId);

      updateMunchCache(munch);

      return munch;
    } on AccessDeniedException catch (error) {
      deleteMunchFromCache(munchId);

      throw error;
    }
  }

  Future<List<Restaurant>> getSwipeRestaurantsPage(String munchId) async{
    try {
      List<Restaurant> restaurantList = await _munchApi.getSwipeRestaurantsPage(
          munchId);

      for (int i = 0; i < restaurantList.length; i++) {
        // remove days with no data for working times
        restaurantList[i].workingHours.removeWhere((element) =>
        element.workingTimes.length == 0);
      }

      return restaurantList;
    } on AccessDeniedException catch (error) {
      deleteMunchFromCache(munchId);

      throw error;
    }
  }

  Future<Munch> swipeRestaurant({String munchId, String restaurantId, bool liked}) async {
    try {
      Munch munch = await _munchApi.swipeRestaurant(
          munchId: munchId,
          restaurantId: restaurantId,
          liked: liked
      );

      updateMunchCache(munch);

      return munch;
    } on AccessDeniedException catch (error) {
      deleteMunchFromCache(munchId);

      throw error;
    }
  }

  Future<Munch> saveMunchPreferences({String munchId, String munchName, bool notificationsEnabled}) async {
    try {
      Munch munch = await _munchApi.saveMunchPreferences(
        munchId: munchId,
        munchName: munchName,
        notificationsEnabled: notificationsEnabled,
      );

      updateMunchCache(munch);

      return munch;
    } on AccessDeniedException catch (error) {
      deleteMunchFromCache(munchId);

      throw error;
    }
  }

  Future<Munch> updateMunchLocation({String munchId, Coordinates coordinates, int radius}) async {
    try {
      Munch munch = await _munchApi.saveMunchPreferences(
        munchId: munchId,
        coordinates: coordinates,
        radius: radius,
      );

      updateMunchCache(munch);

      return munch;
    } on AccessDeniedException catch (error) {
      deleteMunchFromCache(munchId);

      throw error;
    }
  }

  Future<Munch> kickMember({String munchId, String userId}) async{
    try {
      Munch munch = await _munchApi.removeUserFromMunch(
          munchId: munchId,
          userId: userId
      );

      /*
        This must be done, because otherwise after updateMunchCache user can exists in Munch even if kicked, if partial response received on Kick
     */
      // if response munch has empty members array (partial result 206)
      if (munch.members.length == 0) {
        Munch currentMunch = munchMap[munchId];
        // manually remove user from members list, after that we can merge munches
        currentMunch.members.removeWhere((User user) => user.uid == userId);
        currentMunch.numberOfMembers--;
      }

      updateMunchCache(munch);

      return munch;
    } on AccessDeniedException catch (error) {
      deleteMunchFromCache(munchId);

      throw error;
    }
  }

  Future leaveMunch({String munchId}) async{
    try {
      await _munchApi.deleteSelfFromMunch(munchId: munchId);

      deleteMunchFromCache(munchId);
    } on AccessDeniedException catch (error) {
      deleteMunchFromCache(munchId);

      throw error;
    }
  }

  Future<Munch> cancelMunchDecision({String munchId}) async {
    try {
      Munch munch = await _munchApi.cancelMunchDecision(
        munchId: munchId,
      );

      updateMunchCache(munch);

      return munch;
    } on AccessDeniedException catch (error) {
      deleteMunchFromCache(munchId);

      throw error;
    }
  }

  Future<Munch> reviewMunch({MunchReviewValue munchReviewValue, String munchId}) async {
    try {
      Munch munch = await _munchApi.reviewMunch(
        reviewValue: Utility.convertEnumValueToString(munchReviewValue),
        munchId: munchId,
      );

      updateMunchCache(munch);

      return munch;
    } on AccessDeniedException catch (error) {
      deleteMunchFromCache(munchId);

      throw error;
    }
  }

}