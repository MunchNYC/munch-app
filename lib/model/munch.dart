import 'dart:typed_data';

import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:munch/model/coordinates.dart';
import 'package:munch/model/processors/munch_status_processor.dart';
import 'package:munch/model/processors/timestamp_processor.dart';
import 'package:munch/model/restaurant.dart';
import 'package:munch/model/user.dart';
import 'package:munch/repository/user_repository.dart';

import 'filter.dart';

part 'munch.jser.dart';

enum MunchStatus{
  UNDECIDED, DECIDED, ARCHIVED
}

class Munch{
  static const String CODE_PREFIX = "Munch.app/";

  @Field.decode()
  String id;

  @Field.decode()
  String code;

  String name;

  // isNullable means - put null conditions (maybe better name is @nullable, this is not logical)
  @Field.decode(isNullable: false, alias: 'host') // if Field.decode is defined alias must be defined inside it
  String hostUserId;

  @Field.decode(isNullable: false)
  int numberOfMembers;

  // special processor
  DateTime creationTimestamp;

  Coordinates coordinates;

  @Field.encode()
  int radius;

  @Field.decode(isNullable: false)
  List<User> members;

  @Field.decode(isNullable: false, alias: 'blacklistFilters')
  List<String> blacklistFiltersKeys;

  @Field.decode(isNullable: false, alias: 'whitelistFilters')
  List<String> whitelistFiltersKeys;

  // will be fetched totally in detailed munch
  @Field.decode(isNullable: false)
  Restaurant matchedRestaurant;

  // will be get for compact munches list
  @Field.decode(isNullable: false)
  String matchedRestaurantName;

  @Field.decode(isNullable: false)
  bool receivePushNotifications;

  // special processor, alias specified there
  MunchStatus munchStatus;

  @Field.ignore()
  String get link => CODE_PREFIX + code;

  // lastMunchData - last fetched munch data from back-end
  // called with instance of detailed munch
  void merge(Munch lastMunchData){
    // if members array is empty take data from oldMunch if exists
    if(members.length == 0){
      // If last fetched munch data has null members or empty members array, put current user in that array it's better than to have 0 members on view
      members = (lastMunchData.members != null || lastMunchData.members.length > 0) ? lastMunchData.members : [UserRepo.getInstance().currentUser];
    }

    numberOfMembers = members.length;

    radius = lastMunchData.radius;

    // oldMunch.creationTimestamp can be null, if we hadn't fetched compact munch before
    creationTimestamp = lastMunchData.creationTimestamp;
  }

  @override
  String toString() {
    return "id: $id; name: $name;";
  }

  Munch({this.name, this.coordinates, this.radius});
}

@GenSerializer(fields: const {
  // dontEncode must be specified here if we define custom processor, isNullable means that it CAN be nullable
  'creationTimestamp': const Field(processor: TimestampProcessor(), dontEncode: true, isNullable: false),
  'munchStatus': const Field(processor: MunchStatusProcessor(), dontEncode: true, decodeFrom: 'state')
})
class MunchJsonSerializer extends Serializer<Munch> with _$MunchJsonSerializer {}