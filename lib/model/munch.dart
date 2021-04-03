import 'package:json_annotation/json_annotation.dart';
import 'package:munch/config/app_config.dart';
import 'package:munch/model/coordinates.dart';
import 'package:munch/model/restaurant.dart';
import 'package:munch/model/secondary_filters.dart';
import 'package:munch/model/user.dart';
import 'package:munch/repository/user_repository.dart';
import 'package:munch/util/deep_link_handler.dart';

part 'munch.g.dart';

enum MunchStatus {
  @JsonValue("UNDECIDED") UNDECIDED,
  @JsonValue("DECIDED") DECIDED,
  @JsonValue("UNMODIFIABLE") UNMODIFIABLE,
  @JsonValue("HISTORICAL") HISTORICAL
}

enum MunchReviewValue { LIKED, DISLIKED, NEUTRAL, NOSHOW, SKIPPED }

@JsonSerializable()
class Munch {
  String id;
  String code;
  String name;

  @JsonKey(name: 'host')
  String hostUserId;

  int numberOfMembers;

  @JsonKey(fromJson: _dateTimeFromEpochUs, toJson: _dateTimeToEpochUs)
  DateTime creationTimestamp;

  @JsonKey(nullable: false)
  Coordinates coordinates;

  int radius;

  String imageUrl;

  List<User> members;

  MunchMemberFilters munchMemberFilters;

  MunchFilters munchFilters;

  @JsonKey(name: "searchPreferences")
  SecondaryFilters secondaryFilters;

  // will be fetched totally in detailed munch
  Restaurant matchedRestaurant;

  // will be get for compact munches list
  String matchedRestaurantName;

  @JsonKey(defaultValue: false)
  bool receivePushNotifications;

  @JsonKey(name: "updateSearchPreferencesFailed", defaultValue: false)
  bool updateSecondaryFiltersFailed;

  @JsonKey(name: "state", nullable: false, unknownEnumValue: MunchStatus.HISTORICAL)
  MunchStatus munchStatus;

  // used for cache, in the future we can move it to cache custom implementation, but for now is here
  @JsonKey(ignore: true)
  DateTime lastUpdatedUTC;

  @JsonKey(ignore: true)
  bool munchStatusChanged = false;

  @JsonKey(ignore: true)
  String get joinLink => AppConfig.getInstance().deepLinkUrl + DeepLinkRouter.JOIN_ROUTE_PATH + "/" + code;

  @JsonKey(ignore: true)
  bool get isModifiable => munchStatus != MunchStatus.UNMODIFIABLE && munchStatus != MunchStatus.HISTORICAL;

  int getNumberOfMembers() {
    return numberOfMembers ?? members.length;
  }

  User getMunchMember(String userId) {
    User user = members.firstWhere((User user) {
      return user.uid == userId;
    }, orElse: () {
      return null;
    });

    return user;
  }

  // detailedMunch - new munch fetched
  // called with instance of current munch
  void merge(Munch detailedMunch) {
    this.name = detailedMunch.name;
    this.code = detailedMunch.code;
    this.hostUserId = detailedMunch.hostUserId;
    this.creationTimestamp = detailedMunch.creationTimestamp;
    this.coordinates = detailedMunch.coordinates;
    this.munchMemberFilters = detailedMunch.munchMemberFilters;
    this.munchFilters = detailedMunch.munchFilters;
    this.matchedRestaurant = detailedMunch.matchedRestaurant;
    this.receivePushNotifications = detailedMunch.receivePushNotifications;
    this.radius = detailedMunch.radius;
    this.imageUrl = detailedMunch.imageUrl;

    if (detailedMunch.members != null && detailedMunch.members.length > 0) {
      this.members = detailedMunch.members;
      this.numberOfMembers = detailedMunch.members.length;
    }

    // if members array is empty take data from current munch if exists
    if ((detailedMunch.members == null || detailedMunch.members.length == 0) &&
        (this.members == null || this.members.length == 0)) {
      // If current munch data has null members or empty members array, put current user in that array it's better than to have 0 members on view
      this.members = [UserRepo.getInstance().currentUser];
      this.numberOfMembers = this.numberOfMembers ?? 1;
    }

    if (detailedMunch.matchedRestaurant != null) {
      this.matchedRestaurantName = detailedMunch.matchedRestaurant.name;
    } else {
      this.matchedRestaurantName = null;
    }

    // Otherwise keep last value of munchStatusChanged, before it is reverted to false on swipe or decision screen
    if (this.munchStatus != detailedMunch.munchStatus) {
      this.munchStatusChanged = true;
    }

    if (detailedMunch.secondaryFilters != null) {
      this.secondaryFilters = detailedMunch.secondaryFilters;
    }

    this.munchStatus = detailedMunch.munchStatus;
  }

  @override
  String toString() {
    return "id: $id; name: $name;";
  }

  static DateTime _dateTimeFromEpochUs(int us) => DateTime.fromMillisecondsSinceEpoch(us);

  static int _dateTimeToEpochUs(DateTime dateTime) => dateTime?.millisecondsSinceEpoch;

  // static Map<String, dynamic> _coordinatesToJson(Coordinates coordinates) => _$CoordinatesToJson();

  Munch({this.id, this.name, this.receivePushNotifications, this.coordinates, this.radius});

  factory Munch.fromJson(Map<String, dynamic> json) => _$MunchFromJson(json);

  Map<String, dynamic> toJson() => _$MunchToJson(this);
}

@JsonSerializable()
class MunchMemberFilters {
  @JsonKey(name: 'whitelist', defaultValue: [])
  List<String> whitelistFiltersKeys;

  @JsonKey(name: 'blacklist', defaultValue: [])
  List<String> blacklistFiltersKeys;

  MunchMemberFilters({this.whitelistFiltersKeys, this.blacklistFiltersKeys});

  factory MunchMemberFilters.fromJson(Map<String, dynamic> json) => _$MunchMemberFiltersFromJson(json);
}

@JsonSerializable()
class MunchFilters {
  @JsonKey(defaultValue: [])
  List<MunchGroupFilter> blacklist;

  @JsonKey(defaultValue: [])
  List<MunchGroupFilter> whitelist;

  MunchFilters({this.blacklist, this.whitelist});

  factory MunchFilters.fromJson(Map<String, dynamic> json) => _$MunchFiltersFromJson(json);
}

@JsonSerializable()
class MunchGroupFilter {
  String key;

  @JsonKey(defaultValue: [])
  List<String> userIds;

  MunchGroupFilter({this.key, this.userIds});

  factory MunchGroupFilter.fromJson(Map<String, dynamic> json) => _$MunchGroupFilterFromJson(json);
}

@JsonSerializable()
class RequestedReview {
  String munchId;
  String imageUrl;

  RequestedReview({this.munchId, this.imageUrl});

  factory RequestedReview.fromJson(Map<String, dynamic> json) => _$RequestedReviewFromJson(json);
}