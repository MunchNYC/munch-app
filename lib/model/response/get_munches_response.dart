import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:munch/model/munch.dart';

part 'get_munches_response.jser.dart';

class GetMunchesResponse{
  List<Munch> undecidedMunches;
  List<Munch> decidedMunches;

  GetMunchesResponse({this.undecidedMunches, this.decidedMunches});
}

@GenSerializer()
class GetMunchesResponseJsonSerializer extends Serializer<GetMunchesResponse> with _$GetMunchesResponseJsonSerializer {}