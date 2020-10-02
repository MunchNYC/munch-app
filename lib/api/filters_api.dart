import 'package:munch/model/filter.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/model/response/get_filters_response.dart';

import 'api.dart';

class FiltersApi extends Api {
  Future<GetFiltersResponse> getFilters() async {
    String getUrl = "/categories";

    var data = await get(getUrl);

    GetFiltersResponse getFiltersResponse = GetFiltersResponseJsonSerializer().fromMap(data);

    return getFiltersResponse;
  }

  Future<Munch> updateFilters({List<String> whitelistFiltersKeys, List<String> blacklistFiltersKeys, String munchId}) async {
    String postUrl = "/filters?munchId=$munchId";

    Map<String, dynamic> fields = {
      "whitelist": whitelistFiltersKeys,
      "blacklist": blacklistFiltersKeys
    };

    var data = await post(postUrl, fields);

    Munch munch = MunchJsonSerializer().fromMap(data['munchDetailed']);

    return munch;
  }
}