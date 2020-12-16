import 'package:munch/model/munch.dart';
import 'package:munch/model/response/get_filters_response.dart';

import 'api.dart';

class FiltersApi extends Api {
  static const String ENDPOINT_SET_PREFIX = 'munch';
  static const int API_VERSION = 1;

  FiltersApi() : super(endpointSetPrefix: ENDPOINT_SET_PREFIX, version: API_VERSION);

  Future<GetFiltersResponse> getFilters() async {
    String getUrl = "/categories";

    var data = await get(getUrl);

    GetFiltersResponse getFiltersResponse = GetFiltersResponseJsonSerializer().fromMap(data);

    return getFiltersResponse;
  }

  Future<Munch> updateFilters(
      {List<String> whitelistFiltersKeys, List<String> blacklistFiltersKeys, String munchId}) async {
    String postUrl = "/filters?munchId=$munchId";

    Map<String, dynamic> fields = {"whitelist": whitelistFiltersKeys, "blacklist": blacklistFiltersKeys};

    var data = await post(postUrl, fields);

    Munch munch = MunchJsonSerializer().fromMap(data['munchDetailed']);

    return munch;
  }
}
