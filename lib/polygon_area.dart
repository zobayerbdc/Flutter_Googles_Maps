import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolygonArea extends StatefulWidget {
  const PolygonArea({super.key});

  @override
  State<PolygonArea> createState() => _PolygonAreaState();
}

class _PolygonAreaState extends State<PolygonArea> {
  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(23.751677, 90.436032), zoom: 14.4746);

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLine = {};

  List<LatLng> points = [
    LatLng(23.751677, 90.436032),
    // LatLng(23.751559, 90.420754),
    // LatLng(23.744959, 90.436719),
    LatLng(23.743506, 90.424703),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _polygons.add(
    //   Polygon(
    //     polygonId: PolygonId('1'),
    //     points: points,
    //     fillColor: Colors.red.withOpacity(0.5),
    //     strokeWidth: 4,
    //     strokeColor: Colors.green,
    //   ),
    // );
    for (int i = 0; i < points.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: points[i],
          infoWindow: InfoWindow(title: 'Marker $i'),
        ),
      );
      setState(() {});
      _polyLine.add(
        Polyline(
          polylineId: PolylineId('1'),
          points: points,
          color: const Color.fromARGB(255, 102, 255, 0),
          width: 4,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polygon Area'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        polylines: _polyLine,
        mapType: MapType.normal,
        markers: _markers,
        compassEnabled: true,
        myLocationButtonEnabled: true,
        myLocationEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
