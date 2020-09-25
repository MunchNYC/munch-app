import 'package:munch/model/filter.dart';
import 'package:munch/model/response/get_filters_response.dart';

import 'api.dart';

class FiltersApi extends Api {
  Future<GetFiltersResponse> getFilters() async {
    String getUrl = "/categories";

    var data = await get(getUrl);

    GetFiltersResponse getFiltersResponse = GetFiltersResponseJsonSerializer().fromMap(data);

    return getFiltersResponse;
  }
}