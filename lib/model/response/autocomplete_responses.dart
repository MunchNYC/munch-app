import 'package:json_annotation/json_annotation.dart';
import 'package:munch/model/response/autocomplete_response.dart';

part 'autocomplete_responses.g.dart';

@JsonSerializable()
class AutocompleteResponses {
  @JsonKey(name: 'autocompleteResults')
  List<AutocompleteResponse> autocompleteResponses;

  AutocompleteResponses({this.autocompleteResponses});

  factory AutocompleteResponses.fromJson(Map<String, dynamic> json) => _$AutocompleteResponsesFromJson(json);
}