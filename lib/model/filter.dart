import 'package:json_annotation/json_annotation.dart';

part 'filter.g.dart';

enum FilterStatus { BLACKLISTED, NEUTRAL, WHITELISTED }

@JsonSerializable()
class Filter {
  String key;

  String label;

  @JsonKey(ignore: true)
  FilterStatus filterStatus;

  @override
  String toString() {
    return "key: $key; label: $label";
  }

  Filter({this.key, this.label, this.filterStatus});

  Filter cloneWithStatus(FilterStatus filterStatus) {
    return Filter(key: key, label: label, filterStatus: filterStatus);
  }

  factory Filter.fromJson(Map<String, dynamic> json) => _$FilterFromJson(json);
}