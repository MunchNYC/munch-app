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

  @Field.decode(isNullable: false)
  MunchMemberFilters munchMemberFilters;

  @Field.decode(isNullable: false)
  MunchFilters munchFilters;

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
  bool munchStatusChanged = false;

  @Field.ignore()
  String get link => CODE_PREFIX + code;

  User getMunchMember(String userId){
    User user = members.firstWhere((User user){
      return user.uid == userId;
    }, orElse: (){
      return null;
    });

    return user;
  }

  // detailedMunch - new munch fetched
  // called with instance of current munch
  void merge(Munch detailedMunch){
    this.name = detailedMunch.name;
    this.code = detailedMunch.code;
    this.hostUserId = detailedMunch.hostUserId;
    this.creationTimestamp = detailedMunch.creationTimestamp;
    this.coordinates = detailedMunch.coordinates;
    this.munchMemberFilters = detailedMunch.munchMemberFilters;
    this.munchFilters = detailedMunch.munchFilters;
    this.matchedRestaurant = detailedMunch.matchedRestaurant;
    this.receivePushNotifications = detailedMunch.receivePushNotifications;

    // if members array is empty take data from current munch if exists
    if((detailedMunch.members == null || detailedMunch.members.length == 0) && (this.members == null || this.members.length == 0)){
      // If current munch data has null members or empty members array, put current user in that array it's better than to have 0 members on view
      this.members = [UserRepo.getInstance().currentUser];
      this.numberOfMembers = 1;
    }

    if(detailedMunch.matchedRestaurant != null){
      this.matchedRestaurantName = detailedMunch.matchedRestaurant.name;
    } else{
      this.matchedRestaurantName = null;
    }

    if(this.munchStatus != detailedMunch.munchStatus){
      this.munchStatusChanged = true;
    }

    this.munchStatus = detailedMunch.munchStatus;
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

class MunchMemberFilters{
  @Alias('whitelist')
  List<String> whitelistFiltersKeys;

  @Alias('blacklist')
  List<String> blacklistFiltersKeys;
}

@GenSerializer()
class MunchMemberFiltersJsonSerializer extends Serializer<MunchMemberFilters> with _$MunchMemberFiltersJsonSerializer {}

class MunchFilters{
  List<MunchGroupFilter> blacklist;

  List<MunchGroupFilter> whitelist;
}

@GenSerializer()
class MunchFiltersJsonSerializer extends Serializer<MunchFilters> with _$MunchFiltersJsonSerializer {}

class MunchGroupFilter{
  String key;

  List<String> userIds;
}

@GenSerializer()
class MunchGroupFilterJsonSerializer extends Serializer<MunchGroupFilter> with _$MunchGroupFilterJsonSerializer {}


