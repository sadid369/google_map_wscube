import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  double lat = 0;
  double lon = 0;
  late Position position;
  Position? position1;

  @override
  void initState() {
    super.initState();
    getPosition();
  }

  void getPosition() async {
    position = await _determinePosition();
    lat = position.latitude;
    lon = position.longitude;
    setState(() {});
  }

  void myAddress(double lat, double lng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    print(placemarks);
  }

  @override
  Widget build(BuildContext context) {
    var initPos = CameraPosition(target: LatLng(lat, lon), zoom: 8);
    return Scaffold(
      body: GoogleMap(
        circles: {
          Circle(
            circleId: CircleId('Home_circle'),
            center: LatLng(lat, lon),
            fillColor: Colors.blue.withOpacity(0.4),
            radius: 10,
            strokeWidth: 0,
          )
        },
        mapType: MapType.hybrid,
        // polylines: {Polyline(polylineId: PolylineId('1'))},
        onMapCreated: (mController) {
          _controller.complete(mController);
        },
        onTap: (latLng) {
          // print(
          //     "Taped Location La:t: ${latLng.latitude} Lon: ${latLng.longitude}");
          // lat = latLng.latitude;
          // lon = latLng.longitude;

          // setState(() {});
          // myAddress(lat, lon);
        },
        initialCameraPosition: initPos,
        markers: {
          Marker(
            infoWindow: InfoWindow(title: 'My Home'),
            markerId: MarkerId('1'),
            position: LatLng(22.6909078, 90.3562809),
            onTap: () {
              print('Taped on Marker');
            },
          ),
          Marker(
            infoWindow: InfoWindow(title: 'Current Location'),
            markerId: MarkerId('2'),
            position: LatLng(lat, lon),
            onTap: () {
              print('Taped on Marker');
              myAddress(lat, lon);
            },
          ),
        },
        myLocationEnabled: true,
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // position1 = await Geolocator.getCurrentPosition();
    // List<Placemark> placemarks = await placemarkFromCoordinates(
    //     position1!.latitude, position1!.longitude);
    // print(placemarks);
    // print(placemarks[0].locality);
    // print(placemarks[0].country);
    return await Geolocator.getCurrentPosition();
  }
}
