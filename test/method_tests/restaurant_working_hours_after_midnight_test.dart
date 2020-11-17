import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:munch/model/restaurant.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/utility.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../util/test_util.dart';

List<WorkingHours> getTestRestaurantWorkingHours(){
  return [
    WorkingHours(
        dayOfWeek: 'MONDAY',
        workingTimes: [
          WorkingTimes(
            open: '08:00 PM',
            closed: '02:00 AM',
          ),
        ]
    ),
    WorkingHours(
        dayOfWeek: 'TUESDAY',
        workingTimes: [
          WorkingTimes(
            open: '07:00 PM',
            closed: '01:00 AM',
          ),
        ]
    ),
    WorkingHours(
        dayOfWeek: 'WEDNESDAY',
        workingTimes: []
    ),
    WorkingHours(
        dayOfWeek: 'THURSDAY',
        workingTimes: [
          WorkingTimes(
            open: '09:00 AM',
            closed: '09:00 AM',
          ),
        ]
    ),
    WorkingHours(
        dayOfWeek: 'FRIDAY',
        workingTimes: []
    ),
    WorkingHours(
        dayOfWeek: 'SATURDAY',
        workingTimes: []
    ),
    WorkingHours(
        dayOfWeek: 'SUNDAY',
        workingTimes: []
    ),
  ];
}

Restaurant mockRestaurantInNYCTimezone() {
  return Restaurant(
      id: '1',
      name: 'Test 1',
      categories: [],
      priceSymbol: '\$',
      rating: 5.0,
      photoUrls: [],
      reviewsNumber: 100,
      url: '',
      timezone: 'America/New_York',
  );
}

void testRestaurantOpenUntilAfterMidnight(Restaurant restaurant){
  // restaurantTimezone Tuesday 00:15 AM
  tz.TZDateTime mockedUpTuesdayTimeInNYCTimezone = tz.TZDateTime(tz.getLocation(restaurant.timezone), 2020, 1, 7, 0, 15);

  Map<String, dynamic> currentDayStatusResult = restaurant.getCurrentWorkingDayStatus(mockedUpTuesdayTimeInNYCTimezone);

  WorkingHours mondayWorkingHours = restaurant.workingHours[0];

  expect(currentDayStatusResult["isClosed"], true);

  Map<String, dynamic> prevDayStatusResult = restaurant.getPreviousWorkingDayLastStatus(mockedUpTuesdayTimeInNYCTimezone);

  expect(prevDayStatusResult["isClosed"], false);
  expect(prevDayStatusResult["status"], App.translate("restaurant_swipe_screen.restaurant_card.working_hours.open_until.text")
      + " " + mondayWorkingHours.workingTimes[0].closed);

  print("Working Hours Monday: " + mondayWorkingHours.workingTimes[0].open + " - " + mondayWorkingHours.workingTimes[0].closed);
  print("Tuesday time: " + DateFormat("hh:mm aa").format(mockedUpTuesdayTimeInNYCTimezone));
  print("Status: " + App.translate("restaurant_swipe_screen.restaurant_card.working_hours.open_until.text")
      + " " + mondayWorkingHours.workingTimes[0].closed);
  print("*Test Restaurant Open Until After Midnight test passed*\n");
}

void testRestaurantOpensAtAfterMidnight(Restaurant restaurant){
  // restaurantTimezone Tuesday 02:15 AM
  tz.TZDateTime mockedUpTuesdayTimeInNYCTimezone = tz.TZDateTime(tz.getLocation(restaurant.timezone), 2020, 1, 7, 2, 15);

  Map<String, dynamic> currentDayStatusResult = restaurant.getCurrentWorkingDayStatus(mockedUpTuesdayTimeInNYCTimezone);

  WorkingHours mondayWorkingHours = restaurant.workingHours[0];
  WorkingHours tuesdayWorkingHours = restaurant.workingHours[1];

  expect(currentDayStatusResult["isClosed"], true);
  expect(currentDayStatusResult["status"], App.translate("restaurant_swipe_screen.restaurant_card.working_hours.opens.text")
      + " " + tuesdayWorkingHours.workingTimes[0].open);

  Map<String, dynamic> prevDayStatusResult = restaurant.getPreviousWorkingDayLastStatus(mockedUpTuesdayTimeInNYCTimezone);
  expect(prevDayStatusResult["isClosed"], true);

  print("Working Hours Monday: " + mondayWorkingHours.workingTimes[0].open + " - " + mondayWorkingHours.workingTimes[0].closed);
  print("Tuesday time: " + DateFormat("hh:mm aa").format(mockedUpTuesdayTimeInNYCTimezone));
  print("Working Hours Tuesday: " + tuesdayWorkingHours.workingTimes[0].open + " - " + tuesdayWorkingHours.workingTimes[0].closed);
  print("Status: " + App.translate("restaurant_swipe_screen.restaurant_card.working_hours.opens.text")
      + " " + tuesdayWorkingHours.workingTimes[0].open);
  print("*Test Restaurant Opens At After Midnight test passed*\n");
}

void testRestaurantClosedAfterMidnight(Restaurant restaurant){
  // restaurantTimezone Wednesday 01:15 AM
  tz.TZDateTime mockedUpWednesdayTimeInNYCTimezone = tz.TZDateTime(tz.getLocation(restaurant.timezone), 2020, 1, 8, 1, 15);

  Map<String, dynamic> currentDayStatusResult = restaurant.getCurrentWorkingDayStatus(mockedUpWednesdayTimeInNYCTimezone);

  expect(currentDayStatusResult["isClosed"], true);
  expect(currentDayStatusResult["status"], App.translate("restaurant_swipe_screen.restaurant_card.working_hours.closed.text"));

  Map<String, dynamic> prevDayStatusResult = restaurant.getPreviousWorkingDayLastStatus(mockedUpWednesdayTimeInNYCTimezone);
  expect(prevDayStatusResult["isClosed"], true);

  WorkingHours tuesdayWorkingHours = restaurant.workingHours[1];

  print("Working Hours Tuesday: " + tuesdayWorkingHours.workingTimes[0].open + " - " + tuesdayWorkingHours.workingTimes[0].closed);
  print("Wednesday time: " + DateFormat("hh:mm aa").format(mockedUpWednesdayTimeInNYCTimezone));
  print("Working Hours Wednesday: Closed");
  print("Status: " + App.translate("restaurant_swipe_screen.restaurant_card.working_hours.closed.text"));
  print("*Test Restaurant Closed After Midnight test passed*\n");
}

void testRestaurantOpenWholeDay(Restaurant restaurant){
  // restaurantTimezone Friday 08:30 AM
  tz.TZDateTime mockedUpFridayTimeInNYCTimezone = tz.TZDateTime(tz.getLocation(restaurant.timezone), 2020, 1, 10, 8, 30);

  Map<String, dynamic> currentDayStatusResult = restaurant.getCurrentWorkingDayStatus(mockedUpFridayTimeInNYCTimezone);

  WorkingHours thursdayWorkingHours = restaurant.workingHours[3];

  expect(currentDayStatusResult["isClosed"], true);

  Map<String, dynamic> prevDayStatusResult = restaurant.getPreviousWorkingDayLastStatus(mockedUpFridayTimeInNYCTimezone);

  expect(prevDayStatusResult["isClosed"], false);
  expect(prevDayStatusResult["status"], App.translate("restaurant_swipe_screen.restaurant_card.working_hours.open_until.text")
      + " " + thursdayWorkingHours.workingTimes[0].closed);

  print("Working Hours Thursday: " + thursdayWorkingHours.workingTimes[0].open + " - " + thursdayWorkingHours.workingTimes[0].closed + " (Next Day)");
  print("Friday time: " + DateFormat("hh:mm aa").format(mockedUpFridayTimeInNYCTimezone));
  print("Status: " + App.translate("restaurant_swipe_screen.restaurant_card.working_hours.open_until.text")
      + " " + thursdayWorkingHours.workingTimes[0].closed + " (Next Day)");
  print("*Test Restaurant Open 24/7 test passed*\n");
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('Restaurant current working hours after midnight status tests',  (WidgetTester tester) async {
    tz.initializeTimeZones();

    // pump Anything just to initialize localizations
    await TestUtil.testAppWidget(tester: tester, widgetToTest: Container());

    App.use24HoursFormat = false;

    Restaurant restaurant = mockRestaurantInNYCTimezone();

    restaurant.workingHours = getTestRestaurantWorkingHours();

    testRestaurantOpenUntilAfterMidnight(restaurant);
    testRestaurantOpensAtAfterMidnight(restaurant);
    testRestaurantClosedAfterMidnight(restaurant);
    testRestaurantOpenWholeDay(restaurant);
  });
}