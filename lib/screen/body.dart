import 'dart:async';
import 'package:mua/services/data.dart';
import 'package:mua/services/cordinate_cal.dart';
import 'places_info.dart';
import 'direction_time.dart';
import 'location_botton.dart';
import 'searchbar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_controller/google_maps_controller.dart';

String googleApiKey = 'AIzaSyBkDzDscbwtGtK9Py_vAj5BCRaLDhx2Xjc';
const int durationSeconds = 500;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showSearchBar = true;
  String searchText = 'Search here';
  IconData icon = Icons.error;
  String _cordinateDistance = '';
  String _cordinateTime = '';
  PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  static double _zoomValue = 18;
  Position currentPosition;
  Widget _myAnimatedWidget = BuildFloatingActionButton();
  bool _notChanged = true;
  bool _markerTap = true;
  Set<Marker> _markers = {};
  GoogleMapsController _controller;
  Completer<GoogleMapController> _completer = Completer();
  CameraPosition _initialCameraPosition = CameraPosition(
      target: LatLng(5.142935, 6.831361), zoom: _zoomValue, tilt: 10);

  void onMapCreated(GoogleMapController controller) {
    _completer.complete(controller);
    controller = controller;
  }

  void _getCurrentLocation() async {
    Position _geolocator = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    GoogleMapController _animateControl = await _completer.future;

    setState(() {
      currentPosition = _geolocator;
      _animateControl.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(_geolocator.latitude, _geolocator.longitude),
              zoom: _zoomValue)));
    });
  }

  Future<void> _createPolylines(
      LatLng start, LatLng destination, String mode) async {
    PolylineResult result;
    polylinePoints = PolylinePoints();
    double totalDistance = 0.0;
    double totalTime = 0.0;
    const averagePersonSpeed = 1.36;
    const averageKekeSpeed = 11;
    const convertKiloMeter = 1000;
    Polyline polyline;
    IconData modeIcon;

    if (mode == 'walking') {
      result = await polylinePoints.getRouteBetweenCoordinates(
          googleApiKey,
          PointLatLng(start.latitude, start.longitude),
          PointLatLng(destination.latitude, destination.longitude),
          travelMode: TravelMode.walking);
    } else if (mode == 'keke') {
      result = await polylinePoints.getRouteBetweenCoordinates(
          googleApiKey,
          PointLatLng(start.latitude, start.longitude),
          PointLatLng(destination.latitude, destination.longitude),
          travelMode: TravelMode.driving);
    }

    polylineCoordinates.clear();
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng points) {
        polylineCoordinates.add(LatLng(points.latitude, points.longitude));
      });
    }

    PolylineId id = PolylineId('poly');

    if (mode == 'walking') {
      polyline = Polyline(
          polylineId: id,
          color: Colors.blue,
          points: polylineCoordinates,
          patterns: [PatternItem.dot],
          width: 6);
    } else if (mode == 'keke') {
      polyline = Polyline(
          polylineId: id,
          color: Colors.blue,
          points: polylineCoordinates,
          width: 7);
    }

    polylines[id] = polyline;
    _controller.addPolyline(polyline);

// Calculating the total distance by adding the distance
// between small segments
    for (int i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += cordinateDistance(
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
        polylineCoordinates[i + 1].latitude,
        polylineCoordinates[i + 1].longitude,
      );
    }

    //Calculating the total time
    if (mode == 'walking') {
      totalTime =
          ((totalDistance * convertKiloMeter) / averagePersonSpeed) / 60;
      modeIcon = Icons.directions_walk;
    } else if (mode == 'keke') {
      totalTime = ((totalDistance * convertKiloMeter) / averageKekeSpeed) / 60;
      modeIcon = Icons.directions_car;
    }
// Storing the calculated total distance of the route
    setState(() {
      _cordinateDistance = totalDistance.toStringAsFixed(2);
      _cordinateTime = totalTime.toStringAsFixed(0);
      icon = modeIcon;
    });
  }

  void changeWidget() {
    setState(() {
      showSearchBar = !showSearchBar;
      _markerTap = !_markerTap;
      _myAnimatedWidget = _notChanged
          ? DirectionTimer(
              press: putMarkers,
              time: _cordinateTime,
              distance: _cordinateDistance,
              icon: icon)
          : BuildFloatingActionButton(press: _getCurrentLocation);
      _notChanged = !_notChanged;
    });
  }

  Future<void> animateNormal() async {
    GoogleMapController _animateControl = await _completer.future;
    _animateControl
        .animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition));
  }

  Future<void> animateDirection() async {
    GoogleMapController _animateControl = await _completer.future;
    _animateControl.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(currentPosition.latitude, currentPosition.longitude),
        zoom: 18)));
  }

  void getDirection(
      LatLng start, LatLng destination, String text, String mode) async {
    await _createPolylines(start, destination, mode);
    animateDirection();
    changeWidget();
    _controller.removeMarkers(_markers.where((element) {
      return element.markerId.value != text;
    }).toList());
    Navigator.of(context).pop();
  }

  Widget button(BuildContext context, LatLng start, LatLng destination,
      String mode, String text) {
    return Container(
      height: 40,
      width: 130,
      child: RaisedButton(
          child: Text(
            mode,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            getDirection(start, destination, text, mode);
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          color: Colors.blue),
    );
  }

  void putMarkers() {
    changeWidget();
    placeMarkers();
    _controller.addMarkers(_markers.toList());
    animateNormal();
    _controller.removePolylines(polylines.values.toList());
  }

  void showSearchPage(BuildContext context, DataSearch searchDelegate) async {
    GoogleMapController _animateControl = await _completer.future;
    final String selected =
        await showSearch(context: context, delegate: searchDelegate);

    if (selected != null) {
      for (var info in data) {
        if (info.title == selected) {
          setState(() {
            searchText = selected;
          });
          _animateControl.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: info.position, zoom: _zoomValue)));
        }
      }
    }
  }

  void placeMarkers() {
    for (Database info in data) {
      Marker marker = Marker(
          visible: _markerTap ? true : false,
          markerId: MarkerId(info.title),
          onTap: _markerTap
              ? () {
                  Scaffold.of(context).showBottomSheet((context) {
                    return PlacesInfo(
                      title: info.title,
                      button1: button(
                          context,
                          LatLng(currentPosition.latitude,
                              currentPosition.longitude),
                          info.position,
                          'walking',
                          info.title),
                      button2: button(
                          context,
                          LatLng(currentPosition.latitude,
                              currentPosition.longitude),
                          info.position,
                          'keke',
                          info.title),
                    );
                  });
                }
              : null,
          position: info.position,
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: info.title));
      _markers.add(marker);
    }
  }

  @override
  void initState() {
    super.initState();
    placeMarkers();
    _getCurrentLocation();
    _controller = GoogleMapsController(
        mapToolbarEnabled: false,
        myLocationButtonEnabled: false,
        buildingsEnabled: true,
        padding: EdgeInsets.only(top: 30),
        initialPolylines: Set<Polyline>.of(polylines.values),
        myLocationEnabled: true,
        zoomControlsEnabled: false,
        mapType: MapType.satellite,
        onMapCreated: onMapCreated,
        initialMarkers: _markers,
        initialCameraPosition: _initialCameraPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        GoogleMaps(controller: _controller),
        AnimatedPositioned(
            top: showSearchBar ? 30 : -100,
            left: 0,
            right: 0,
            duration: Duration(milliseconds: durationSeconds),
            child: SearchBar(
              function: () {
                showSearchPage(context, DataSearch());
              },
              text: searchText,
            )),
        Positioned(
          bottom: 0,
          right: 0,
          child: AnimatedSwitcher(
              duration: Duration(milliseconds: durationSeconds),
              child: _myAnimatedWidget),
        )
      ],
    ));
  }
}

class DirectionButton extends StatelessWidget {
  const DirectionButton(
      {Key key, @required this.function, @required this.title})
      : super(key: key);

  final Function function;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 130,
      child: RaisedButton(
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: function,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          color: Colors.blue),
    );
  }
}
