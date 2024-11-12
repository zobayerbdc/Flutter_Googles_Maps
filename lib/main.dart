import 'package:flutter/material.dart';
import 'package:flutter_googles_maps/tracking_section_two/location_picker_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Google Maps',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: //DistanceApp(),
          LocationPickerScreen(),
      //TrackingApp(),
      //GetLatLng(),
      //HomeScreen(),
      //PolygonArea(),
    );
  }
}
