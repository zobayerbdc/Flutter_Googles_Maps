import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomeMapScreen extends StatefulWidget {
  const HomeMapScreen({super.key});

  @override
  State<HomeMapScreen> createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMapScreen> {
  Position? _currentPosition;

  getCurrentLocations() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    } else {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = currentPosition;
      });
      print("Latitude: " + currentPosition.latitude.toString());
      print("Longitude: " + currentPosition.longitude.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Map Screen'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                getCurrentLocations();
              },
              child: const Text('Get Location'),
            ),
            if (_currentPosition != null)
              Text(
                  'Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}'),
          ],
        ),
      ),
    );
  }
}
