import 'package:material_ui/material_ui.dart';
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
  return LiveMapCanvas(
    operatorLabel: operatorLabel,
    propertyLabel: propertyLabel,
    stopsAway: stopsAway,
    progress: progress,
    completed: completed,
    height: null,
    borderRadius: borderRadius ?? BorderRadius.circular(20),
  );
}
