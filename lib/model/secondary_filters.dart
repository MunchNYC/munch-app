import 'package:json_annotation/json_annotation.dart';

part 'secondary_filters.g.dart';

enum PriceFilter {
  @JsonValue(1) ONE,
  @JsonValue(2) TWO,
  @JsonValue(3) THREE,
  @JsonValue(4) FOUR
}

@JsonSerializable()
class SecondaryFilters {
  List<PriceFilter> price;

  int openTime;

  List<String> transactionTypes;

  SecondaryFilters({this.price, this.openTime, this.transactionTypes});

  factory SecondaryFilters.fromJson(Map<String, dynamic> json) => _$SecondaryFiltersFromJson(json);
}