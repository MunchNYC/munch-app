import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:munch/model/coordinates.dart';
import 'package:munch/model/processors/timestamp_processor.dart';
import 'package:munch/model/user.dart';

import 'filter.dart';

part 'munch.jser.dart';

enum MunchStatus{
  UNDECIDED, DECIDED, ARCHIVED
}

class Munch{
  @Field.decode()
  String id;

  @Field.decode()
  String code;

  String name;

  // nonNullable means - put null conditions (maybe better name is @nullable, this is not logical)
  @Field.decode()
  @nonNullable
  int numberOfMembers;

  @Field.decode()
  @nonNullable
  DateTime creationTimestamp;

  Coordinates coordinates;

  @nonNullable
  int radius;

  @nonNullable
  List<User> members;

  @nonNullable
  List<Filter> blacklistFilters;

  @nonNullable
  List<Filter> whitelistFilters;

  @Field.ignore()
  MunchStatus munchStatus = MunchStatus.UNDECIDED;

  @override
  String toString() {
    return "id: $id; name: $name;";
  }

  Munch({this.name, this.coordinates, this.radius});
}

@GenSerializer(fields: const {
  // dontEncode must be specified here if we define custom processor, isNullable means that it CAN be nullable
  'creationTimestamp': const Field(processor: TimestampProcessor(), dontEncode: true, isNullable: false),
})
class MunchJsonSerializer extends Serializer<Munch> with _$MunchJsonSerializer {}