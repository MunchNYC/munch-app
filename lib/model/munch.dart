import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:munch/model/processors/timestamp_processor.dart';

part 'munch.jser.dart';

enum MunchStatus{
  UNDECIDED, DECIDED, ARCHIVED
}

class Munch{
  String id;

  String code;

  String name;

  int numberOfMembers;

  DateTime creationTimestamp;

  // nonNullable means - put null conditions (maybe better name is @nullable, this is not logical)
  @Field.ignore()
  MunchStatus munchStatus = MunchStatus.UNDECIDED;

  @override
  String toString() {
    return "id: $id; name: $name;";
  }

  Munch({this.id, this.code, this.name, this.numberOfMembers, this.creationTimestamp});
}

@GenSerializer(fields: const {
  'creationTimestamp': const EnDecode(processor: TimestampProcessor()),
})
class MunchJsonSerializer extends Serializer<Munch> with _$MunchJsonSerializer {}