// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_filters_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetFiltersResponse _$GetFiltersResponseFromJson(Map<String, dynamic> json) {
  return GetFiltersResponse(
    allFilters: (json['allFilters'] as List)
            ?.map((e) =>
                e == null ? null : Filter.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    topFilters: (json['topFilters'] as List)
            ?.map((e) =>
                e == null ? null : Filter.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$GetFiltersResponseToJson(GetFiltersResponse instance) =>
    <String, dynamic>{
      'allFilters': instance.allFilters,
      'topFilters': instance.topFilters,
    };
