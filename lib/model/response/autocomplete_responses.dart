import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:munch/model/response/autocomplete_response.dart';

part 'autocomplete_responses.jser.dart';

class AutocompleteResponses {
  @Alias('autocompleteResults')
  List<AutocompleteResponse> autocompleteResponses;

  AutocompleteResponses({this.autocompleteResponses});
}

@GenSerializer()
class AutocompleteResponsesJsonSerializer extends Serializer<AutocompleteResponses> with _$AutocompleteResponsesJsonSerializer {}