import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:munch/model/coordinates.dart';
import 'package:munch/util/app.dart';
import 'package:timezone/timezone.dart' as tz;

part 'restaurant.jser.dart';

class Restaurant{
  String id;

  String name;

  List<RestaurantCategory> categories;

  @Alias('hours')
  List<WorkingHours> workingHours;

  Coordinates coordinates;

  String city;

  String state;

  String country;

  String address;

  String zipCode;

  String phoneNumber;

  @Alias('price')
  String priceSymbol;

  double rating;

  @Alias('photos')
  List<String> photoUrls;

  @Alias('reviewCount')
  int reviewsNumber;

  String timezone;

  String url;

  @Field.ignore()
  String get categoryTitles => categories.map((RestaurantCategory restaurantCategory) => restaurantCategory.title).join(", ");

  String getWorkingHoursCurrentStatus(){
    tz.Location location = tz.getLocation(timezone);

    tz.TZDateTime nowWithTimezone = tz.TZDateTime.parse(location, DateTime.now().toString());

    String currentDayOfWeek =  DateFormat('EEEE').format(nowWithTimezone);

    WorkingHours dayWorkingHours = workingHours.where((WorkingHours workingHours) => workingHours.dayOfWeek.toLowerCase() == currentDayOfWeek.toLowerCase()).first;

    TimeOfDay currentTimeOfDay = TimeOfDay.now();

    int currentTimeOfDayValue = currentTimeOfDay.hour * 60 + currentTimeOfDay.minute;

    String currentStatus = App.translate("restaurant_swipe_screen.restaurant_card.working_hours.closed.text");

    for(int i = 0; i < dayWorkingHours.workingTimes.length; i++){
      WorkingTimes workingTimes = dayWorkingHours.workingTimes[i];

      // date must be hardcoded otherwise DateFormat will return 01:25 AM -> 12:25 AM because date is converted to 1970-01-01 by default and time is changed
      TimeOfDay openTime = TimeOfDay.fromDateTime(DateFormat('y-M-d hh:mm aa').parse("2020-01-01 " + workingTimes.open));
      TimeOfDay closeTime = TimeOfDay.fromDateTime(DateFormat('y-M-d hh:mm aa').parse("2020-01-01 " + workingTimes.closed));

      int openTimeValue = openTime.hour * 60 + openTime.minute;
      int closeTimeValue = closeTime.hour * 60 + closeTime.minute;

      if(currentTimeOfDayValue < openTimeValue){
        if(i == 0){
          currentStatus = App.translate("restaurant_swipe_screen.restaurant_card.working_hours.opens.text") + " " + workingTimes.open;
        } else{
          currentStatus = App.translate("restaurant_swipe_screen.restaurant_card.working_hours.re-opens.text") + " " + workingTimes.open;
        }

        break;
      } else if(currentTimeOfDayValue >= openTimeValue && currentTimeOfDayValue <= closeTimeValue){
        currentStatus = App.translate("restaurant_swipe_screen.restaurant_card.working_hours.open_until.text") + " " + workingTimes.closed;
        break;
      }
    }

    return currentStatus;
  }

  @override
  String toString() {
    return "id: $id; name: $name;";
  }

  Restaurant({
      this.id,
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
      this.url});
}

@GenSerializer()
class RestaurantJsonSerializer extends Serializer<Restaurant> with _$RestaurantJsonSerializer {}


// Better name for this is just "Category" but it will have conflict with Flutter class
class RestaurantCategory{
  String alias;

  String title;

  @override
  String toString() {
    return "alias: $alias; title: $title";
  }

  RestaurantCategory({this.alias, this.title});
}

@GenSerializer()
class RestaurantCategoryJsonSerializer extends Serializer<RestaurantCategory> with _$RestaurantCategoryJsonSerializer {}


class WorkingHours{
  String dayOfWeek;

  @Alias('times')
  List<WorkingTimes> workingTimes;

  String getWorkingTimesFormatted(){
      List<String> workingTimesStringList = List<String>();

      if(workingTimes.length == 0){
        workingTimesStringList.add(App.translate("restaurant.working_hours.closed.text"));
      } else {
        for (WorkingTimes wt in workingTimes) {
          workingTimesStringList.add(wt.open + " - " + wt.closed);
        }
      }

      return workingTimesStringList.join(", ");
  }

  WorkingHours({this.dayOfWeek, this.workingTimes});
}

@GenSerializer()
class WorkingHoursJsonSerializer extends Serializer<WorkingHours> with _$WorkingHoursJsonSerializer {}


class WorkingTimes{
  String open;

  String closed;

  WorkingTimes({this.open, this.closed});
}

@GenSerializer()
class WorkingTimesJsonSerializer extends Serializer<WorkingTimes> with _$WorkingTimesJsonSerializer {}