import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:munch/model/coordinates.dart';
import 'package:munch/model/processors/timestamp_processor.dart';

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

  @Field.decode()
  int numberOfMembers;

  @Field.decode()
  DateTime creationTimestamp;

  Coordinates coordinates;

  int radius;

  // nonNullable means - put null conditions (maybe better name is @nullable, this is not logical)
  @Field.ignore()
  MunchStatus munchStatus = MunchStatus.UNDECIDED;

  @override
  String toString() {
    return "id: $id; name: $name;";
  }

  Munch({this.name, this.coordinates, this.radius});
}

@GenSerializer(fields: const {
  // dontEncode must be specified here if we define custom processor
  'creationTimestamp': const Field(processor: TimestampProcessor(), dontEncode: true),
})
class MunchJsonSerializer extends Serializer<Munch> with _$MunchJsonSerializer {}