import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:munch/model/coordinates.dart';
import 'package:munch/util/app.dart';

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

  @Field.ignore()
  String get categoryTitles => categories.map((RestaurantCategory restaurantCategory) => restaurantCategory.title).join(", ");

  String getWorkingHoursCurrentStatus(){
    String currentDayOfWeek =  DateFormat('EEEE').format(DateTime.now());

    WorkingHours dayWorkingHours = workingHours.where((WorkingHours workingHours) => workingHours.dayOfWeek.toLowerCase() == currentDayOfWeek.toLowerCase()).first;

    TimeOfDay currentTimeOfDay = TimeOfDay.now();

    int currentTimeOfDayValue = 3 * 60 + currentTimeOfDay.minute;

    String currentStatus = App.translate("restaurant_swipe_screen.restaurant_card.working_hours.closed.text");

    for(int i = 0; i < dayWorkingHours.workingTimes.length; i++){
      WorkingTimes workingTimes = dayWorkingHours.workingTimes[i];

      TimeOfDay openTime = TimeOfDay.fromDateTime(DateFormat('jm').parse(workingTimes.open));
      TimeOfDay closeTime = TimeOfDay.fromDateTime(DateFormat('jm').parse(workingTimes.closed));

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
}

@GenSerializer()
class WorkingHoursJsonSerializer extends Serializer<WorkingHours> with _$WorkingHoursJsonSerializer {}


class WorkingTimes{
  String open;

  String closed;
}

@GenSerializer()
class WorkingTimesJsonSerializer extends Serializer<WorkingTimes> with _$WorkingTimesJsonSerializer {}