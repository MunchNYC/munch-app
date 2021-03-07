import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/model/response/get_filters_response.dart';
import 'package:munch/model/secondary_filters.dart';
import 'package:munch/repository/filters_repository.dart';
import 'package:munch/service/munch/filter/filters_event.dart';

import 'filters_state.dart';

class FiltersBloc extends Bloc<FiltersEvent, FiltersState> {
  FiltersBloc() : super(FiltersState());

  final FiltersRepo _filtersRepo = FiltersRepo.getInstance();

  @override
  void onTransition(Transition<FiltersEvent, FiltersState> transition) {
    print(transition.toString());
    super.onTransition(transition);
  }

  @override
  Stream<FiltersState> mapEventToState(FiltersEvent event) async* {
    if (event is GetFiltersEvent) {
      yield* getFilters();
    } else if (event is UpdateFiltersEvent) {
      yield* updateFilters(event);
    } else if (event is UpdateAllFiltersEvent) {
      yield* updateAllFilters(event);
    }
  }

  Stream<FiltersState> getFilters() async* {
    yield FiltersFetchingState.loading();

    try {
      GetFiltersResponse getFiltersResponse = await _filtersRepo.getFilters();

      yield FiltersFetchingState.ready(data: getFiltersResponse);
    } catch (error) {
      print("Munches fetching failed: " + error.toString());
      yield FiltersFetchingState.failed(exception: error, message: error.toString());
    }
  }

  Stream<FiltersState> updateFilters(UpdateFiltersEvent updateFiltersEvent) async* {
    yield FiltersUpdatingState.loading();

    try {
      Munch munch = await _filtersRepo.updateFilters(
          whitelistFilters: updateFiltersEvent.whitelistFilters,
          blacklistFilters: updateFiltersEvent.blacklistFilters,
          munchId: updateFiltersEvent.munchId);

      yield FiltersUpdatingState.ready(data: munch);
    } catch (error) {
      print("Munches fetching failed: " + error.toString());
      yield FiltersUpdatingState.failed(exception: error, message: error.toString());
    }
  }

  Stream<FiltersState> updateAllFilters(UpdateAllFiltersEvent event) async* {
    yield FiltersUpdatingState.loading();

    try {
      Munch munch = await _filtersRepo.updateAllFilters(
          oldFilters: event.oldFilters,
          newFilters: event.newFilters,
          whitelistFilters: event.whitelistFilters,
          blacklistFilters: event.blacklistFilters,
          munchId: event.munchId
      );

      yield FiltersUpdatingState.ready(data: munch);
    } catch (error) {
      print("Updating filters failed: " + error.toString());
      yield FiltersUpdatingState.failed(exception: error, message: error.toString());
    }
  }
}


// tap save
// make both calls

// see if error code == 422

// double success
// 206 200 take most recent
// 206 206 take most recent
// 422 - only for new endpoint - preferences mismatch - get munchDetailed back - update Munch & display error of updating new filters
// 500

