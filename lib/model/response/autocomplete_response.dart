import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'autocomplete_response.jser.dart';

class AutocompleteResponse {
  String placeId;
  String displayString;

  AutocompleteResponse({this.placeId, this.displayString});
}

@GenSerializer()
class AutocompleteResponseJsonSerializer extends Serializer<AutocompleteResponse> with _$AutocompleteResponseJsonSerializer {}