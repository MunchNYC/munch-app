import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'location_event.dart';
import 'location_state.dart';


class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationState());

  @override
  Stream<LocationState> mapEventToState(LocationEvent event) async* {
    if(event is GetCurrentLocationEvent){
      yield* getCurrentLocation();
    }
  }

  Stream<LocationState> getCurrentLocation() async* {
    yield CurrentLocationFetchingState.loading();

    Position currentLocation;
    LocationPermission locationPermission;

    try {
      locationPermission = await requestPermission();

      if(locationPermission == LocationPermission.whileInUse || locationPermission == LocationPermission.always){
        currentLocation = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

        yield CurrentLocationFetchingState.ready(data: currentLocation);
      }
    } catch (error) {
      print("Getting current location failed. " + error.toString());

      if(locationPermission != null && (locationPermission == LocationPermission.whileInUse || locationPermission == LocationPermission.always)){
        // If user doesn't want to enable location services try to acquire getLastKnownPosition (can return null)
        currentLocation = await getLastKnownPosition();

        if(currentLocation != null) {
          yield CurrentLocationFetchingState.ready(data: currentLocation);
        }
      }
    }

    if(currentLocation == null) {
      print("Getting last known location failed.");

      yield CurrentLocationFetchingState.failed();
    }
  }

}