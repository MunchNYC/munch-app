import 'package:flutter_test/flutter_test.dart';
import 'package:munch/util/app.dart';
import 'package:munch/widget/screen/swipe/restaurant_swipe_screen.dart';

void testSmallerOffsetCloserToLeave(Offset restaurantCardStartingGlobalOffset, double restaurantCardHeight, double restaurantCardWidth){
  for(int i = 0; i < 4; i++) {
    RestaurantSwipeScreenState restaurantSwipeScreenState = RestaurantSwipeScreenState();

    bool negativeX = i < 2 ? false : true;
    bool negativeY = i % 2 == 0 ? false : true;

    double dx = (negativeX ? -1 : 1) * 100.0;
    double dy = (negativeY ? -1 : 1) * 150.0;

    Offset currentAnimatedRestaurantCardGlobalOffset = Offset(
        restaurantCardStartingGlobalOffset.dx + dx,
        restaurantCardStartingGlobalOffset.dy + dy
    );

    restaurantSwipeScreenState.doSwipeCompletedAnimationCalculations(
        restaurantCardStartingGlobalOffset: restaurantCardStartingGlobalOffset,
        currentAnimatedRestaurantCardGlobalOffset: currentAnimatedRestaurantCardGlobalOffset,
        restaurantCardHeight: restaurantCardHeight,
        restaurantCardWidth: restaurantCardWidth
    );

    double expectedSwipeCompletedDistanceDX = negativeX ? -250.0 : 250.0;
    double actualSwipeCompletedDistanceDX = restaurantSwipeScreenState.swipeCompletedDistance.dx;

    expect(expectedSwipeCompletedDistanceDX, actualSwipeCompletedDistanceDX);

    if(restaurantSwipeScreenState.swipeCompletedDistance.dy < 0){
      expect(restaurantSwipeScreenState.swipeCompletedDistance.dy > -450.0, true);
    } else{
      expect(restaurantSwipeScreenState.swipeCompletedDistance.dy < 550.0, true);
    }

    print("Test Smaller Offset Closer To Leave drag end");
    print("DX: " + dx.toString() + ", DY: " + dy.toString());
    print("Card leaving at X: " + restaurantSwipeScreenState.swipeCompletedDistance.dx.toString() + ", Y: " + restaurantSwipeScreenState.swipeCompletedDistance.dy.toString());
    print("*Test passed*\n");
  }
}

void testDXCloserToLeave(Offset restaurantCardStartingGlobalOffset, double restaurantCardHeight, double restaurantCardWidth){
  for(int i = 0; i < 4; i++) {
    RestaurantSwipeScreenState restaurantSwipeScreenState = RestaurantSwipeScreenState();

    bool negativeX = i < 2 ? false : true;
    bool negativeY = i % 2 == 0 ? false : true;

    double dx = (negativeX ? -1 : 1) * 200.0;
    double dy = (negativeY ? -1 : 1) * 100.0;

    Offset currentAnimatedRestaurantCardGlobalOffset = Offset(
        restaurantCardStartingGlobalOffset.dx + dx,
        restaurantCardStartingGlobalOffset.dy + dy
    );

    restaurantSwipeScreenState.doSwipeCompletedAnimationCalculations(
        restaurantCardStartingGlobalOffset: restaurantCardStartingGlobalOffset,
        currentAnimatedRestaurantCardGlobalOffset: currentAnimatedRestaurantCardGlobalOffset,
        restaurantCardHeight: restaurantCardHeight,
        restaurantCardWidth: restaurantCardWidth
    );

    double expectedSwipeCompletedDistanceDX = negativeX ? -150.0 : 150.0;
    double actualSwipeCompletedDistanceDX = restaurantSwipeScreenState.swipeCompletedDistance.dx;

    expect(expectedSwipeCompletedDistanceDX, actualSwipeCompletedDistanceDX);

    if(restaurantSwipeScreenState.swipeCompletedDistance.dy < 0){
      expect(restaurantSwipeScreenState.swipeCompletedDistance.dy > -500.0, true);
    } else{
      expect(restaurantSwipeScreenState.swipeCompletedDistance.dy < 600.0, true);
    }

    print("Test DX Closer To Leave drag end");
    print("DX: " + dx.toString() + ", DY: " + dy.toString());
    print("Card leaving at X: " + restaurantSwipeScreenState.swipeCompletedDistance.dx.toString() + ", Y: " + restaurantSwipeScreenState.swipeCompletedDistance.dy.toString());
    print("*Test passed*\n");
  }
}

void testDYCloserToLeave(Offset restaurantCardStartingGlobalOffset, double restaurantCardHeight, double restaurantCardWidth){
  for(int i = 0; i < 4; i++) {
    RestaurantSwipeScreenState restaurantSwipeScreenState = RestaurantSwipeScreenState();

    bool negativeX = i < 2 ? false : true;
    bool negativeY = i % 2 == 0 ? false : true;

    double dx = (negativeX ? -1 : 1) * 100.0;
    double dy = (negativeY ? -1 : 1) * 500.0;

    Offset currentAnimatedRestaurantCardGlobalOffset = Offset(
        restaurantCardStartingGlobalOffset.dx + dx,
        restaurantCardStartingGlobalOffset.dy + dy
    );

    restaurantSwipeScreenState.doSwipeCompletedAnimationCalculations(
        restaurantCardStartingGlobalOffset: restaurantCardStartingGlobalOffset,
        currentAnimatedRestaurantCardGlobalOffset: currentAnimatedRestaurantCardGlobalOffset,
        restaurantCardHeight: restaurantCardHeight,
        restaurantCardWidth: restaurantCardWidth
    );

    double expectedSwipeCompletedDistanceDY = negativeY ? -100.0 : 200.0;
    double actualSwipeCompletedDistanceDY = restaurantSwipeScreenState.swipeCompletedDistance.dy;

    if(restaurantSwipeScreenState.swipeCompletedDistance.dx < 0){
      expect(restaurantSwipeScreenState.swipeCompletedDistance.dx > -250.0, true);
    } else{
      expect(restaurantSwipeScreenState.swipeCompletedDistance.dx < 250.0, true);
    }

    expect(actualSwipeCompletedDistanceDY, expectedSwipeCompletedDistanceDY);

    print("Test DY Closer To Leave drag end");
    print("DX: " + dx.toString() + ", DY: " + dy.toString());
    print("Card leaving at X: " + restaurantSwipeScreenState.swipeCompletedDistance.dx.toString() + ", Y: " + restaurantSwipeScreenState.swipeCompletedDistance.dy.toString());
    print("*Test passed*\n");
  }
}

void testDXZeroOffset(Offset restaurantCardStartingGlobalOffset, double restaurantCardHeight, double restaurantCardWidth){
  for(int i = 0; i < 2; i++) {
    RestaurantSwipeScreenState restaurantSwipeScreenState = RestaurantSwipeScreenState();

    bool negative = i % 2 == 0 ? false : true;

    double dx = 0.0;
    double dy = (negative ? -1 : 1) * 100.0;

    Offset currentAnimatedRestaurantCardGlobalOffset = Offset(
        restaurantCardStartingGlobalOffset.dx + dx,
        restaurantCardStartingGlobalOffset.dy + dy
    );

    restaurantSwipeScreenState.doSwipeCompletedAnimationCalculations(
        restaurantCardStartingGlobalOffset: restaurantCardStartingGlobalOffset,
        currentAnimatedRestaurantCardGlobalOffset: currentAnimatedRestaurantCardGlobalOffset,
        restaurantCardHeight: restaurantCardHeight,
        restaurantCardWidth: restaurantCardWidth
    );

    Offset expectedSwipeCompletedDistance = Offset(0.0, negative ? -500.0 : 600.0);
    Offset actualSwipeCompletedDistance = restaurantSwipeScreenState.swipeCompletedDistance;

    expect(actualSwipeCompletedDistance, expectedSwipeCompletedDistance);

    print("Test DX Zero offset drag end");
    print("DX: " + dx.toString() + ", DY: " + dy.toString());
    print("Card leaving at X: " + actualSwipeCompletedDistance.dx.toString() + ", Y: " + actualSwipeCompletedDistance.dy.toString());
    print("*Test passed*\n");
  }
}

void testDYZeroOffset(Offset restaurantCardStartingGlobalOffset, double restaurantCardHeight, double restaurantCardWidth){
  for(int i = 0; i < 2; i++) {
    RestaurantSwipeScreenState restaurantSwipeScreenState = RestaurantSwipeScreenState();

    bool negative = i % 2 == 0 ? false : true;

    double dx = (negative ? -1 : 1) * 100.0;
    double dy = 0.0;

    Offset currentAnimatedRestaurantCardGlobalOffset = Offset(
        restaurantCardStartingGlobalOffset.dx + dx,
        restaurantCardStartingGlobalOffset.dy + dy
    );

    restaurantSwipeScreenState.doSwipeCompletedAnimationCalculations(
        restaurantCardStartingGlobalOffset: restaurantCardStartingGlobalOffset,
        currentAnimatedRestaurantCardGlobalOffset: currentAnimatedRestaurantCardGlobalOffset,
        restaurantCardHeight: restaurantCardHeight,
        restaurantCardWidth: restaurantCardWidth
    );

    Offset expectedSwipeCompletedDistance = Offset(negative ? -250.0 : 250.0, 0.0);
    Offset actualSwipeCompletedDistance = restaurantSwipeScreenState.swipeCompletedDistance;

    expect(actualSwipeCompletedDistance, expectedSwipeCompletedDistance);

    print("Test DY Zero offset drag end");
    print("DX: " + dx.toString() + ", DY: " + dy.toString());
    print("Card leaving at X: " + actualSwipeCompletedDistance.dx.toString() + ", Y: " + actualSwipeCompletedDistance.dy.toString());
    print("*Test passed*\n");
  }
}

void main() {
  test('Swipe completed animation calculations test',  () async {
    App.screenWidth = 400;
    App.screenHeight = 800;

    Offset restaurantCardStartingGlobalOffset = Offset(50.0, 100.0);
    double restaurantCardWidth = 300.0;
    double restaurantCardHeight = 500.0;

    testDYZeroOffset(restaurantCardStartingGlobalOffset, restaurantCardHeight, restaurantCardWidth);
    testDXZeroOffset(restaurantCardStartingGlobalOffset, restaurantCardHeight, restaurantCardWidth);
    testDYCloserToLeave(restaurantCardStartingGlobalOffset, restaurantCardHeight, restaurantCardWidth);
    testDXCloserToLeave(restaurantCardStartingGlobalOffset, restaurantCardHeight, restaurantCardWidth);
    testSmallerOffsetCloserToLeave(restaurantCardStartingGlobalOffset, restaurantCardHeight, restaurantCardWidth);
  });
}