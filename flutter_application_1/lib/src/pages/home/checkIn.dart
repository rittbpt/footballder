import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Page'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(0.0, 0.0), // Initial map location (can be updated later)
          zoom: 15.0, // Initial zoom level
        ),
        markers: Set<Marker>.of([
          Marker(
            markerId: MarkerId('current-location'),
            position: LatLng(0.0, 0.0), // Current location coordinates
            infoWindow: InfoWindow(title: 'Current Location'),
          ),
        ]),
      ),
    );
  }
}
