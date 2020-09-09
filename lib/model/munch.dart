import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:munch/model/processors/TimestampProcessor.dart';

part 'munch.jser.dart';

// MOCK-UP
enum MunchState{
  DECIDING, DECIDED, ARCHIVED
}

class Munch{
  String id;

  String code;

  String name;

  MunchState state;

  int numberOfMembers;

  DateTime creationTimestamp;

  @override
  String toString() {
    return "id: $id; name: $name;";
  }

  Munch({this.id, this.code, this.name, this.state, this.numberOfMembers, this.creationTimestamp});
}

@GenSerializer(fields: const {
  'creationTimestamp': const EnDecode(processor: TimestampProcessor()),
})
class MunchJsonSerializer extends Serializer<Munch> with _$MunchJsonSerializer {}