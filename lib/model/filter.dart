import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'filter.jser.dart';

enum FilterStatus { BLACKLISTED, NEUTRAL, WHITELISTED }

class Filter {
  String key;

  String label;

  @Field.ignore()
  FilterStatus filterStatus;

  @override
  String toString() {
    return "key: $key; label: $label";
  }

  Filter({this.key, this.label, this.filterStatus});

  Filter cloneWithStatus(FilterStatus filterStatus) {
    return Filter(key: key, label: label, filterStatus: filterStatus);
  }
}

@GenSerializer()
class FilterJsonSerializer extends Serializer<Filter> with _$FilterJsonSerializer {}
