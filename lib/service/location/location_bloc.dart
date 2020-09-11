import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'location_event.dart';
import 'location_state.dart';


class LocationBloc extends Bloc<LocationEvent, LocationState> {
  @override
  get initialState => LocationState();

  @override
  Stream<LocationState> mapEventToState(LocationEvent event) async* {
    if(event is GetCurrentLocationEvent){
      yield* getCurrentLocation();
    }
  }

  Stream<LocationState> getCurrentLocation() async* {
    yield CurrentLocationFetchingState.loading();

    Position currentLocation;

    try {
      currentLocation = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      yield CurrentLocationFetchingState.ready(data: currentLocation);
    } catch (error) {
      print("Getting current location failed. " + error.toString());

      // If user doesn't want to enable location services or doesn't want to allow permission try to acquire getLastKnownPosition (can return null)
      currentLocation = await getLastKnownPosition();

      if(currentLocation != null) {
        yield CurrentLocationFetchingState.ready(data: currentLocation);
      } else{
        print("Getting last known location failed. " + error.toString());

        yield CurrentLocationFetchingState.failed(message: error.toString());
      }
    }
  }

}