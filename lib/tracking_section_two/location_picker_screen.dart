// import 'package:flutter/material.dart';
// import 'package:flutter_googles_maps/tracking_section_two/distance_finder_screen.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class LocationPickerScreen extends StatefulWidget {
//   @override
//   State<LocationPickerScreen> createState() => _LocationPickerScreenState();
// }

// class _LocationPickerScreenState extends State<LocationPickerScreen> {
//   LatLng _pickedLocation = LatLng(0, 0);
//   late GoogleMapController _mapController;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCurrentLocation();
//   }

//   Future<void> _initializeCurrentLocation() async {
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
//         _pickedLocation =
//             LatLng(currentPosition.latitude, currentPosition.longitude);
//       });

//       _mapController.animateCamera(CameraUpdate.newLatLng(_pickedLocation));
//     }
//   }

//   void _onMapTapped(LatLng location) {
//     setState(() {
//       _pickedLocation = location;
//     });
//   }

//   void _onConfirmLocation() {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => DistanceFinderScreen(
//           initialLocation: _pickedLocation,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Pick Your Location'),
//       ),
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: _pickedLocation,
//               zoom: 15,
//             ),
//             onMapCreated: (controller) {
//               _mapController = controller;
//             },
//             markers: {
//               Marker(
//                 markerId: const MarkerId('pickedLocation'),
//                 position: _pickedLocation,
//                 draggable: true,
//                 onDragEnd: (newPosition) => setState(() {
//                   _pickedLocation = newPosition;
//                 }),
//               ),
//             },
//             onTap: _onMapTapped,
//           ),
//           Positioned(
//             bottom: 20,
//             left: 20,
//             right: 20,
//             child: ElevatedButton(
//               onPressed: _onConfirmLocation,
//               child: const Text('Confirm Location'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// #########################################################
// #  current location get and send it destination screen  #
// #########################################################
import 'package:flutter/material.dart';
import 'package:flutter_googles_maps/tracking_section_two/distance_finder_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerScreen extends StatefulWidget {
  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng _pickedLocation = LatLng(0, 0);
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _initializeCurrentLocation();
  }

  Future<void> _initializeCurrentLocation() async {
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
        _pickedLocation =
            LatLng(currentPosition.latitude, currentPosition.longitude);
      });

      _mapController.animateCamera(CameraUpdate.newLatLng(_pickedLocation));
    }
  }

  void _onMapTapped(LatLng location) {
    setState(() {
      _pickedLocation = location;
    });
  }

  void _onConfirmLocation() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DistanceFinderScreen(
          initialLocation: _pickedLocation,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Your Location'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _pickedLocation,
              zoom: 15,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: {
              Marker(
                markerId: const MarkerId('pickedLocation'),
                position: _pickedLocation,
                draggable: true,
                onDragEnd: (newPosition) => setState(() {
                  _pickedLocation = newPosition;
                }),
              ),
            },
            onTap: _onMapTapped,
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _onConfirmLocation,
              child: const Text('Confirm Location'),
            ),
          ),
        ],
      ),
    );
  }
}
