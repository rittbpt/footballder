import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late Position userLocation;
  late GoogleMapController mapController;
  final double destinationLatitude = 37.785834;
  final double destinationLongitude = -122.406417;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<Position> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied, we cannot request permissions.';
    }

    userLocation = await Geolocator.getCurrentPosition();
    return userLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Google Maps'),
      ),
      body: FutureBuilder(
        future: _getLocation(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return GoogleMap(
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(userLocation.latitude, userLocation.longitude),
                zoom: 7,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('destination'),
                  position: LatLng(destinationLatitude, destinationLongitude),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor
                      .hueGreen), 
                ),
              },
              circles: Set.from([
                Circle(
                  circleId: CircleId('circle'),
                  center: LatLng(destinationLatitude, destinationLongitude),
                  radius:
                      1000, 
                  fillColor: Colors.green.withOpacity(0.3), 
                  strokeColor: Colors.green, 
                  strokeWidth: 2, 
                ),
              ]),
            );
          } else {
            return Center(
              child: Text('No data available.'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          mapController.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(userLocation.latitude, userLocation.longitude),
              18,
            ),
          );
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                  'Your location has been sent!\nlat: ${userLocation.latitude} long: ${userLocation.longitude}',
                ),
              );
            },
          );
        },
        label: Text("Send Location"),
        icon: Icon(Icons.near_me),
      ),
    );
  }
}
