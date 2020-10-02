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
    setMapValue(ret, 'key', model.key);
    setMapValue(ret, 'label', model.label);
    return ret;
  }

  @override
  Filter fromMap(Map map) {
    if (map == null) return null;
    final obj = Filter();
    obj.key = map['key'] as String;
    obj.label = map['label'] as String;
    return obj;
  }
}
