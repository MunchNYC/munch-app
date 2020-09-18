import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/model/restaurant.dart';
import 'package:munch/repository/munch_repository.dart';
import 'package:munch/service/munch/munch_state.dart';

import 'munch_event.dart';

class MunchBloc extends Bloc<MunchEvent, MunchState> {
  MunchBloc() : super(MunchState());

  final MunchRepo _munchRepo = MunchRepo.getInstance();

  @override
  void onTransition(Transition<MunchEvent, MunchState> transition) {
    print(transition.toString());
    super.onTransition(transition);
  }

  @override
  Stream<MunchState> mapEventToState(MunchEvent event) async* {
    if (event is GetMunchesEvent) {
      yield* getMunches();
    } else if (event is JoinMunchEvent){
      yield* joinMunch(event.munchCode);
    } else if(event is CreateMunchEvent){
      yield* createMunch(event.munch);
    } else if(event is GetDetailedMunchEvent){
      yield* getDetailedMunch(event.munchId);
    } else if(event is GetRestaurantsPageEvent){
      yield* getRestaurantsPage(event.munchId);
    } else if(event is RestaurantSwipeEvent){
      yield* processRestaurantSwipe(event);
    }
  }

  Stream<MunchState> getMunches() async* {
    yield MunchesFetchingState.loading();

    try {
      List<Munch> munches = await _munchRepo.getMunches();

      yield MunchesFetchingState.ready(data: munches);
    } catch (error) {
      print("Munches fetching failed: " + error.toString());
      yield MunchesFetchingState.failed(message: error.toString());
    }
  }

  Stream<MunchState> joinMunch(String munchCode) async* {
    yield MunchJoiningState.loading();
    try {
      Munch munch = await _munchRepo.joinMunch(munchCode);

      yield MunchJoiningState.ready(data: munch);
    } catch (error) {
      print("Joining munch failed: " + error.toString());
      yield MunchJoiningState.failed(message: error.toString());
    }
  }

  Stream<MunchState> createMunch(Munch munch) async* {
    yield MunchCreatingState.loading();
    try {
      Munch createdMunch = await _munchRepo.createMunch(munch);

      yield MunchCreatingState.ready(data: createdMunch);
    } catch (error) {
      print("Munch creation failed: " + error.toString());
      yield MunchCreatingState.failed(message: error.toString());
    }
  }

  Stream<MunchState> getDetailedMunch(String munchId) async* {
    yield DetailedMunchFetchingState.loading();
    try {
      Munch detailedMunch = await _munchRepo.getDetailedMunch(munchId);

      yield DetailedMunchFetchingState.ready(data: detailedMunch);
    } catch (error) {
      print("Get detailed munch failed: " + error.toString());
      yield DetailedMunchFetchingState.failed(message: error.toString());
    }
  }

  Stream<MunchState> getRestaurantsPage(String munchId) async* {
    yield RestaurantsPageFetchingState.loading();
    try {
      List<Restaurant> restaurantList = await _munchRepo.getSwipeRestaurantsPage(munchId);

      yield RestaurantsPageFetchingState.ready(data: restaurantList);
    } catch (error) {
      print("Get restaurants page failed: " + error.toString());
      yield RestaurantsPageFetchingState.failed(message: error.toString());
    }
  }

  Stream<MunchState> processRestaurantSwipe(RestaurantSwipeEvent restaurantSwipeEvent) async* {
    yield RestaurantSwipeProcessingState.loading();

    try {
      Munch munch = await _munchRepo.swipeRestaurant(
          munchId: restaurantSwipeEvent.munchId,
          restaurantId: restaurantSwipeEvent.restaurantId,
          liked: restaurantSwipeEvent.liked
      );

      yield RestaurantSwipeProcessingState.ready(data: munch);
    } catch (error) {
      print("Munch swiping failed: " + error.toString());
      yield RestaurantSwipeProcessingState.failed(message: error.toString());
    }
  }

}