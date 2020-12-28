import 'package:json_annotation/json_annotation.dart';
import 'package:munch/model/munch.dart';

part 'get_munches_response.g.dart';

@JsonSerializable()
class GetMunchesResponse {
  @JsonKey(defaultValue: [])
  List<Munch> undecidedMunches;

  @JsonKey(defaultValue: [])
  List<Munch> decidedMunches;

  @JsonKey(defaultValue: [])
  List<RequestedReview> requestedReviews;

  GetMunchesResponse({this.undecidedMunches, this.decidedMunches, this.requestedReviews});

  factory GetMunchesResponse.fromJson(Map<String, dynamic> json) => _$GetMunchesResponseFromJson(json);
}