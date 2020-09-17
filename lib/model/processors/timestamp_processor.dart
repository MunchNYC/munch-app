import 'package:jaguar_serializer/jaguar_serializer.dart';

// UNIX TIMESTAMP/DATETIME CONVERTER
class TimestampProcessor implements FieldProcessor<DateTime, int> {
  const TimestampProcessor();

  @override
  DateTime deserialize(int value) {
    if(value == null) return null;

    return DateTime.fromMicrosecondsSinceEpoch(value * 1000);
  }

  @override
  int serialize(DateTime value) {
    return value.toUtc().millisecondsSinceEpoch;
  }
}