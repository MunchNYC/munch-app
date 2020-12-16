// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_filters_response.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$GetFiltersResponseJsonSerializer implements Serializer<GetFiltersResponse> {
  Serializer<Filter> __filterJsonSerializer;

  Serializer<Filter> get _filterJsonSerializer => __filterJsonSerializer ??= FilterJsonSerializer();

  @override
  Map<String, dynamic> toMap(GetFiltersResponse model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'allFilters', codeIterable(model.allFilters, (val) => _filterJsonSerializer.toMap(val as Filter)));
    setMapValue(ret, 'topFilters', codeIterable(model.topFilters, (val) => _filterJsonSerializer.toMap(val as Filter)));
    return ret;
  }

  @override
  GetFiltersResponse fromMap(Map map) {
    if (map == null) return null;
    final obj = GetFiltersResponse();
    obj.allFilters =
        codeIterable<Filter>(map['allFilters'] as Iterable, (val) => _filterJsonSerializer.fromMap(val as Map));
    obj.topFilters =
        codeIterable<Filter>(map['topFilters'] as Iterable, (val) => _filterJsonSerializer.fromMap(val as Map));
    return obj;
  }
}
