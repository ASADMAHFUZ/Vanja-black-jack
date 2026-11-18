import 'dart:ui_web' as ui_web;

import 'package:material_ui/material_ui.dart';
import 'package:web/web.dart' as web;

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
  return _WebGoogleMap(
    operatorLat: operatorLat,
    operatorLng: operatorLng,
    propertyLat: propertyLat,
    propertyLng: propertyLng,
    operatorLabel: operatorLabel,
    propertyLabel: propertyLabel,
    stopsAway: stopsAway,
    progress: progress,
    completed: completed,
    borderRadius: borderRadius ?? BorderRadius.circular(20),
  );
}

class _WebGoogleMap extends StatefulWidget {
  final double operatorLat;
  final double operatorLng;
  final double propertyLat;
  final double propertyLng;
  final String operatorLabel;
  final String propertyLabel;
  final int stopsAway;
  final double progress;
  final bool completed;
  final BorderRadius borderRadius;

  const _WebGoogleMap({
    required this.operatorLat,
    required this.operatorLng,
    required this.propertyLat,
    required this.propertyLng,
    required this.operatorLabel,
    required this.propertyLabel,
    required this.stopsAway,
    required this.progress,
    required this.completed,
    required this.borderRadius,
  });

  @override
  State<_WebGoogleMap> createState() => _WebGoogleMapState();
}

class _WebGoogleMapState extends State<_WebGoogleMap> {
  late final String _viewType;
  web.HTMLIFrameElement? _iframe;

  String get _mapUrl {
    if (widget.completed) {
      return 'https://maps.google.com/maps'
          '?q=${widget.propertyLat},${widget.propertyLng}'
          '&z=15&output=embed';
    }
    return 'https://maps.google.com/maps'
        '?saddr=${widget.operatorLat},${widget.operatorLng}'
        '&daddr=${widget.propertyLat},${widget.propertyLng}'
        '&dirflg=d&z=14&output=embed';
  }

  @override
  void initState() {
    super.initState();
    _viewType =
        'bj-google-map-${DateTime.now().microsecondsSinceEpoch}';
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int id) {
      final iframe = web.HTMLIFrameElement()
        ..src = _mapUrl
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allow = 'geolocation; fullscreen'
        ..loading = 'lazy';
      _iframe = iframe;
      return iframe;
    });
  }

  @override
  void didUpdateWidget(covariant _WebGoogleMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    final moved = oldWidget.operatorLat != widget.operatorLat ||
        oldWidget.operatorLng != widget.operatorLng ||
        oldWidget.completed != widget.completed;
    if (moved) {
      _iframe?.src = _mapUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: Stack(
        children: [
          Positioned.fill(
            child: HtmlElementView(viewType: _viewType),
          ),
          Positioned(
            left: 12,
            right: 12,
            top: 12,
            child: IgnorePointer(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.96),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.completed ? Icons.check_circle : Icons.map,
                      size: 16,
                      color: widget.completed
                          ? const Color(0xFF1FA971)
                          : const Color(0xFF1FA89C),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.completed
                            ? 'Google Map · ${widget.propertyLabel} cleared'
                            : 'Google Map · ${widget.operatorLabel} → ${widget.propertyLabel} · ${widget.stopsAway} stops',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 14,
            child: IgnorePointer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: widget.completed ? 1 : widget.progress,
                  minHeight: 8,
                  backgroundColor: Colors.white,
                  color: widget.completed
                      ? const Color(0xFF1FA971)
                      : const Color(0xFF1FA89C),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
