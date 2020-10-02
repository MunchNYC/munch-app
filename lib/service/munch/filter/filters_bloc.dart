import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:munch/api/filters_api.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/model/response/get_filters_response.dart';
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
    } else if(event is UpdateFiltersEvent){
      yield* updateFilters(event);
    }
  }

  Stream<FiltersState> getFilters() async* {
    yield FiltersFetchingState.loading();

    try {
      GetFiltersResponse getFiltersResponse = await _filtersRepo.getFilters();

      yield FiltersFetchingState.ready(data: getFiltersResponse);
    } catch (error) {
      print("Munches fetching failed: " + error.toString());
      yield FiltersFetchingState.failed(message: error.toString());
    }
  }

  Stream<FiltersState> updateFilters(UpdateFiltersEvent updateFiltersEvent) async* {
    yield FiltersUpdatingState.loading();

    try {
      Munch munch = await _filtersRepo.updateFilters(
        whitelistFilters: updateFiltersEvent.whitelistFilters,
        blacklistFilters: updateFiltersEvent.blacklistFilters,
        munchId: updateFiltersEvent.munchId
      );

      yield FiltersUpdatingState.ready(data: munch);
    } catch (error) {
      print("Munches fetching failed: " + error.toString());
      yield FiltersUpdatingState.failed(message: error.toString());
    }
  }
}
