import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:munch/model/munch.dart';

class MunchStatusProcessor implements FieldProcessor<MunchStatus, String> {
  const MunchStatusProcessor();

  @override
  MunchStatus deserialize(String value) {
    if (value == null) return null;

    // munchStatus.toString() returns MunchStatus.DECIDED for example
    return MunchStatus.values.firstWhere((munchStatus) =>
        (munchStatus.toString().split(".").last).toUpperCase() ==
        value.toUpperCase());
  }

  @override
  String serialize(MunchStatus value) {
    return (value.toString().split(".").last).toUpperCase();
  }
}
