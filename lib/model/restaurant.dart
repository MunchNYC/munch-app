import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:munch/model/coordinates.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/utility.dart';
import 'package:timezone/timezone.dart' as tz;

part 'restaurant.g.dart';

@JsonSerializable()
class Restaurant {
  @JsonKey(nullable: false)
  String id;

  @JsonKey(nullable: false)
  String name;

  @JsonKey(defaultValue: [])
  List<RestaurantCategory> categories;

  @JsonKey(name: 'hours', defaultValue: [])
  List<WorkingHours> workingHours;

  @JsonKey(nullable: false)
  Coordinates coordinates;

  @JsonKey(nullable: false)
  String city;

  @JsonKey(nullable: false)
  String state;

  @JsonKey(nullable: false)
  String country;

  @JsonKey(nullable: false)
  String address;

  @JsonKey(nullable: false)
  String zipCode;

  String phoneNumber;

  @JsonKey(name: 'price')
  String priceSymbol;

  @JsonKey(nullable: false)
  double rating;

  @JsonKey(name: 'photos', defaultValue: [])
  List<String> photoUrls;

  @JsonKey(name: 'reviewCount', nullable: false)
  int reviewsNumber;

  @JsonKey(nullable: false)
  String timezone;

  @JsonKey(nullable: false)
  String url;

  @JsonKey(defaultValue: [])
  List<String> usersWhoLiked;

  @JsonKey(ignore: true)
  String get categoryTitles =>
      categories.map((RestaurantCategory restaurantCategory) => restaurantCategory.title).join(", ");

  tz.TZDateTime currentTimeInRestaurantTimeZone() {
    tz.Location location = tz.getLocation(timezone);

    tz.TZDateTime nowInRestaurantTimezone = tz.TZDateTime.parse(location, DateTime.now().toString());

    return nowInRestaurantTimezone;
  }

  WorkingHours getDayWorkingHours([tz.TZDateTime nowInRestaurantTimezone]) {
    if (nowInRestaurantTimezone == null) {
      nowInRestaurantTimezone = currentTimeInRestaurantTimeZone();
    }

    String currentDayOfWeek = DateFormat('EEEE').format(nowInRestaurantTimezone);

    WorkingHours dayWorkingHours = workingHours.firstWhere(
        (WorkingHours workingHours) => workingHours.dayOfWeek.toLowerCase() == currentDayOfWeek.toLowerCase(),
        orElse: () => null);

    return dayWorkingHours;
  }

  Map<String, dynamic> getCurrentWorkingDayStatus(tz.TZDateTime nowInRestaurantTimezone) {
    String currentStatus = App.translate("restaurant_swipe_screen.restaurant_card.working_hours.closed.text");
    bool isClosed = true;

    int currentTimeOfDayValue = nowInRestaurantTimezone.hour * 60 + nowInRestaurantTimezone.minute;

    WorkingHours dayWorkingHours = getDayWorkingHours(nowInRestaurantTimezone);

    for (int i = 0; i < dayWorkingHours.workingTimes.length; i++) {
      WorkingTimes workingTimes = dayWorkingHours.workingTimes[i];

      // date must be set with DateFormat("y-M-d").format(nowInRestaurantTimezone) otherwise DateFormat will return 01:25 AM -> 12:25 AM because date is converted to 1970-01-01 by default and time is changed sometimes in a year
      String openTime12HourFormat = DateFormat("y-M-d").format(nowInRestaurantTimezone) + " " + workingTimes.open;
      String closedTime12HourFormat = DateFormat("y-M-d").format(nowInRestaurantTimezone) + " " + workingTimes.closed;

      TimeOfDay openTime = TimeOfDay.fromDateTime(DateFormat('y-M-d hh:mm aa').parse(openTime12HourFormat));
      TimeOfDay closedTime = TimeOfDay.fromDateTime(DateFormat('y-M-d hh:mm aa').parse(closedTime12HourFormat));

      int openTimeValue = openTime.hour * 60 + openTime.minute;
      int closedTimeValue = closedTime.hour * 60 + closedTime.minute;

      if (closedTimeValue <= openTimeValue) {
        // if it's closed after midnight
        closedTimeValue = 24 * 60 + closedTimeValue;
      }

      if (currentTimeOfDayValue < openTimeValue) {
        if (i == 0) {
          currentStatus = App.translate("restaurant_swipe_screen.restaurant_card.working_hours.opens.text") +
              " " +
              (!App.use24HoursFormat ? workingTimes.open : Utility.convertTo24HourFormat(openTime12HourFormat));
        } else {
          currentStatus = App.translate("restaurant_swipe_screen.restaurant_card.working_hours.re-opens.text") +
              " " +
              (!App.use24HoursFormat ? workingTimes.open : Utility.convertTo24HourFormat(openTime12HourFormat));
        }

        break;
      } else if (currentTimeOfDayValue >= openTimeValue && currentTimeOfDayValue <= closedTimeValue) {
        currentStatus = App.translate("restaurant_swipe_screen.restaurant_card.working_hours.open_until.text") +
            " " +
            (!App.use24HoursFormat ? workingTimes.closed : Utility.convertTo24HourFormat(closedTime12HourFormat));

        isClosed = false;

        break;
      }
    }

    return Map.of({"isClosed": isClosed, "status": currentStatus});
  }

  Map<String, dynamic> getPreviousWorkingDayLastStatus(tz.TZDateTime nowInRestaurantTimezone) {
    String currentStatus = App.translate("restaurant_swipe_screen.restaurant_card.working_hours.closed.text");
    bool isClosed = true;

    int currentTimeOfDayValue = nowInRestaurantTimezone.hour * 60 + nowInRestaurantTimezone.minute;

    WorkingHours previousDayWorkingHours = getDayWorkingHours(nowInRestaurantTimezone.subtract(Duration(days: 1)));

    if (previousDayWorkingHours.workingTimes.length > 0) {
      WorkingTimes lastWorkingTimesElement = previousDayWorkingHours.workingTimes.last;

      // date must be set with DateFormat("y-M-d").format(nowInRestaurantTimezone) otherwise DateFormat will return 01:25 AM -> 12:25 AM because date is converted to 1970-01-01 by default and time is changed sometimes in a year
      String previousDayLastOpenTime12HourFormat =
          DateFormat("y-M-d").format(nowInRestaurantTimezone) + " " + lastWorkingTimesElement.open;
      String previousDayLastClosedTime24HourFormat =
          DateFormat("y-M-d").format(nowInRestaurantTimezone) + " " + lastWorkingTimesElement.closed;

      TimeOfDay previousDayLastOpenTime =
          TimeOfDay.fromDateTime(DateFormat('y-M-d hh:mm aa').parse(previousDayLastOpenTime12HourFormat));
      TimeOfDay previousDayLastClosedTime =
          TimeOfDay.fromDateTime(DateFormat('y-M-d hh:mm aa').parse(previousDayLastClosedTime24HourFormat));

      int previousDayLastOpenTimeValue = previousDayLastOpenTime.hour * 60 + previousDayLastOpenTime.minute;
      int previousDayLastClosedTimeValue = previousDayLastClosedTime.hour * 60 + previousDayLastClosedTime.minute;

      if (previousDayLastClosedTimeValue <= previousDayLastOpenTimeValue) {
        // if it's closed after midnight
        if (currentTimeOfDayValue < previousDayLastClosedTimeValue) {
          currentStatus = App.translate("restaurant_swipe_screen.restaurant_card.working_hours.open_until.text") +
              " " +
              (!App.use24HoursFormat
                  ? lastWorkingTimesElement.closed
                  : Utility.convertTo24HourFormat(previousDayLastClosedTime24HourFormat));

          isClosed = false;
        }
      }
    }

    return Map.of({"isClosed": isClosed, "status": currentStatus});
  }

  String getWorkingHoursCurrentStatus() {
    tz.TZDateTime nowInRestaurantTimezone = currentTimeInRestaurantTimeZone();

    Map<String, dynamic> currentStatusMap = getCurrentWorkingDayStatus(nowInRestaurantTimezone);

    String currentStatus = currentStatusMap["status"];

    if (currentStatusMap["isClosed"]) {
      // check day before
      currentStatusMap = getPreviousWorkingDayLastStatus(nowInRestaurantTimezone);

      // otherwise keep status from current day
      if (!currentStatusMap["isClosed"]) {
        currentStatus = currentStatusMap["status"];
      }
    }

    return currentStatus;
  }

  @override
  String toString() {
    return "id: $id; name: $name;";
  }

  Restaurant(
      {this.id,
      this.name,
      this.categories,
      this.workingHours,
      this.coordinates,
      this.city,
      this.state,
      this.country,
      this.address,
      this.zipCode,
      this.phoneNumber,
      this.priceSymbol,
      this.rating,
      this.photoUrls,
      this.reviewsNumber,
      this.timezone,
      this.url,
      this.usersWhoLiked});

  factory Restaurant.fromJson(Map<String, dynamic> json) => _$RestaurantFromJson(json);
}


@JsonSerializable()
class RestaurantCategory { // Better name for this is just "Category" but it will have conflict with Flutter class
  String alias;

  String title;

  @override
  String toString() {
    return "alias: $alias; title: $title";
  }

  RestaurantCategory({this.alias, this.title});

  factory RestaurantCategory.fromJson(Map<String, dynamic> json) => _$RestaurantCategoryFromJson(json);
}

@JsonSerializable()
class WorkingHours {
  @JsonKey(nullable: false)
  String dayOfWeek;

  @JsonKey(name: 'times', defaultValue: [])
  List<WorkingTimes> workingTimes;

  String getWorkingTimesFormatted() {
    if (workingTimes.isEmpty) {
      return App.translate("restaurant.working_hours.closed.text");
    }

    List<String> workingTimesStringList = List<String>();

    DateTime now = DateTime.now();

    for (WorkingTimes wt in workingTimes) {
      // date must be set with DateFormat("y-M-d").format(nowInRestaurantTimezone) otherwise DateFormat will return 01:25 AM -> 12:25 AM because date is converted to 1970-01-01 by default and time is changed sometimes in a year
      String openTime12HourFormat = DateFormat("y-M-d").format(now) + " " + wt.open;
      String closedTime12HourFormat = DateFormat("y-M-d").format(now) + " " + wt.closed;

      String openText = !App.use24HoursFormat ? wt.open : Utility.convertTo24HourFormat(openTime12HourFormat);
      String closedText = !App.use24HoursFormat ? wt.closed : Utility.convertTo24HourFormat(closedTime12HourFormat);

      workingTimesStringList.add(openText + " - " + closedText);
    }

    return workingTimesStringList.join(", ");
  }

  WorkingHours({this.dayOfWeek, this.workingTimes});

  factory WorkingHours.fromJson(Map<String, dynamic> json) => _$WorkingHoursFromJson(json);
}

@JsonSerializable()
class WorkingTimes {
  String open;

  String closed;

  WorkingTimes({this.open, this.closed});

  factory WorkingTimes.fromJson(Map<String, dynamic> json) => _$WorkingTimesFromJson(json);
}

