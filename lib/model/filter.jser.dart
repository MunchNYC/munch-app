// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$FilterJsonSerializer implements Serializer<Filter> {
  @override
  Map<String, dynamic> toMap(Filter model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'alias', model.alias);
    setMapValue(ret, 'title', model.title);
    return ret;
  }

  @override
  Filter fromMap(Map map) {
    if (map == null) return null;
    final obj = Filter();
    obj.alias = map['alias'] as String;
    obj.title = map['title'] as String;
    return obj;
  }
}
