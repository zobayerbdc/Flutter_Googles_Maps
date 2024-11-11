import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? _currentPosition;
  late GoogleMapController _mapController;
  String stAddress = '';
  String stAdd = '';

  Future<void> getCurrentLocations() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    // Request location only if permission is granted
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = currentPosition;
      });
      print("Latitude: " + _currentPosition!.latitude.toString());
      print("Longitude: " + _currentPosition!.longitude.toString());

      // Update the camera position to the current location
      _mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentPosition.latitude, currentPosition.longitude),
          zoom: 14.4746,
        ),
      ));
    }
  }

  static final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(0, 0), // Default to (0,0) until the position is fetched
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(stAddress + "\n" + stAdd),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              await getCurrentLocations(); // Ensure current location is set

              // Check if _currentPosition is available before accessing it
              if (_currentPosition != null) {
                List<Placemark> placemarks = await placemarkFromCoordinates(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                );

                List<Location> locations = await locationFromAddress(
                    "National Parliament House, Dhaka, Bangladesh");

                setState(() {
                  stAddress =
                      "${locations.last.longitude}, ${locations.last.latitude}";
                  stAdd = placemarks.isNotEmpty
                      ? placemarks.last.country ?? ''
                      : '';
                });
              } else {
                // Show error if _currentPosition is null
                setState(() {
                  stAddress = 'Location not available';
                  stAdd = '';
                });
              }
            },
            icon: const Icon(Icons.location_on),
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        mapType: MapType.normal,
        compassEnabled: true,
        myLocationEnabled: true,
        markers: {
          if (_currentPosition != null)
            Marker(
              markerId: const MarkerId('current-location'),
              position: LatLng(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
              ),
              infoWindow: InfoWindow(
                title: 'Current Location',
                snippet:
                    'Lat: ${_currentPosition!.latitude}, Lng: ${_currentPosition!.longitude}',
              ),
            ),
        },
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
          getCurrentLocations(); // Fetch current location when map is created
        },
      ),
    );
  }
}
