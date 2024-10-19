import 'package:callandgo/helpers/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapWidget extends StatefulWidget {
   var polyLineEncodedList; // Accept a list of polyline encoded strings

  MapWidget({required this.polyLineEncodedList});

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    List<LatLng> allPolylinePoints = [];
    List<Polyline> polylines = [];

    // Decode all polylines and add to map
    for (int i = 0; i < widget.polyLineEncodedList.length; i++) {
      List<LatLng> polylinePoints = decodePolyline(widget.polyLineEncodedList[i]);
      allPolylinePoints.addAll(polylinePoints); // Add all points to the combined list
      polylines.add(Polyline(
        polylineId: PolylineId('route_$i'),
        color: ColorHelper.primaryColor,
        width: 2,
        points: polylinePoints,
      ));
    }

    // Calculate bounds to fit all polylines
    LatLngBounds bounds = calculateBounds(allPolylinePoints);
    LatLng center = LatLng(
      (bounds.southwest.latitude + bounds.northeast.latitude) / 2,
      (bounds.southwest.longitude + bounds.northeast.longitude) / 2,
    );

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: center, // Center of all polylines
        zoom: calculateZoomLevel(bounds), // Adjusted zoom level
      ),
      onMapCreated: (controller) {
        _mapController = controller;
        _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 5)); // Animate to fit bounds
      },
      polylines: Set<Polyline>.of(polylines), // Set of polylines
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      mapType: MapType.normal,
    );
  }

  List<LatLng> decodePolyline(String encoded) {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> points = polylinePoints.decodePolyline(encoded);
    return points.map((point) => LatLng(point.latitude, point.longitude)).toList();
  }

  LatLngBounds calculateBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (var point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  double calculateZoomLevel(LatLngBounds bounds) {
    double latDiff = bounds.northeast.latitude - bounds.southwest.latitude;
    double lngDiff = bounds.northeast.longitude - bounds.southwest.longitude;

    double maxDiff = latDiff > lngDiff ? latDiff : lngDiff;

    // Adjusting zoom levels for 3X more zoom-in
    if (maxDiff < 0.001) return 21; // Extremely small bounds
    if (maxDiff < 0.01) return 19;  // Very zoomed-in
    if (maxDiff < 0.05) return 17;  // Zoom in for shorter routes
    if (maxDiff < 0.1) return 15;   // Closer zoom for short routes
    if (maxDiff < 0.5) return 13;   // Standard zoom
    return 11;                      // Default for long routes
  }
}
