// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'package:munch/model/restaurant.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/utility.dart';
import 'package:munch/widget/screen/swipe/include/restaurant_card.dart';
import 'package:timezone/data/latest.dart' as tz;


import '../util/test_util.dart';

Future<Restaurant> mockRestaurantInLocalTimezone() async{
  return Restaurant(
      id: '1',
      name: 'Test 1',
      categories: [],
      priceSymbol: '\$',
      rating: 5.0,
      photoUrls: [],
      reviewsNumber: 100,
      url: '',
      timezone: Utility.getTimezoneNameFromOffset(DateTime.now().timeZoneOffset)
  );
}


List<WorkingHours> getClosedRestaurantWorkingHours({bool workingHoursSplit}){
  DateTime now = DateTime.now();

  return [
    WorkingHours(
        dayOfWeek: DateFormat("EEEE").format(now),
        workingTimes: [
          WorkingTimes(
            open: DateFormat('jm').format(now.subtract(Duration(minutes: 5))),
            closed: DateFormat('jm').format(now.subtract(Duration(minutes: 4))),
          ),
          if(workingHoursSplit)
          WorkingTimes(
            open: DateFormat('jm').format(now.subtract(Duration(minutes: 3))),
            closed: DateFormat('jm').format(now.subtract(Duration(minutes: 2))),
          ),
        ]
    ),
    // Previous weekday
    WorkingHours(
        dayOfWeek: DateFormat("EEEE").format(now.subtract(Duration(days: 1))),
        workingTimes: [
          WorkingTimes(
            open: DateFormat('jm').format(now.subtract(Duration(minutes: 5))),
            closed: DateFormat('jm').format(now.subtract(Duration(minutes: 4))),
          ),
        ]
    ),

  ];
}

Future testRestaurantClosed(WidgetTester tester, Restaurant restaurant) async{
  for(int i = 0; i < 2; i++) {
    restaurant.workingHours = getClosedRestaurantWorkingHours(workingHoursSplit: i == 0 ? true : false);

    await TestUtil.testAppWidget(tester: tester, widgetToTest: RestaurantCard(restaurant));

    App.use24HoursFormat = false;

    String textToFind = App.translate("restaurant_swipe_screen.restaurant_card.working_hours.closed.text");

    expect(find.text(textToFind), findsOneWidget);

    if(i == 0) {
      print("Restaurant with split working hours *Closed* test passed");
    } else{
      print("Restaurant without split working hours *Closed* test passed");
    }
  }
}

List<WorkingHours> getReOpensRestaurantWorkingHours(){
  DateTime now = DateTime.now();

  return [
    WorkingHours(
        dayOfWeek: DateFormat("EEEE").format(now),
        workingTimes: [
          WorkingTimes(
            open: DateFormat('jm').format(now.subtract(Duration(minutes: 3))),
            closed: DateFormat('jm').format(now.subtract(Duration(minutes: 2))),
          ),
          WorkingTimes(
            open: DateFormat('jm').format(now.add(Duration(minutes: 2))),
            closed: DateFormat('jm').format(now.add(Duration(minutes: 3))),
          )
        ]
    ),
    // Previous weekday
    WorkingHours(
        dayOfWeek: DateFormat("EEEE").format(now.subtract(Duration(days: 1))),
        workingTimes: [
          WorkingTimes(
            open: DateFormat('jm').format(now.subtract(Duration(minutes: 5))),
            closed: DateFormat('jm').format(now.subtract(Duration(minutes: 4))),
          ),
        ]
    ),
  ];
}

Future testRestaurantReOpens(WidgetTester tester, Restaurant restaurant) async{
    restaurant.workingHours = getReOpensRestaurantWorkingHours();

    await TestUtil.testAppWidget(tester: tester, widgetToTest: RestaurantCard(restaurant));

    App.use24HoursFormat = false;

    String textToFind = App.translate("restaurant_swipe_screen.restaurant_card.working_hours.re-opens.text") + " " + restaurant.workingHours[0].workingTimes[1].open;

    expect(find.text(textToFind), findsOneWidget);

    print("Restaurant with split working hours *Re-Opens* test passed");
}

List<WorkingHours> getOpenUntilRestaurantWorkingHours({bool workingHoursSplit}){
  DateTime now = DateTime.now();

  return [
    WorkingHours(
        dayOfWeek: DateFormat("EEEE").format(now),
        workingTimes: [
          if(workingHoursSplit)
          WorkingTimes(
            open: DateFormat('jm').format(now.subtract(Duration(minutes: 4))),
            closed: DateFormat('jm').format(now.subtract(Duration(minutes: 3))),
          ),
          WorkingTimes(
            open: DateFormat('jm').format(now.subtract(Duration(minutes: 2))),
            closed: DateFormat('jm').format(now.add(Duration(minutes: 3))),
          )
        ]
    ),
    WorkingHours(
        dayOfWeek: DateFormat("EEEE").format(now.subtract(Duration(days: 1))),
        workingTimes: [
          WorkingTimes(
            open: DateFormat('jm').format(now.subtract(Duration(minutes: 5))),
            closed: DateFormat('jm').format(now.subtract(Duration(minutes: 4))),
          ),
        ]
    ),
  ];
}

Future testRestaurantOpenUntil(WidgetTester tester, Restaurant restaurant) async {
  for (int i = 0; i < 2; i++){
      restaurant.workingHours = getOpenUntilRestaurantWorkingHours(workingHoursSplit: i == 0 ? true : false);

      await TestUtil.testAppWidget(tester: tester, widgetToTest: RestaurantCard(restaurant));

      App.use24HoursFormat = false;

      String textToFind = App.translate("restaurant_swipe_screen.restaurant_card.working_hours.open_until.text") + " " +  (i == 0 ? restaurant.workingHours[0].workingTimes[1].closed : restaurant.workingHours[0].workingTimes[0].closed);

      expect(find.text(textToFind), findsOneWidget);

      if(i == 0) {
        print("Restaurant with split working hours *Open Until* test passed");
      } else{
        print("Restaurant without split working hours *Open Until* test passed");
      }
  }
}

List<WorkingHours> getOpensRestaurantWorkingHours({bool workingHoursSplit}){
  DateTime now = DateTime.now();

  return [
    WorkingHours(
        dayOfWeek: DateFormat("EEEE").format(now),
        workingTimes: [
          WorkingTimes(
            open: DateFormat('jm').format(now.add(Duration(minutes: 2))),
            closed: DateFormat('jm').format(now.add(Duration(minutes: 3))),
          ),
          if(workingHoursSplit)
          WorkingTimes(
            open: DateFormat('jm').format(now.add(Duration(minutes: 4))),
            closed: DateFormat('jm').format(now.add(Duration(minutes: 5))),
          )
        ]
    ),
    // Previous weekday
    WorkingHours(
        dayOfWeek: DateFormat("EEEE").format(now.subtract(Duration(days: 1))),
        workingTimes: [
          WorkingTimes(
            open: DateFormat('jm').format(now.subtract(Duration(minutes: 5))),
            closed: DateFormat('jm').format(now.subtract(Duration(minutes: 4))),
          ),
        ]
    ),
  ];
}

Future testRestaurantOpens(WidgetTester tester, Restaurant restaurant) async{
  for(int i = 0; i < 2; i++){
    restaurant.workingHours = getOpensRestaurantWorkingHours(workingHoursSplit: i == 0 ? true : false);

    await TestUtil.testAppWidget(tester: tester, widgetToTest: RestaurantCard(restaurant));

    App.use24HoursFormat = false;

    String textToFind = App.translate("restaurant_swipe_screen.restaurant_card.working_hours.opens.text") + " " + restaurant.workingHours[0].workingTimes[0].open;

    expect(find.text(textToFind), findsOneWidget);

    if(i == 0) {
      print("Restaurant with split working hours *Opens At* test passed");
    } else{
      print("Restaurant without split working hours *Opens At* test passed");
    }
  }
}

void main() {
  testWidgets('Restaurant working hours test', (WidgetTester tester) async {
      tz.initializeTimeZones();

      Restaurant restaurant = await mockRestaurantInLocalTimezone();

      await testRestaurantClosed(tester, restaurant);
      await testRestaurantReOpens(tester, restaurant);
      await testRestaurantOpenUntil(tester, restaurant);
      await testRestaurantOpens(tester, restaurant);
  });
}