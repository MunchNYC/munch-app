import 'package:munch/model/munch.dart';
import 'package:munch/model/response/get_filters_response.dart';
import 'package:munch/model/secondary_filters.dart';

import 'api.dart';

class FiltersApi extends Api {
  static const String ENDPOINT_SET_PREFIX = 'munch';
  static const int API_VERSION = 1;

  FiltersApi() : super(endpointSetPrefix: ENDPOINT_SET_PREFIX, version: API_VERSION);

  Future<GetFiltersResponse> getFilters() async {
    String getUrl = "/categories";

    var data = await get(getUrl);

    GetFiltersResponse getFiltersResponse = GetFiltersResponse.fromJson(data);

    return getFiltersResponse;
  }

  Future<Munch> updateFilters(
      {List<String> whitelistFiltersKeys, List<String> blacklistFiltersKeys, String munchId}) async {
    String postUrl = "/filters?munchId=$munchId";

    Map<String, dynamic> fields = {"whitelist": whitelistFiltersKeys, "blacklist": blacklistFiltersKeys};

    var data = await post(postUrl, fields);

    Munch munch = Munch.fromJson(data['munchDetailed']);

    return munch;
  }

  Future<Munch> updateAllFilters({SecondaryFilters oldFilters, SecondaryFilters newFilters, List<String> whitelistFiltersKeys, List<String> blacklistFiltersKeys, String munchId}) async {
    assert ((oldFilters != null) == (newFilters != null) ||  (oldFilters == null) == (newFilters == null));
    String postUrl = "/preferences/searchfilters?munchId=$munchId";


    Map<String, dynamic> secondaryFiltersFields;

    if (oldFilters != null) {
      secondaryFiltersFields = {
        "currentPreferences" : oldFilters.toJson(),
        "updatedPreferences" : newFilters.toJson()
      };
    }

    Map<String, dynamic> fields = {
      "searchPreferences": secondaryFiltersFields,
      "userFilters": {
        "whitelist": whitelistFiltersKeys,
        "blacklist": blacklistFiltersKeys
      }
    };

    var data = await post(postUrl, fields);

    Munch munch = Munch.fromJson(data['munchDetailed']);

    return munch;
  }
}
