// ###########################################################
// #  this is searching location code for tracking section   #
// ##########################################################

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geocoding/geocoding.dart';

// class DistanceFinderScreen extends StatefulWidget {
//   final LatLng initialLocation;

//   DistanceFinderScreen({required this.initialLocation});

//   @override
//   State<DistanceFinderScreen> createState() => _DistanceFinderScreenState();
// }

// class _DistanceFinderScreenState extends State<DistanceFinderScreen> {
//   late GoogleMapController _mapController;
//   LatLng? _searchedLocation;
//   String _distance = '';
//   Set<Polyline> _polylines = {};

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
//     if (_searchedLocation != null) {
//       _polylines.clear();
//       _polylines.add(
//         Polyline(
//           polylineId: PolylineId('line1'),
//           visible: true,
//           points: [
//             widget.initialLocation,
//             _searchedLocation!,
//           ],
//           color: Colors.blue,
//           width: 5,
//         ),
//       );
//     }
//   }

//   void _calculateDistance() {
//     if (_searchedLocation != null) {
//       final double distance = Geolocator.distanceBetween(
//         widget.initialLocation.latitude,
//         widget.initialLocation.longitude,
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
//               initialCameraPosition: CameraPosition(
//                 target: widget.initialLocation,
//                 zoom: 15,
//               ),
//               onMapCreated: (controller) {
//                 _mapController = controller;
//               },
//               polylines: _polylines,
//               markers: {
//                 Marker(
//                   markerId: const MarkerId('initialLocation'),
//                   position: widget.initialLocation,
//                   infoWindow: const InfoWindow(title: 'Initial Location'),
//                 ),
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

// ######################################################
// #  this is moving marker code for tracking section  #
// #####################################################

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geocoding/geocoding.dart';

// class DistanceFinderScreen extends StatefulWidget {
//   final LatLng initialLocation;

//   DistanceFinderScreen({required this.initialLocation});

//   @override
//   State<DistanceFinderScreen> createState() => _DistanceFinderScreenState();
// }

// class _DistanceFinderScreenState extends State<DistanceFinderScreen> {
//   late GoogleMapController _mapController;
//   LatLng? _searchedLocation;
//   LatLng? _currentLocation; // Make _currentLocation nullable
//   String _distance = '';
//   Set<Polyline> _polylines = {};
//   Stream<Position>? _positionStream;

//   @override
//   void initState() {
//     super.initState();
//     _currentLocation =
//         widget.initialLocation; // Initialize with initial location
//     _positionStream = Geolocator.getPositionStream();
//     _positionStream!.listen((Position position) {
//       setState(() {
//         _currentLocation = LatLng(position.latitude, position.longitude);
//         _updateCurrentLocationMarker();
//       });

//       // Print latitude and longitude to debug console
//       print(
//           'Current Position: Latitude: ${position.latitude}, Longitude: ${position.longitude}');
//     });
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
//     if (_searchedLocation != null && _currentLocation != null) {
//       // Check for null
//       _polylines.clear();
//       _polylines.add(
//         Polyline(
//           polylineId: PolylineId('line1'),
//           visible: true,
//           points: [
//             _currentLocation!,
//             _searchedLocation!,
//           ],
//           color: Colors.blue,
//           width: 5,
//         ),
//       );
//     }
//   }

//   void _calculateDistance() {
//     if (_searchedLocation != null && _currentLocation != null) {
//       // Check for null
//       final double distance = Geolocator.distanceBetween(
//         _currentLocation!.latitude,
//         _currentLocation!.longitude,
//         _searchedLocation!.latitude,
//         _searchedLocation!.longitude,
//       );

//       setState(() {
//         _distance = (distance / 1000).toStringAsFixed(2); // Distance in km
//       });
//     }
//   }

//   void _updateCurrentLocationMarker() {
//     if (_mapController != null && _currentLocation != null) {
//       // Check for null
//       _mapController.animateCamera(
//         CameraUpdate.newLatLng(_currentLocation!),
//       );
//     }
//     _drawPolyline(); // Update polyline when the location changes
//     _calculateDistance(); // Recalculate distance as location changes
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
//               initialCameraPosition: CameraPosition(
//                 target: widget.initialLocation,
//                 zoom: 15,
//               ),
//               onMapCreated: (controller) {
//                 _mapController = controller;
//                 _mapController.animateCamera(
//                   CameraUpdate.newLatLng(widget.initialLocation),
//                 );
//               },
//               polylines: _polylines,
//               markers: {
//                 if (_currentLocation != null)
//                   Marker(
//                     markerId: const MarkerId('currentLocation'),
//                     position: _currentLocation!,
//                     infoWindow: const InfoWindow(title: 'Current Location'),
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

// ##########################################################################################
// #  this is moving marker code and show current location user image for tracking section  #
// ##########################################################################################
// import 'dart:ui' as ui;
// import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:flutter/services.dart'
//     show ByteData, Uint8List, rootBundle; // For loading asset images

// class DistanceFinderScreen extends StatefulWidget {
//   final LatLng initialLocation;

//   DistanceFinderScreen({required this.initialLocation});

//   @override
//   State<DistanceFinderScreen> createState() => _DistanceFinderScreenState();
// }

// class _DistanceFinderScreenState extends State<DistanceFinderScreen> {
//   late GoogleMapController _mapController;
//   LatLng? _searchedLocation;
//   LatLng? _currentLocation;
//   String _distance = '';
//   Set<Polyline> _polylines = {};
//   Stream<Position>? _positionStream;
//   BitmapDescriptor? _customMarkerIcon;

//   @override
//   void initState() {
//     super.initState();
//     _currentLocation = widget.initialLocation;
//     _loadCustomMarkerIcon();
//     _positionStream = Geolocator.getPositionStream();
//     _positionStream!.listen((Position position) {
//       setState(() {
//         _currentLocation = LatLng(position.latitude, position.longitude);
//         _updateCurrentLocationMarker();
//       });

//       // Print latitude and longitude to debug console
//       print(
//           'Current Position: Latitude: ${position.latitude}, Longitude: ${position.longitude}');
//     });
//   }

//   // Future<void> _loadCustomMarkerIcon() async {
//   //   final ByteData data = await rootBundle.load('assets/zobayer.png');
//   //   final Uint8List bytes = data.buffer.asUint8List();
//   //   setState(() {
//   //     _customMarkerIcon = BitmapDescriptor.fromBytes(bytes);
//   //   });
//   // }

//   Future<void> _loadCustomMarkerIcon() async {
//     final ByteData data = await rootBundle.load('assets/zobayer.png');
//     final Uint8List bytes = data.buffer.asUint8List();

//     final ui.Codec codec = await ui.instantiateImageCodec(
//       bytes,
//       targetWidth: 80,
//       targetHeight: 80,
//     );
//     final ui.FrameInfo frameInfo = await codec.getNextFrame();
//     final ui.Image image = frameInfo.image;

//     final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
//     final Canvas canvas = Canvas(pictureRecorder);
//     final Paint paint = Paint()..isAntiAlias = true;
//     final double radius = 40.0;

//     canvas.drawCircle(Offset(radius, radius), radius, paint);
//     paint.blendMode = BlendMode.srcIn;
//     canvas.drawImage(image, Offset(0, 0), paint);

//     final ui.Image roundedImage = await pictureRecorder
//         .endRecording()
//         .toImage(80, 80); // Set the final output image size to 80x80
//     final ByteData? roundedBytes =
//         await roundedImage.toByteData(format: ui.ImageByteFormat.png);

//     if (roundedBytes != null) {
//       setState(() {
//         _customMarkerIcon =
//             BitmapDescriptor.fromBytes(roundedBytes.buffer.asUint8List());
//       });
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
//     if (_searchedLocation != null && _currentLocation != null) {
//       // Check for null
//       _polylines.clear();
//       _polylines.add(
//         Polyline(
//           polylineId: PolylineId('line1'),
//           visible: true,
//           points: [
//             _currentLocation!,
//             _searchedLocation!,
//           ],
//           color: Colors.blue,
//           width: 5,
//         ),
//       );
//     }
//   }

//   void _calculateDistance() {
//     if (_searchedLocation != null && _currentLocation != null) {
//       // Check for null
//       final double distance = Geolocator.distanceBetween(
//         _currentLocation!.latitude,
//         _currentLocation!.longitude,
//         _searchedLocation!.latitude,
//         _searchedLocation!.longitude,
//       );

//       setState(() {
//         _distance = (distance / 1000).toStringAsFixed(2); // Distance in km
//       });
//     }
//   }

//   void _updateCurrentLocationMarker() {
//     if (_mapController != null && _currentLocation != null) {
//       // Check for null
//       _mapController.animateCamera(
//         CameraUpdate.newLatLng(_currentLocation!),
//       );
//     }
//     _drawPolyline(); // Update polyline when the location changes
//     _calculateDistance(); // Recalculate distance as location changes
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Find Your Destinations'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
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
//               initialCameraPosition: CameraPosition(
//                 target: widget.initialLocation,
//                 zoom: 15,
//               ),
//               onMapCreated: (controller) {
//                 _mapController = controller;
//                 _mapController.animateCamera(
//                   CameraUpdate.newLatLng(widget.initialLocation),
//                 );
//               },
//               polylines: _polylines,
//               markers: {
//                 if (_currentLocation != null)
//                   Marker(
//                     markerId: const MarkerId('currentLocation'),
//                     position: _currentLocation!,
//                     icon: _customMarkerIcon ??
//                         BitmapDescriptor.defaultMarker, // Set custom icon
//                     infoWindow: const InfoWindow(title: 'Current Location'),
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

// ##########################################################################################
// #  this is moving marker code and show current location user image for tracking section  #
// ##########################################################################################
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/services.dart';

class DistanceFinderScreen extends StatefulWidget {
  final LatLng initialLocation;

  DistanceFinderScreen({required this.initialLocation});

  @override
  State<DistanceFinderScreen> createState() => _DistanceFinderScreenState();
}

class _DistanceFinderScreenState extends State<DistanceFinderScreen> {
  late GoogleMapController _mapController;
  LatLng? _searchedLocation;
  LatLng? _currentLocation;
  String _distance = '';
  Set<Polyline> _polylines = {};
  Stream<Position>? _positionStream;
  BitmapDescriptor? _customMarkerIcon;

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.initialLocation;
    _startLocationUpdates();
    _loadCustomMarkerIcon();
  }

  Future<void> _loadCustomMarkerIcon() async {
    final ByteData data = await rootBundle.load('assets/zobayer.png');
    final Uint8List bytes = data.buffer.asUint8List();

    // Resize and make the image circular
    final ui.Codec codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: 80,
      targetHeight: 80,
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image image = frameInfo.image;

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..isAntiAlias = true;
    final double radius = 40.0;

    // Draw the image as a circular icon
    canvas.drawCircle(Offset(radius, radius), radius, paint);
    paint.blendMode = BlendMode.srcIn;
    canvas.drawImage(image, Offset(0, 0), paint);

    final ui.Image roundedImage =
        await pictureRecorder.endRecording().toImage(80, 80);
    final ByteData? roundedBytes =
        await roundedImage.toByteData(format: ui.ImageByteFormat.png);

    if (roundedBytes != null) {
      setState(() {
        _customMarkerIcon =
            BitmapDescriptor.fromBytes(roundedBytes.buffer.asUint8List());
      });
    }
  }

  Future<void> _startLocationUpdates() async {
    _positionStream = Geolocator.getPositionStream();
    _positionStream!.listen((Position position) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _updateCurrentLocationMarker();
      });

      print(
          'Current Position: Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    });
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
    if (_searchedLocation != null && _currentLocation != null) {
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: PolylineId('route'),
          visible: true,
          points: [
            _currentLocation!,
            _searchedLocation!,
          ],
          color: Colors.blue,
          width: 5,
        ),
      );
    }
  }

  void _calculateDistance() {
    if (_searchedLocation != null && _currentLocation != null) {
      final double distance = Geolocator.distanceBetween(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
        _searchedLocation!.latitude,
        _searchedLocation!.longitude,
      );

      setState(() {
        _distance = (distance / 1000).toStringAsFixed(2); // Distance in km
      });
    }
  }

  void _updateCurrentLocationMarker() {
    if (_mapController != null && _currentLocation != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLng(_currentLocation!),
      );
    }
    _drawPolyline();
    _calculateDistance();
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
                labelText: 'Enter destination',
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
              initialCameraPosition: CameraPosition(
                target: widget.initialLocation,
                zoom: 15,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
                _mapController.animateCamera(
                  CameraUpdate.newLatLng(widget.initialLocation),
                );
              },
              polylines: _polylines,
              markers: {
                if (_currentLocation != null)
                  Marker(
                    markerId: const MarkerId('currentLocation'),
                    position: _currentLocation!,
                    icon: _customMarkerIcon ?? BitmapDescriptor.defaultMarker,
                    infoWindow: const InfoWindow(title: 'Your Location'),
                  ),
                if (_searchedLocation != null)
                  Marker(
                    markerId: const MarkerId('searchedLocation'),
                    position: _searchedLocation!,
                    infoWindow: const InfoWindow(title: 'Destination'),
                  ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
