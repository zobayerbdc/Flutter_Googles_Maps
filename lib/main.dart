import 'package:flutter/material.dart';
import 'package:flutter_googles_maps/distances.dart';
import 'package:flutter_googles_maps/home_screen.dart';
import 'package:flutter_googles_maps/polygon_area.dart';

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
      home: //const HomeMapScreen(),
          //const HomeScreen(),
          DistanceApp(),
    );
  }
}
