// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_munches_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetMunchesResponse _$GetMunchesResponseFromJson(Map<String, dynamic> json) {
  return GetMunchesResponse(
    undecidedMunches: (json['undecidedMunches'] as List)
            ?.map((e) =>
                e == null ? null : Munch.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    decidedMunches: (json['decidedMunches'] as List)
            ?.map((e) =>
                e == null ? null : Munch.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    requestedReviews: (json['requestedReviews'] as List)
            ?.map((e) => e == null
                ? null
                : RequestedReview.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$GetMunchesResponseToJson(GetMunchesResponse instance) =>
    <String, dynamic>{
      'undecidedMunches': instance.undecidedMunches,
      'decidedMunches': instance.decidedMunches,
      'requestedReviews': instance.requestedReviews,
    };
