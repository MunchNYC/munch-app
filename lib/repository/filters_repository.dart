import 'package:munch/api/api.dart';
import 'package:munch/api/filters_api.dart';
import 'package:munch/model/filter.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/model/response/get_filters_response.dart';
import 'package:munch/repository/munch_repository.dart';

class FiltersRepo {
  static FiltersRepo _instance;

  FiltersRepo._internal();

  factory FiltersRepo.getInstance() {
    if (_instance == null) {
      _instance = FiltersRepo._internal();
    }
    return _instance;
  }

  FiltersApi _filtersApi = FiltersApi();

  MunchRepo _munchRepo = MunchRepo.getInstance();

  /*
    Filters will be fetched just first time when user opens filters screen, will be cached here
   */
  List<Filter> _allFilters;
  List<Filter> _topFilters;

  List<Filter> get allFilters => _allFilters;
  List<Filter> get topFilters => _topFilters;

  Future<GetFiltersResponse> getFilters() async{
    GetFiltersResponse getFiltersResponse = await _filtersApi.getFilters();

    _allFilters = getFiltersResponse.allFilters;
    _topFilters = getFiltersResponse.topFilters;

    return getFiltersResponse;
  }

  Future<Munch> updateFilters({List<Filter> whitelistFilters, List<Filter> blacklistFilters, String munchId}) async{
    try {
      List<String> whitelistFiltersKeys = whitelistFilters.map((Filter filter) => filter.key).toList();
      List<String> blacklistFiltersKeys = blacklistFilters.map((Filter filter) => filter.key).toList();

      Munch munch = await _filtersApi.updateFilters(
          whitelistFiltersKeys: whitelistFiltersKeys,
          blacklistFiltersKeys: blacklistFiltersKeys,
          munchId: munchId
      );

      _munchRepo.updateMunchCache(munch);

      return munch;
    } on AccessDeniedException catch (error) {
      _munchRepo.deleteMunchFromCache(munchId);

      throw error;
    }
  }
}