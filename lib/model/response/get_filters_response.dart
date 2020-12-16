import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:munch/model/filter.dart';

part 'get_filters_response.jser.dart';

class GetFiltersResponse {
  List<Filter> allFilters;
  List<Filter> topFilters;

  GetFiltersResponse({this.allFilters, this.topFilters});
}

@GenSerializer()
class GetFiltersResponseJsonSerializer extends Serializer<GetFiltersResponse>
    with _$GetFiltersResponseJsonSerializer {}
