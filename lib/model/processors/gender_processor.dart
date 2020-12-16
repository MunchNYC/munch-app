import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:munch/model/user.dart';

class GenderProcessor implements FieldProcessor<Gender, String> {
  const GenderProcessor();

  @override
  Gender deserialize(String value) {
    if (value == null) return null;
    return Gender.values
        .firstWhere((gender) => (gender.toString().split(".").last.toUpperCase() == value.toUpperCase()));
  }

  @override
  String serialize(Gender value) {
    return (value.toString());
  }
}
