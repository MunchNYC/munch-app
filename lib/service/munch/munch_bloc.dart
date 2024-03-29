import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/model/response/get_munches_response.dart';
import 'package:munch/model/restaurant.dart';
import 'package:munch/repository/munch_repository.dart';
import 'package:munch/service/munch/munch_state.dart';
import 'package:munch/analytics/analytics_repository.dart';

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
    } else if (event is GetHistoricalMunchesPageEvent) {
      yield* getHistoricalMunches(event);
    } else if (event is JoinMunchEvent) {
      yield* joinMunch(event.munchCode);
    } else if (event is CreateMunchEvent) {
      yield* createMunch(event.munch);
    } else if (event is GetDetailedMunchEvent) {
      yield* getDetailedMunch(event.munchId);
    } else if (event is GetRestaurantsPageEvent) {
      yield* getRestaurantsPage(event.munchId);
    } else if (event is RestaurantSwipeEvent) {
      yield* processRestaurantSwipe(event);
    } else if (event is NoMoreImagesCarouselEvent) {
      yield NoMoreCarouselImageState.ready(data: event.isLeftSideTapped);
    } else if (event is SaveMunchPreferencesEvent) {
      yield* saveMunchPreferences(event);
    } else if (event is KickMemberEvent) {
      yield* kickMember(event);
    } else if (event is LeaveMunchEvent) {
      yield* leaveMunch(event.munchId);
    } else if (event is NewMunchRestaurantEvent) {
      yield* cancelMunchDecision(event.munchId);
    } else if (event is ReviewMunchEvent) {
      yield* reviewMunch(event);
    }
  }

  Stream<MunchState> getMunches() async* {
    yield MunchesFetchingState.loading();

    try {
      GetMunchesResponse getMunchesResponse = await _munchRepo.getMunches();

      yield MunchesFetchingState.ready(data: getMunchesResponse);
    } catch (error) {
      print("Munches fetching failed: " + error.toString());
      yield MunchesFetchingState.failed(exception: error, message: error.toString());
    }
  }

  Stream<MunchState> getHistoricalMunches(GetHistoricalMunchesPageEvent getHistoricalMunchesEvent) async* {
    yield HistoricalMunchesPageFetchingState.loading();

    try {
      List<Munch> munchesList = await _munchRepo.getHistoricalMunchesNextPage();

      yield HistoricalMunchesPageFetchingState.ready(data: munchesList);
    } catch (error) {
      print("Munches fetching failed: " + error.toString());
      yield HistoricalMunchesPageFetchingState.failed(exception: error, message: error.toString());
    }
  }

  Stream<MunchState> joinMunch(String munchCode) async* {
    yield MunchJoiningState.loading();
    try {
      Munch munch = await _munchRepo.joinMunch(munchCode);

      yield MunchJoiningState.ready(data: munch);
    } catch (error) {
      print("Joining munch failed: " + error.toString());
      yield MunchJoiningState.failed(exception: error, message: error.toString());
    }
  }

  Stream<MunchState> createMunch(Munch munch) async* {
    yield MunchCreatingState.loading();
    try {
      Munch createdMunch = await _munchRepo.createMunch(munch);

      AnalyticsRepo.getInstance().trackGroupCreation(createdMunch.id);

      yield MunchCreatingState.ready(data: createdMunch);
    } catch (error) {
      print("Munch creation failed: " + error.toString());
      yield MunchCreatingState.failed(exception: error, message: error.toString());
    }
  }

  Stream<MunchState> getDetailedMunch(String munchId) async* {
    yield DetailedMunchFetchingState.loading();
    try {
      Munch detailedMunch = await _munchRepo.getDetailedMunch(munchId);

      yield DetailedMunchFetchingState.ready(data: detailedMunch);
    } catch (error) {
      print("Get detailed munch failed: " + error.toString());
      yield DetailedMunchFetchingState.failed(exception: error, message: error.toString());
    }
  }

  Stream<MunchState> getRestaurantsPage(String munchId) async* {
    yield RestaurantsPageFetchingState.loading();
    try {
      List<Restaurant> restaurantList = await _munchRepo.getSwipeRestaurantsPage(munchId);

      yield RestaurantsPageFetchingState.ready(data: restaurantList);
    } catch (error) {
      print("Get restaurants page failed: " + error.toString());
      yield RestaurantsPageFetchingState.failed(exception: error, message: error.toString());
    }
  }

  Stream<MunchState> processRestaurantSwipe(RestaurantSwipeEvent restaurantSwipeEvent) async* {
    yield RestaurantSwipeProcessingState.loading();

    try {
      Munch munch = await _munchRepo.swipeRestaurant(
          munchId: restaurantSwipeEvent.munchId,
          restaurantId: restaurantSwipeEvent.restaurantId,
          liked: restaurantSwipeEvent.liked);

      yield RestaurantSwipeProcessingState.ready(data: munch);
    } catch (error) {
      print("Munch swiping failed: " + error.toString());
      yield RestaurantSwipeProcessingState.failed(exception: error, message: error.toString());
    }
  }

  Stream<MunchState> saveMunchPreferences(SaveMunchPreferencesEvent saveMunchPreferencesEvent) async* {
    yield MunchPreferencesSavingState.loading();

    try {
      Munch munch = await _munchRepo.saveMunchPreferences(munch: saveMunchPreferencesEvent.munch);

      yield MunchPreferencesSavingState.ready(data: munch);
    } catch (error) {
      print("Munch preferences saving failed: " + error.toString());
      yield MunchPreferencesSavingState.failed(exception: error, message: error.toString());
    }
  }

  Stream<MunchState> kickMember(KickMemberEvent kickMemberEvent) async* {
    yield KickingMemberState.loading();

    try {
      Munch munch = await _munchRepo.kickMember(
        munchId: kickMemberEvent.munchId,
        userId: kickMemberEvent.userId,
      );

      yield KickingMemberState.ready(data: munch);
    } catch (error) {
      print("Member kicking failed: " + error.toString());
      yield KickingMemberState.failed(exception: error, message: error.toString());
    }
  }

  Stream<MunchState> leaveMunch(String munchId) async* {
    yield MunchLeavingState.loading();

    try {
      await _munchRepo.leaveMunch(munchId: munchId);

      yield MunchLeavingState.ready();
    } catch (error) {
      print("Leaving munch failed: " + error.toString());
      yield MunchLeavingState.failed(exception: error, message: error.toString());
    }
  }

  Stream<MunchState> cancelMunchDecision(String munchId) async* {
    yield CancellingMunchDecisionState.loading();

    try {
      Munch munch = await _munchRepo.cancelMunchDecision(
        munchId: munchId,
      );

      yield CancellingMunchDecisionState.ready(data: munch);
    } catch (error) {
      print("Munch decision cancellation failed: " + error.toString());
      yield CancellingMunchDecisionState.failed(exception: error, message: error.toString());
    }
  }

  Stream<MunchState> reviewMunch(ReviewMunchEvent reviewMunchEvent) async* {
    ReviewMunchState reviewMunchStateLoading =
        ReviewMunchState.loading(munchReviewValue: reviewMunchEvent.munchReviewValue);

    yield reviewMunchStateLoading;

    try {
      Munch munch = await _munchRepo.reviewMunch(
        munchReviewValue: reviewMunchEvent.munchReviewValue,
        munchId: reviewMunchEvent.munchId,
      );

      yield ReviewMunchState.ready(data: Map.of({"munch": munch, "forcedReview": reviewMunchEvent.forcedReview}));
    } catch (error) {
      print("Munch decision cancellation failed: " + error.toString());
      yield ReviewMunchState.failed(exception: error, message: error.toString());
    }
  }
}
