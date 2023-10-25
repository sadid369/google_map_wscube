import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double lat = 0;
  double lon = 0;
  late Position position;
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

  @override
  Widget build(BuildContext context) {
    var initPos = CameraPosition(target: LatLng(lat, lon), zoom: 8);
    return Scaffold(
      body: GoogleMap(
        // polylines: {Polyline(polylineId: PolylineId('1'))},
        onTap: (latLng) {
          // print(
          //     "Taped Location La:t: ${latLng.latitude} Lon: ${latLng.longitude}");
          // lat = latLng.latitude;
          // lon = latLng.longitude;

          // setState(() {});
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

    return await Geolocator.getCurrentPosition();
  }
}
