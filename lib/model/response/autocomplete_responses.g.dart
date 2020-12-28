// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'autocomplete_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutocompleteResponses _$AutocompleteResponsesFromJson(
    Map<String, dynamic> json) {
  return AutocompleteResponses(
    autocompleteResponses: (json['autocompleteResults'] as List)
        ?.map((e) => e == null
            ? null
            : AutocompleteResponse.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$AutocompleteResponsesToJson(
        AutocompleteResponses instance) =>
    <String, dynamic>{
      'autocompleteResults': instance.autocompleteResponses,
    };
