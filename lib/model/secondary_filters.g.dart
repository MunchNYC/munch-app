// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secondary_filters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SecondaryFilters _$SecondaryFiltersFromJson(Map<String, dynamic> json) {
  return SecondaryFilters(
    price: (json['price'] as List)
            ?.map((e) => _$enumDecodeNullable(_$PriceFilterEnumMap, e))
            ?.toList() ??
        [],
    openTime: json['openTime'] as int,
    transactionTypes: (json['transactionTypes'] as List)
            ?.map(
                (e) => _$enumDecodeNullable(_$FilterTransactionTypesEnumMap, e))
            ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$SecondaryFiltersToJson(SecondaryFilters instance) =>
    <String, dynamic>{
      'price': instance.price?.map((e) => _$PriceFilterEnumMap[e])?.toList(),
      'openTime': instance.openTime,
      'transactionTypes': instance.transactionTypes
          ?.map((e) => _$FilterTransactionTypesEnumMap[e])
          ?.toList(),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$PriceFilterEnumMap = {
  PriceFilter.ONE: 1,
  PriceFilter.TWO: 2,
  PriceFilter.THREE: 3,
  PriceFilter.FOUR: 4,
};

const _$FilterTransactionTypesEnumMap = {
  FilterTransactionTypes.DELIVERY: 'DELIVERY',
};
