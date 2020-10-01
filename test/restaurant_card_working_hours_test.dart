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
import 'package:munch/widget/screen/swipe/include/restaurant_card.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'util/test_util.dart';


Restaurant mockRestaurantInLocalTimezone(){
  return Restaurant(
      id: '1',
      name: 'Test 1',
      categories: [],
      priceSymbol: '\$',
      rating: 5.0,
      photoUrls: [],
      reviewsNumber: 100,
      url: '',
      timezone: 'Europe/Belgrade'
  );
}


List<WorkingHours> getClosedRestaurantWorkingHours({bool workingHoursSplitted}){
  DateTime now = DateTime.now();

  return [
    WorkingHours(
        dayOfWeek: DateFormat("EEEE").format(now),
        workingTimes: [
          WorkingTimes(
            open: DateFormat('jm').format(now.subtract(Duration(minutes: 5))),
            closed: DateFormat('jm').format(now.subtract(Duration(minutes: 4))),
          ),
          if(workingHoursSplitted)
          WorkingTimes(
            open: DateFormat('jm').format(now.subtract(Duration(minutes: 3))),
            closed: DateFormat('jm').format(now.subtract(Duration(minutes: 2))),
          )
        ]
    )
  ];
}

Future testRestaurantClosed(WidgetTester tester, Restaurant restaurant) async{
  for(int i = 0; i < 2; i++) {
    restaurant.workingHours = getClosedRestaurantWorkingHours(workingHoursSplitted: i == 0 ? true : false);

    await tester.pump();

    String textToFind = App.translate("restaurant_swipe_screen.restaurant_card.working_hours.closed.text");

    expect(find.text(textToFind), findsOneWidget);
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
    )
  ];
}

Future testRestaurantReOpens(WidgetTester tester, Restaurant restaurant) async{
    restaurant.workingHours = getReOpensRestaurantWorkingHours();

    await tester.pump();

    String textToFind = App.translate("restaurant_swipe_screen.restaurant_card.working_hours.re-opens.text") + " " + restaurant.workingHours[0].workingTimes[1].open;

    expect(find.text(textToFind), findsOneWidget);
}

List<WorkingHours> getOpenUntilRestaurantWorkingHours({bool workingHoursSplitted}){
  DateTime now = DateTime.now();

  return [
    WorkingHours(
        dayOfWeek: DateFormat("EEEE").format(now),
        workingTimes: [
          if(workingHoursSplitted)
          WorkingTimes(
            open: DateFormat('jm').format(now.subtract(Duration(minutes: 4))),
            closed: DateFormat('jm').format(now.subtract(Duration(minutes: 3))),
          ),
          WorkingTimes(
            open: DateFormat('jm').format(now.subtract(Duration(minutes: 2))),
            closed: DateFormat('jm').format(now.add(Duration(minutes: 3))),
          )
        ]
    )
  ];
}

Future testRestaurantOpenUntil(WidgetTester tester, Restaurant restaurant) async {
  for (int i = 0; i < 2; i++){
      restaurant.workingHours = getOpenUntilRestaurantWorkingHours(workingHoursSplitted: i == 0 ? true : false);

      await tester.pump();

      String textToFind = App.translate("restaurant_swipe_screen.restaurant_card.working_hours.open_until.text") + " " +  (i == 0 ? restaurant.workingHours[0].workingTimes[1].closed : restaurant.workingHours[0].workingTimes[0].closed);

      expect(find.text(textToFind), findsOneWidget);
  }
}

List<WorkingHours> getOpensRestaurantWorkingHours({bool workingHoursSplitted}){
  DateTime now = DateTime.now();

  return [
    WorkingHours(
        dayOfWeek: DateFormat("EEEE").format(now),
        workingTimes: [
          WorkingTimes(
            open: DateFormat('jm').format(now.add(Duration(minutes: 2))),
            closed: DateFormat('jm').format(now.add(Duration(minutes: 3))),
          ),
          if(workingHoursSplitted)
          WorkingTimes(
            open: DateFormat('jm').format(now.add(Duration(minutes: 4))),
            closed: DateFormat('jm').format(now.add(Duration(minutes: 5))),
          )
        ]
    )
  ];
}

Future testRestaurantOpens(WidgetTester tester, Restaurant restaurant) async{
  for(int i = 0; i < 2; i++){
    restaurant.workingHours = getOpensRestaurantWorkingHours(workingHoursSplitted: i == 0 ? true : false);

    await tester.pump();

    String textToFind = App.translate("restaurant_swipe_screen.restaurant_card.working_hours.opens.text") + " " + restaurant.workingHours[0].workingTimes[0].open;

    expect(find.text(textToFind), findsOneWidget);
  }
}

void main() {
  testWidgets('Restaurant working hours test', (WidgetTester tester) async {
      tz.initializeTimeZones();

      Restaurant restaurant = mockRestaurantInLocalTimezone();

      restaurant.workingHours = getClosedRestaurantWorkingHours(workingHoursSplitted: true);

      // MUST BE CALLED HERE WITH AWAIT
      await TestUtil.setupTestAppWithLocalizations(tester: tester, widgetToTest: RestaurantCard(restaurant));

      await testRestaurantClosed(tester, restaurant);
      await testRestaurantReOpens(tester, restaurant);
      await testRestaurantOpenUntil(tester, restaurant);
      await testRestaurantOpens(tester, restaurant);
  });
}
