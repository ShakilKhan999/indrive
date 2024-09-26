import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../../helpers/color_helper.dart';

class ProgressStack extends StatefulWidget {
  final LatLng start; // Starting point
  final LatLng destination; // Destination point

  ProgressStack({required this.start, required this.destination});

  @override
  _ProgressStackState createState() => _ProgressStackState();
}

class _ProgressStackState extends State<ProgressStack> {
  double progress = 0.0; // Progress value
  double totalDistance = 0.0; // Total distance
  Position? currentLocation; // Current location

  @override
  void initState() {
    super.initState();
    // Calculate the total distance initially
    totalDistance = calculateDistance(widget.start, widget.destination);
    // Start location updates
    _startLocationUpdates();
  }

  double calculateDistance(LatLng start, LatLng end) {
    // Haversine formula to calculate distance between two LatLng points
    var R = 6371; // Radius of the Earth in kilometers
    var dLat = (end.latitude - start.latitude) * (3.141592653589793 / 180);
    var dLon = (end.longitude - start.longitude) * (3.141592653589793 / 180);

    var a =
        (sin(dLat / 2) * sin(dLat / 2)) +
            (cos(start.latitude * (3.141592653589793 / 180)) * cos(end.latitude * (3.141592653589793 / 180)) *
                (sin(dLon / 2) * sin(dLon / 2)));
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c; // Distance in kilometers
  }

  void _startLocationUpdates() {
    Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        currentLocation = position;
        // Calculate current distance to the destination
        double currentDistance = calculateDistance(
          LatLng(currentLocation!.latitude, currentLocation!.longitude),
          widget.destination,
        );
        // Update progress value based on remaining distance
        progress = ((totalDistance - currentDistance) / totalDistance).clamp(0.0, 1.0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double progressBarWidth = MediaQuery.of(context).size.width; // Full width of the screen
    double imagePosition = progress * progressBarWidth; // Horizontal position of the image

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        SizedBox(
          height: 60.h,
        ),
        Container(
          width: double.infinity,
          height: 10.0,
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.lightBlueAccent,
            valueColor: AlwaysStoppedAnimation<Color>(
              ColorHelper.primaryColor,
            ),
          ),
        ),
        Positioned(
          left: imagePosition -25.w,
          top: 5.h , // Adjusting image position to move down as progress increases
          child: Image.asset(
            'assets/images/car.png',
            width: 50.w,
            height: 50.h,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Dispose resources if needed
    super.dispose();
  }
}
