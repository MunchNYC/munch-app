// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'autocomplete_responses.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$AutocompleteResponsesJsonSerializer
    implements Serializer<AutocompleteResponses> {
  Serializer<AutocompleteResponse> __autocompleteResponseJsonSerializer;
  Serializer<AutocompleteResponse> get _autocompleteResponseJsonSerializer =>
      __autocompleteResponseJsonSerializer ??=
          AutocompleteResponseJsonSerializer();
  @override
  Map<String, dynamic> toMap(AutocompleteResponses model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(
        ret,
        'autocompleteResults',
        codeIterable(
            model.autocompleteResponses,
            (val) => _autocompleteResponseJsonSerializer
                .toMap(val as AutocompleteResponse)));
    return ret;
  }

  @override
  AutocompleteResponses fromMap(Map map) {
    if (map == null) return null;
    final obj = AutocompleteResponses();
    obj.autocompleteResponses = codeIterable<AutocompleteResponse>(
        map['autocompleteResults'] as Iterable,
        (val) => _autocompleteResponseJsonSerializer.fromMap(val as Map));
    return obj;
  }
}
