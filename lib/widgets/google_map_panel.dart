import 'package:material_ui/material_ui.dart';

import 'google_map_panel_stub.dart'
    if (dart.library.html) 'google_map_panel_web.dart'
    if (dart.library.io) 'google_map_panel_io.dart' as impl;

class GoogleMapPanel extends StatelessWidget {
  final double operatorLat;
  final double operatorLng;
  final double propertyLat;
  final double propertyLng;
  final String operatorLabel;
  final String propertyLabel;
  final int stopsAway;
  final double progress;
  final bool completed;
  final BorderRadius? borderRadius;

  const GoogleMapPanel({
    super.key,
    required this.operatorLat,
    required this.operatorLng,
    required this.propertyLat,
    required this.propertyLng,
    required this.operatorLabel,
    required this.propertyLabel,
    required this.stopsAway,
    required this.progress,
    required this.completed,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return impl.buildGoogleMapPanel(
      operatorLat: operatorLat,
      operatorLng: operatorLng,
      propertyLat: propertyLat,
      propertyLng: propertyLng,
      operatorLabel: operatorLabel,
      propertyLabel: propertyLabel,
      stopsAway: stopsAway,
      progress: progress,
      completed: completed,
      borderRadius: borderRadius,
    );
  }
}
