import 'package:json_annotation/json_annotation.dart';

part 'autocomplete_response.g.dart';

@JsonSerializable()
class AutocompleteResponse {
  String placeId;
  String displayString;

  AutocompleteResponse({this.placeId, this.displayString});

  factory AutocompleteResponse.fromJson(Map<String, dynamic> json) => _$AutocompleteResponseFromJson(json);
}