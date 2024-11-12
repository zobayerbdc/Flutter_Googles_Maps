// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geocoding/geocoding.dart';

// class DistanceApp extends StatefulWidget {
//   @override
//   State<DistanceApp> createState() => _DistanceAppState();
// }

// class _DistanceAppState extends State<DistanceApp> {
//   Position? _currentPosition;
//   late GoogleMapController _mapController;
//   LatLng? _searchedLocation;
//   String _distance = '';
//   Set<Polyline> _polylines = {};

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied ||
//         permission == LocationPermission.deniedForever) {
//       permission = await Geolocator.requestPermission();
//     }

//     if (permission == LocationPermission.always ||
//         permission == LocationPermission.whileInUse) {
//       Position currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _currentPosition = currentPosition;
//       });

//       _mapController.animateCamera(CameraUpdate.newLatLng(
//           LatLng(currentPosition.latitude, currentPosition.longitude)));
//     }
//   }

//   Future<void> _searchLocation(String address) async {
//     List<Location> locations = await locationFromAddress(address);
//     if (locations.isNotEmpty) {
//       final location = locations.first;
//       setState(() {
//         _searchedLocation = LatLng(location.latitude, location.longitude);
//         _drawPolyline();
//         _calculateDistance();
//       });

//       _mapController.animateCamera(CameraUpdate.newLatLng(_searchedLocation!));
//     }
//   }

//   void _drawPolyline() {
//     if (_currentPosition != null && _searchedLocation != null) {
//       _polylines.clear();
//       _polylines.add(
//         Polyline(
//           polylineId: PolylineId('line1'),
//           visible: true,
//           points: [
//             LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
//             _searchedLocation!,
//           ],
//           color: Colors.blue,
//           width: 5,
//         ),
//       );
//     }
//   }

//   void _calculateDistance() {
//     if (_currentPosition != null && _searchedLocation != null) {
//       final double distance = Geolocator.distanceBetween(
//         _currentPosition!.latitude,
//         _currentPosition!.longitude,
//         _searchedLocation!.latitude,
//         _searchedLocation!.longitude,
//       );

//       setState(() {
//         _distance = (distance / 1000).toStringAsFixed(2); // Distance in km
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Distance Finder'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               decoration: const InputDecoration(
//                 labelText: 'Enter place',
//                 border: OutlineInputBorder(),
//               ),
//               onSubmitted: (value) => _searchLocation(value),
//             ),
//           ),
//           if (_distance.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 'Distance: $_distance km',
//                 style:
//                     const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//           Expanded(
//             child: GoogleMap(
//               initialCameraPosition: const CameraPosition(
//                 target: LatLng(0, 0),
//                 zoom: 2,
//               ),
//               myLocationEnabled: true,
//               onMapCreated: (controller) {
//                 _mapController = controller;
//                 if (_currentPosition != null) {
//                   _mapController.animateCamera(
//                     CameraUpdate.newLatLng(
//                       LatLng(_currentPosition!.latitude,
//                           _currentPosition!.longitude),
//                     ),
//                   );
//                 }
//               },
//               polylines: _polylines,
//               markers: {
//                 if (_currentPosition != null)
//                   Marker(
//                     markerId: const MarkerId('currentLocation'),
//                     position: LatLng(_currentPosition!.latitude,
//                         _currentPosition!.longitude),
//                     infoWindow: const InfoWindow(title: 'Your Location'),
//                   ),
//                 if (_searchedLocation != null)
//                   Marker(
//                     markerId: const MarkerId('searchedLocation'),
//                     position: _searchedLocation!,
//                     infoWindow: const InfoWindow(title: 'Searched Location'),
//                   ),
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ##############################################################################
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class DistanceApp extends StatefulWidget {
  @override
  State<DistanceApp> createState() => _DistanceAppState();
}

class _DistanceAppState extends State<DistanceApp> {
  Position? _currentPosition;
  late GoogleMapController _mapController;
  LatLng? _searchedLocation;
  String _distance = '';
  Set<Polyline> _polylines = {};
  Stream<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _positionStream = Geolocator.getPositionStream();
    _positionStream!.listen((Position position) {
      setState(() {
        _currentPosition = position;
        _updateCurrentLocationMarker();
      });

      // Print latitude and longitude to debug console
      print(
          'Current Position: Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    });
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = currentPosition;
      });

      _mapController.animateCamera(CameraUpdate.newLatLng(
          LatLng(currentPosition.latitude, currentPosition.longitude)));
    }
  }

  Future<void> _searchLocation(String address) async {
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      final location = locations.first;
      setState(() {
        _searchedLocation = LatLng(location.latitude, location.longitude);
        _drawPolyline();
        _calculateDistance();
      });

      _mapController.animateCamera(CameraUpdate.newLatLng(_searchedLocation!));
    }
  }

  void _drawPolyline() {
    if (_currentPosition != null && _searchedLocation != null) {
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: PolylineId('line1'),
          visible: true,
          points: [
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            _searchedLocation!,
          ],
          color: Colors.blue,
          width: 5,
        ),
      );
    }
  }

  void _calculateDistance() {
    if (_currentPosition != null && _searchedLocation != null) {
      final double distance = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        _searchedLocation!.latitude,
        _searchedLocation!.longitude,
      );

      setState(() {
        _distance = (distance / 1000).toStringAsFixed(2); // Distance in km
      });
    }
  }

  void _updateCurrentLocationMarker() {
    if (_currentPosition != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        ),
      );
    }
    _drawPolyline(); // Update polyline when the location changes
    _calculateDistance(); // Recalculate distance as location changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Distance Finder'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Enter place',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) => _searchLocation(value),
            ),
          ),
          if (_distance.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Distance: $_distance km',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(0, 0),
                zoom: 2,
              ),
              myLocationEnabled: true,
              onMapCreated: (controller) {
                _mapController = controller;
                if (_currentPosition != null) {
                  _mapController.animateCamera(
                    CameraUpdate.newLatLng(
                      LatLng(_currentPosition!.latitude,
                          _currentPosition!.longitude),
                    ),
                  );
                }
              },
              polylines: _polylines,
              markers: {
                if (_currentPosition != null)
                  Marker(
                    markerId: const MarkerId('currentLocation'),
                    position: LatLng(_currentPosition!.latitude,
                        _currentPosition!.longitude),
                    infoWindow: const InfoWindow(title: 'Your Location'),
                  ),
                if (_searchedLocation != null)
                  Marker(
                    markerId: const MarkerId('searchedLocation'),
                    position: _searchedLocation!,
                    infoWindow: const InfoWindow(title: 'Searched Location'),
                  ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
