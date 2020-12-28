import 'package:json_annotation/json_annotation.dart';
import 'package:munch/model/filter.dart';

part 'get_filters_response.g.dart';

@JsonSerializable()
class GetFiltersResponse {
  @JsonKey(defaultValue: [])
  List<Filter> allFilters;

  @JsonKey(defaultValue: [])
  List<Filter> topFilters;

  GetFiltersResponse({this.allFilters, this.topFilters});

  factory GetFiltersResponse.fromJson(Map<String, dynamic> json) => _$GetFiltersResponseFromJson(json);
}