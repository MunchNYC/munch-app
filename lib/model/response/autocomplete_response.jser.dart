// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'autocomplete_response.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$AutocompleteResponseJsonSerializer
    implements Serializer<AutocompleteResponse> {
  @override
  Map<String, dynamic> toMap(AutocompleteResponse model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'placeId', model.placeId);
    setMapValue(ret, 'displayString', model.displayString);
    return ret;
  }

  @override
  AutocompleteResponse fromMap(Map map) {
    if (map == null) return null;
    final obj = AutocompleteResponse();
    obj.placeId = map['placeId'] as String;
    obj.displayString = map['displayString'] as String;
    return obj;
  }
}
