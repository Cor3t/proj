import 'dart:async';
import 'package:mua/services/data.dart';
import 'package:mua/services/cordinate_cal.dart';
import 'places_info.dart';
import 'direction_time.dart';
import 'location_botton.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_controller/google_maps_controller.dart';

String googleApiKey = 'AIzaSyBkDzDscbwtGtK9Py_vAj5BCRaLDhx2Xjc';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _cordinateDistance = '';
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

  Future<void> _createPolylines(LatLng start, LatLng destination) async {
    polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey,
        PointLatLng(start.latitude, start.longitude),
        PointLatLng(destination.latitude, destination.longitude),
        travelMode: TravelMode.walking);

    polylineCoordinates.clear();
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng points) {
        polylineCoordinates.add(LatLng(points.latitude, points.longitude));
      });
    }

    PolylineId id = PolylineId('poly');

    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blue,
        points: polylineCoordinates,
        width: 6);

    polylines[id] = polyline;
    _controller.addPolyline(polyline);

    double totalDistance = 0.0;

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

// Storing the calculated total distance of the route
    setState(() {
      _cordinateDistance = totalDistance.toStringAsFixed(2);
      print('DISTANCE: $_cordinateDistance km');
    });
  }

  void changeWidget() {
    setState(() {
      _markerTap = !_markerTap;
      _myAnimatedWidget = _notChanged
          ? DirectionTimer(press: putMarkers, text: _cordinateDistance)
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

  RaisedButton directionButton(String title, LatLng destination) {
    return RaisedButton(
        child: Text(
          'Direction',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () async {
          await _createPolylines(
              LatLng(currentPosition.latitude, currentPosition.longitude),
              destination);
          animateDirection();
          changeWidget();
          _controller.removeMarkers(_markers.where((element) {
            return element.markerId.value != title;
          }).toList());
          Navigator.of(context).pop();
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        color: Colors.blue);
  }

  void putMarkers() {
    changeWidget();
    placeMarkers();
    _controller.addMarkers(_markers.toList());
    animateNormal();
    _controller.removePolylines(polylines.values.toList());
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
                        press: changeWidget,
                        button: directionButton(info.title, info.position));
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
        Positioned(
          bottom: 0,
          right: 0,
          child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500), child: _myAnimatedWidget),
        )
      ],
    ));
  }
}
