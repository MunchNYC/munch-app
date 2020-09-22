import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'filter.jser.dart';

class Filter{
  String alias;

  String title;

  @override
  String toString() {
    return "alias: $alias; title: $title";
  }

  Filter({this.alias, this.title});
}

@GenSerializer()
class FilterJsonSerializer extends Serializer<Filter> with _$FilterJsonSerializer {}