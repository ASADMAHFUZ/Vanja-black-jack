import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_ui/material_ui.dart';
import '../config/maps_config.dart';
import 'live_map_canvas.dart';

Widget buildGoogleMapPanel({
  required double operatorLat,
  required double operatorLng,
  required double propertyLat,
  required double propertyLng,
  required String operatorLabel,
  required String propertyLabel,
  required int stopsAway,
  required double progress,
  required bool completed,
  BorderRadius? borderRadius,
}) {
  final radius = borderRadius ?? BorderRadius.circular(20);

  if (!MapsConfig.hasApiKey) {
    return LiveMapCanvas(
      operatorLabel: operatorLabel,
      propertyLabel: propertyLabel,
      stopsAway: stopsAway,
      progress: progress,
      completed: completed,
      height: null,
      borderRadius: radius,
    );
  }

  final property = LatLng(propertyLat, propertyLng);
  final operator = LatLng(operatorLat, operatorLng);

  return ClipRRect(
    borderRadius: radius,
    child: GoogleMap(
      initialCameraPosition: CameraPosition(
        target: completed ? property : operator,
        zoom: 14.2,
      ),
      myLocationButtonEnabled: false,
      compassEnabled: true,
      zoomControlsEnabled: false,
      markers: {
        Marker(
          markerId: const MarkerId('property'),
          position: property,
          infoWindow: InfoWindow(title: propertyLabel),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            completed ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueOrange,
          ),
        ),
        if (!completed)
          Marker(
            markerId: const MarkerId('operator'),
            position: operator,
            infoWindow: InfoWindow(title: operatorLabel),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
          ),
      },
      polylines: {
        if (!completed)
          Polyline(
            polylineId: const PolylineId('route'),
            color: const Color(0xFF1FA89C),
            width: 4,
            points: [operator, property],
          ),
      },
    ),
  );
}
