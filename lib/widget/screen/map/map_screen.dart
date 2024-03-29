import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:munch/config/app_config.dart';
import 'package:munch/flutter_google_places-0.2.6/flutter_google_places.dart';
import 'package:munch/google_maps_webservice-0.0.18/core.dart';
import 'package:munch/google_maps_webservice-0.0.18/places.dart'; // IMPORTANT TO BE MANUALLY INCLUDED FOR flutter_google_places library
import 'package:munch/model/coordinates.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/repository/maps_repository.dart';
import 'package:munch/service/location/location_bloc.dart';
import 'package:munch/service/location/location_event.dart';
import 'package:munch/service/location/location_state.dart';
import 'package:munch/service/munch/munch_bloc.dart';
import 'package:munch/service/munch/munch_event.dart';
import 'package:munch/service/munch/munch_state.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/util/navigation_helper.dart';
import 'package:munch/util/utility.dart';
import 'package:munch/widget/util/app_circular_progress_indicator.dart';
import 'package:munch/widget/util/custom_button.dart';
import 'package:munch/widget/util/custom_form_field.dart';
import 'package:munch/widget/util/error_page_widget.dart';

class MapScreen extends StatefulWidget {
  String munchName;

  bool editLocation;

  // will be sent if editLocation = true
  Munch munch;

  MapScreen({this.munchName, this.editLocation = false, this.munch});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static const double DEFAULT_MAP_ZOOM = 14.5;
  static const LatLng DEFAULT_CAMERA_POSITION = LatLng(40.7128, -74.0060);

  static const double MILES_TO_METERS_RATIO = 1609.344;
  static const List<double> RADIUS_VALUES_MILES = [0.5, 1, 2, 5];
  static const List<double> RADIUS_VALUES_ZOOMS = [
    DEFAULT_MAP_ZOOM,
    DEFAULT_MAP_ZOOM - 1.0,
    DEFAULT_MAP_ZOOM - 2.0,
    DEFAULT_MAP_ZOOM - 3.0
  ];

  static List<int> _radiusValuesMetres =
      RADIUS_VALUES_MILES.map((value) => (value * MILES_TO_METERS_RATIO).floor()).toList();

  int _circleRadius = _radiusValuesMetres[0];
  Circle _centralCircle;

  Position _currentLocation;

  LatLng _initialCameraPosition;
  double _initialMapZoom;

  TextEditingController _searchTextController = TextEditingController();

  MunchBloc _munchBloc;
  LocationBloc _locationBloc;

  @override
  void initState() {
    _munchBloc = MunchBloc();
    _locationBloc = LocationBloc();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // After transition is finished, iOS has bug if animation transition is not finished
    ModalRoute.of(context).animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _locationBloc.add(GetCurrentLocationEvent());
      }
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _locationBloc?.close();
    super.dispose();
  }

  Widget _appBar(BuildContext context) {
    return AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: Palette.background,
        title: Stack(
          children: <Widget>[
            CustomButton(
              flat: true,
              // very important to set, otherwise title won't be aligned good
              padding: EdgeInsets.zero,
              color: Colors.transparent,
              content: Text(App.translate("map_screen.app_bar.leading.text"),
                  style: AppTextStyle.style(AppTextStylePattern.heading6,
                      fontWeight: FontWeight.w500, fontSizeOffset: 1.0, color: Palette.hyperlink)),
              onPressedCallback: () {
                NavigationHelper.popRoute(context, rootNavigator: false);
              },
            ),
            Center(
                child: Text(
                    !widget.editLocation
                        ? App.translate("map_screen.app_bar.choose.title")
                        : App.translate("map_screen.app_bar.edit.title"),
                    style: AppTextStyle.style(AppTextStylePattern.heading6, fontWeight: FontWeight.w500))),
          ],
        ));
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
        backgroundColor: Palette.background,
        child: ImageIcon(AssetImage("assets/icons/locateMe.png"), size: 20.0, color: Palette.hyperlink),
        onPressed: () {
          if (_currentLocation != null) {
            _animateMapToLocation(LatLng(_currentLocation.latitude, _currentLocation.longitude));
          }
        });
  }

  void _initCentralCircle() {
    _centralCircle = Circle(
        circleId: CircleId('Central circle'),
        fillColor: Color(0x9093BFF2),
        radius: _circleRadius.toDouble(),
        strokeWidth: 2,
        strokeColor: Color(0xFF4970D6),
        center: _initialCameraPosition);
  }

  double _getZoomBasedOnRadiusValue() {
    double zoom = DEFAULT_MAP_ZOOM;

    for (int i = 0; i < _radiusValuesMetres.length; i++) {
      if (_radiusValuesMetres[i] == _circleRadius) {
        // scale default zoom
        zoom = RADIUS_VALUES_ZOOMS[i];
        break;
      }
    }

    return zoom;
  }

  void _initCurrentMunchLocation() {
    _initialCameraPosition = LatLng(widget.munch.coordinates.latitude, widget.munch.coordinates.longitude);
    _circleRadius = widget.munch.radius;

    _initialMapZoom = _getZoomBasedOnRadiusValue();
  }

  void _initLocationDefaultValues() {
    _initialCameraPosition = DEFAULT_CAMERA_POSITION;
    _initialMapZoom = DEFAULT_MAP_ZOOM;
  }

  void _initCurrentMapLocation() {
    _initialCameraPosition = LatLng(_currentLocation.latitude, _currentLocation.longitude);
    _initialMapZoom = DEFAULT_MAP_ZOOM;
  }

  void _locationListener(BuildContext context, LocationState state) {
    if (state.hasError) {
      // don't show flushbar if we don't get user's location
      if (state is CurrentLocationFetchingState) {
        if (widget.editLocation) {
          _initCurrentMunchLocation();
        } else {
          _initLocationDefaultValues();
        }

        _initCentralCircle();
      } else {
        Utility.showErrorFlushbar(state.message, context);
      }
    } else {
      if (state is CurrentLocationFetchingState) {
        if (state.hasData) {
          _currentLocation = state.data;
        }

        if (widget.editLocation) {
          _initCurrentMunchLocation();
        } else {
          if (state.hasData) {
            _initCurrentMapLocation();
          } else {
            _initLocationDefaultValues();
          }
        }

        _initCentralCircle();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _appBar(context),
      body: BlocConsumer<LocationBloc, LocationState>(
          cubit: _locationBloc,
          listenWhen: (LocationState previous, LocationState current) => current.hasError || current.ready,
          listener: (BuildContext context, LocationState state) => _locationListener(context, state),
          buildWhen: (LocationState previous, LocationState current) => current is CurrentLocationFetchingState,
          builder: (BuildContext context, LocationState state) => _buildMapScreen(context, state)),
    );
  }

  Widget _buildMapScreen(BuildContext context, LocationState state) {
    if (state.hasError) {
      // don't show error page if we don't get user's location
      if (!(state is CurrentLocationFetchingState)) {
        return ErrorPageWidget();
      }
    } else if (state.initial || state.loading) {
      return Center(child: AppCircularProgressIndicator());
    }

    return _renderMapScreen(context);
  }

  Widget _renderMapScreen(BuildContext context) {
    return Stack(
      children: <Widget>[_googleMap(context), _mapControls(context), _centralMarker()],
    );
  }

  Widget _mapControls(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[_searchBar(context), SizedBox(height: 12.0), _buildRadiusSelectionStack()],
              ),
              Container(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Center(child: _buildSubmitButtonListener()),
                      Align(alignment: Alignment.centerRight, child: _floatingActionButton())
                    ],
                  ))
            ]));
  }

  void _animateMapToLocation(LatLng location) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: location, zoom: _getZoomBasedOnRadiusValue()),
    ));
  }

  Widget _googleMap(BuildContext context) {
    return GoogleMap(
      zoomControlsEnabled: false,
      // disable button for my location because it's behind our search bar, make a custom FAB
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(target: _initialCameraPosition, zoom: _initialMapZoom),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      circles: {_centralCircle},
      onCameraMove: (CameraPosition position) {
        setState(() {
          _centralCircle = _centralCircle.copyWith(
            centerParam: position.target,
          );
        });
      },
    );
  }

  Widget _searchBar(BuildContext context) {
    return Material(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        elevation: 8.0,
        child: CustomFormField(
            textStyle: AppTextStyle.style(AppTextStylePattern.body2, color: Palette.primary, fontSizeOffset: 1.0),
            hintText: App.translate("map_screen.search_field.placeholder.text"),
            hintStyle:
                AppTextStyle.style(AppTextStylePattern.body2, color: Palette.secondaryLight, fontSizeOffset: 1.0),
            fillColor: Palette.background,
            borderColor: Palette.background,
            borderRadius: 12.0,
            controller: _searchTextController,
            onTap: () {
              _onSearchBarClicked(); // Mode.fullscreen
            },
            readOnly: true));
  }

  Widget _buildRadiusSelectionStack() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
      _buildRadiusSelectionButton(0),
      SizedBox(width: 12.0),
      _buildRadiusSelectionButton(1),
      SizedBox(width: 12.0),
      _buildRadiusSelectionButton(2),
      SizedBox(width: 12.0),
      _buildRadiusSelectionButton(3)
    ]);
  }

  Widget _buildRadiusSelectionButton(int index) {
    return CustomButton(
      minWidth: 64.0,
      borderRadius: 4.0,
      color: _circleRadius == _radiusValuesMetres[index] ? Palette.secondaryDark : Palette.background,
      content: Text(RADIUS_VALUES_MILES[index].toString() + " " + App.translate("map_screen.distance_button.unit.text"),
          style: AppTextStyle.style(AppTextStylePattern.body2,
              color: _circleRadius == _radiusValuesMetres[index] ? Palette.background : Palette.secondaryLight,
              fontSizeOffset: 1.0)),
      onPressedCallback: () {
        setState(() {
          _circleRadius = _radiusValuesMetres[index];

          _centralCircle = _centralCircle.copyWith(radiusParam: _circleRadius.toDouble());
        });
      },
    );
  }

  /*
    It's better to use fixed marker on screen center,
    otherwise user will have laggy feeling while moving the map,
    same feeling he's facing when moving the circle around marker
  */
  Widget _centralMarker() {
    return Padding(
        /*
          This padding depends on icon size,
          needs that padding to be on equal position as it would be if native google marker follows camera
        */
        padding: EdgeInsets.only(bottom: 44.0),
        child: Center(child: Icon(Icons.location_on, color: Palette.ternaryDark, size: 44.0)));
  }

  void _submitButtonListener(BuildContext context, MunchState state) {
    if (state.hasError) {
      Utility.showErrorFlushbar(state.message, context);
    } else {
      if (state is MunchCreatingState) {
        Munch createdMunch = state.data;

        NavigationHelper.navigateToRestaurantSwipeScreen(
            context,
            munch: createdMunch,
            addToBackStack: false,
            slideTransitionBuilder: NavigationAnimationHelper.rightToLeftAnimation
        );
      }
    }
  }

  Widget _buildSubmitButtonListener() {
    return BlocListener<MunchBloc, MunchState>(
      cubit: _munchBloc,
      listenWhen: (MunchState previous, MunchState current) => current.hasError || current.ready,
      listener: (BuildContext context, MunchState state) => _submitButtonListener(context, state),
      child: !widget.editLocation ? _letsEatButton() : _saveLocationButton(),
    );
  }

  Widget _letsEatButton() {
    return CustomButton<MunchState, MunchCreatingState>.bloc(
      cubit: _munchBloc,
      minWidth: 200.0,
      borderRadius: 12.0,
      padding: EdgeInsets.symmetric(vertical: 16.0),
      color: Palette.secondaryDark,
      textColor: Palette.background,
      content: Text(App.translate("map_screen.lets_eat_button.text"),
          style:
              AppTextStyle.style(AppTextStylePattern.body3Inverse, fontWeight: FontWeight.w600, fontSizeOffset: 1.0)),
      onPressedCallback: () {
        _onLetsEatButtonTapped();
      },
    );
  }

  void _onLetsEatButtonTapped() {
    Munch munch = Munch(
        name: widget.munchName,
        coordinates: Coordinates(latitude: _centralCircle.center.latitude, longitude: _centralCircle.center.longitude),
        radius: _circleRadius);
    _munchBloc.add(CreateMunchEvent(munch));
  }

  Widget _saveLocationButton() {
    return CustomButton(
      minWidth: 200.0,
      borderRadius: 12.0,
      padding: EdgeInsets.symmetric(vertical: 16.0),
      color: Palette.secondaryDark,
      textColor: Palette.background,
      content: Text(App.translate("map_screen.save_location_button.text"),
          style:
              AppTextStyle.style(AppTextStylePattern.body3Inverse, fontWeight: FontWeight.w600, fontSizeOffset: 1.0)),
      onPressedCallback: () {
        Munch munchWithUpdatedLocation;

        Coordinates newCoordinates =
            Coordinates(latitude: _centralCircle.center.latitude, longitude: _centralCircle.center.longitude);

        if (!widget.munch.coordinates.equals(newCoordinates) || widget.munch.radius != _circleRadius) {
          munchWithUpdatedLocation = Munch(coordinates: newCoordinates, radius: _circleRadius);
        }

        return NavigationHelper.popRoute(context, result: munchWithUpdatedLocation);
      },
    );
  }

  Future _onSearchBarClicked() async {
    Prediction prediction = await PlacesAutocomplete.show(
        context: context,
        apiKey: AppConfig.getInstance().googleMapsApiKey,
        mode: Mode.overlay,
        location: Location(_centralCircle.center.latitude, _centralCircle.center.longitude));

    if (prediction != null) {
      PlacesDetailsResponse detail = await MapsRepo.getInstance().getCoordinates(prediction.placeId);

      final lat = detail.coordinates.latitude;
      final lng = detail.coordinates.longitude;

      _animateMapToLocation(LatLng(lat, lng));

      _searchTextController.text = prediction.displayString;
    }
  }
}
