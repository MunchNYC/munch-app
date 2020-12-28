// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'autocomplete_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutocompleteResponse _$AutocompleteResponseFromJson(Map<String, dynamic> json) {
  return AutocompleteResponse(
    placeId: json['placeId'] as String,
    displayString: json['displayString'] as String,
  );
}

Map<String, dynamic> _$AutocompleteResponseToJson(
        AutocompleteResponse instance) =>
    <String, dynamic>{
      'placeId': instance.placeId,
      'displayString': instance.displayString,
    };
