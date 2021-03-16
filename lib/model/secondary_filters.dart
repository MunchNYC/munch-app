import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:munch/util/utility.dart';

part 'secondary_filters.g.dart';

enum PriceFilter {
  @JsonValue(1) ONE,
  @JsonValue(2) TWO,
  @JsonValue(3) THREE,
  @JsonValue(4) FOUR
}

enum FilterTransactionTypes {
  @JsonValue("DELIVERY") DELIVERY
}

@JsonSerializable()
class SecondaryFilters {
  @JsonKey(defaultValue: [])
  List<PriceFilter> price;

  int openTime;

  @JsonKey(defaultValue: [])
  List<FilterTransactionTypes> transactionTypes;

  Map<String, dynamic> toJson() {
    return {
      "price": _pricesToJsonList(),
      "openTime": openTime,
      "transactionTypes": transactionTypes.contains(FilterTransactionTypes.DELIVERY) ? ["DELIVERY"] : []
    };
  }

  List<int> _pricesToJsonList() {
    List<int> prices = [];

    price.forEach((price) {
      switch (price) {
        case PriceFilter.ONE:
          prices.add(1);
          break;
        case PriceFilter.TWO:
          prices.add(2);
          break;
        case PriceFilter.THREE:
          prices.add(3);
          break;
        case PriceFilter.FOUR:
          prices.add(4);
          break;
      }
    });

    return prices;
  }

  bool equals(SecondaryFilters filters) {
    return listEquals(this.price, filters.price) && this.openTime == filters.openTime && listEquals(this.transactionTypes, filters.transactionTypes);
  }

  SecondaryFilters({this.price, this.openTime, this.transactionTypes});

  factory SecondaryFilters.fromJson(Map<String, dynamic> json) => _$SecondaryFiltersFromJson(json);
}