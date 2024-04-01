import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_application_1/src/pages/home/matched.dart';
import 'package:flutter_application_1/src/pages/api_service.dart';

class MapsPage extends StatefulWidget {
  final VoidCallback refreshCallback;
  final double desLat;
  final double desLong;

  const MapsPage({Key? key, required this.refreshCallback, required this.desLat, required this.desLong}) : super(key: key);

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late Position userLocation;
  late GoogleMapController mapController;
  final double destinationLatitude = 13.8462142;
  final double destinationLongitude = 100.5685905;
  // final double destinationLatitude = 13.8475694;
  // final double destinationLongitude = 100.5670439;
  final double circleRadius = 100; // Radius of the circle in meters
  bool insideCircle = false;

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

  Future<bool> isUserInsideCircle() async {
    double distance = await Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      widget.desLat,
      widget.desLong,
    );

    // Check if the distance is less than or equal to the radius
    bool insideCircle = distance <= circleRadius;
    print("inside circle = ${insideCircle}");
    return insideCircle;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.desLat);
    print(widget.desLong);
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
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
            return FutureBuilder<bool>(
              future: isUserInsideCircle(),
              builder:
                  (BuildContext context, AsyncSnapshot<bool> circleSnapshot) {
                if (circleSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (circleSnapshot.hasError) {
                  return Center(
                    child: Text('Error: ${circleSnapshot.error}'),
                  );
                } else if (circleSnapshot.hasData) {
                  insideCircle = circleSnapshot.data!;
                  return GoogleMap(
                    mapType: MapType.normal,
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target:
                          LatLng(userLocation.latitude, userLocation.longitude),
                      zoom: 18,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId('destination'),
                        position:
                            LatLng(widget.desLat, widget.desLong),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueGreen),
                      ),
                    },
                    circles: Set.from([
                      Circle(
                        circleId: CircleId('circle'),
                        center:
                            LatLng(widget.desLat, widget.desLong),
                        radius: circleRadius,
                        fillColor: insideCircle
                            ? Colors.green.withOpacity(0.3)
                            : Colors.red.withOpacity(0.3),
                        strokeColor: insideCircle ? Colors.green : Colors.red,
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
          if (insideCircle) {
            print("can check in");
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  title: Text('CHECK IN'),
                  content: Text('Completed'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        checkIn();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        widget.refreshCallback();
                      },
                      style: TextButton.styleFrom(
                        primary: Color(0xFF146001), // Set the text color here
                      ),
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  title: Text('Error'),
                  content: Text('Not in stadium area'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        primary: Color(0xFF146001), // Set the text color here
                      ),
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        },
        label: Text("Check In"),
        icon: Icon(Icons.near_me),
      ),
    );
  }
  void checkIn() async {
    int matchId = 50;
    String userid = globalApiResponse!.userData!['id'];
    String apiUrl = 'http://localhost:3099/checkin';
    print(userid);

    Map<String, dynamic> requestBody = {
      "MatchId" : matchId,
      "userId" : userid
      };

    // Create a FormData object to include text and image data

    try {
      var response = await postApi(apiUrl, requestBody);

      // Handle the API response
      if (response.statusCode == 200) {
        // API call was successful
        print('API Response: ${response.statusCode} ${response.data}');

        // Navigate back to the login page
        Navigator.pop(context);
      } else {
        // API call was not successful
        print('API Response: ${response.statusCode} ${response.data}');

        // Handle other responses or show an error message
        // handleApiError(context, response);
      }
    } catch (error) {
      // Handle errors
      print('Error: $error');
    }
  }
}
