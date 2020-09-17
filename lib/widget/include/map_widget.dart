import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  String munchName;

  MapWidget({this.munchName});

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  Completer<GoogleMapController> _controller = Completer();
  int _selectedIndex = 0;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.calendar_today),
              color: Colors.black,
              onPressed: () {},
            ),
          ],
          backgroundColor: Colors.white,
          title:
              Text("Choose a location",
                  style: TextStyle(color: Colors.black)
              )
      ),
      body: Stack(
        children: <Widget>[
            _buildGoogleMap(context),
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            _buildSearchBarStack(),
            _buildRadiusSelectionStack()
          ]),
          _buildLetsEatButton()
          ],
        ),
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        backgroundColor: Colors.white,
        onPressed: () {},
        child: Icon(
          Icons.my_location,
          color: Colors.blueAccent
        )
      ),
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(40.712776, -74.005974), zoom: 12),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {
          newyork1Marker,
          newyork2Marker,
          newyork3Marker,
          gramercyMarker,
          bernardinMarker,
          blueMarker
        },
      ),
    );
  }

  Widget _buildSearchBarStack() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Stack(children: <Widget>[
          Container(
            child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(20.0),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search a location"),
                )),
          )
        ]));
  }

  Widget _buildRadiusSelectionStack() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildRadiusSelectionButton("0.5 mi"),
              _buildRadiusSelectionButton("1 mi"),
              _buildRadiusSelectionButton("2 mi")
            ]));
  }

  Widget _buildRadiusSelectionButton(String distance) {
    return FlatButton(
      color: Colors.white,
      onPressed: () {},
      child: Text(distance),
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 30),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)
      )
    );
  }

  Widget _buildLocationButton() {
    return IconButton(
        icon: Icon(Icons.android), color: Colors.white, onPressed: () {});
  }

  Widget _buildLetsEatButton() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
            padding: EdgeInsets.only(bottom: 18),
            child: FlatButton(
              color: Colors.redAccent,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 80.0),
              splashColor: Colors.blue,
              onPressed: () {},
              child: Text(
                "Lets Eat!",
                style: TextStyle(fontSize: 16.0),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)
              )
            )
        )
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 15,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }

  Marker gramercyMarker = Marker(
    markerId: MarkerId('gramercy'),
    position: LatLng(40.738380, -73.988426),
    infoWindow: InfoWindow(title: 'Gramercy Tavern'),
    icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueRed,
    ),
  );

  Marker bernardinMarker = Marker(
    markerId: MarkerId('bernardin'),
    position: LatLng(40.761421, -73.981667),
    infoWindow: InfoWindow(title: 'Le Bernardin'),
    icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueRed,
    ),
  );
  Marker blueMarker = Marker(
    markerId: MarkerId('bluehill'),
    position: LatLng(40.732128, -73.999619),
    infoWindow: InfoWindow(title: 'Blue Hill'),
    icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueRed,
    ),
  );

//New York Marker

  Marker newyork1Marker = Marker(
    markerId: MarkerId('newyork1'),
    position: LatLng(40.742451, -74.005959),
    infoWindow: InfoWindow(title: 'Los Tacos'),
    icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueRed,
    ),
  );
  Marker newyork2Marker = Marker(
    markerId: MarkerId('newyork2'),
    position: LatLng(40.729640, -73.983510),
    infoWindow: InfoWindow(title: 'Tree Bistro'),
    icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueRed,
    ),
  );
  Marker newyork3Marker = Marker(
    markerId: MarkerId('newyork3'),
    position: LatLng(40.719109, -74.000183),
    infoWindow: InfoWindow(title: 'Le Coucou'),
    icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueRed,
    ),
  );
}
