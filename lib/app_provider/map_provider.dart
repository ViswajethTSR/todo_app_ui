import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapProvider extends ChangeNotifier {
  late Completer<GoogleMapController> _controller;
  late Marker _marker;
  List<LatLng> _polylinePoints = [];
  late LatLng _currentPosition;
  bool _mapLoaded = false;

  MapProvider() {
    _controller = Completer();
    _currentPosition = LatLng(21.1458, 79.0882);
    _marker = Marker(
      markerId: MarkerId('1'),
      position: _currentPosition,
      infoWindow: InfoWindow(title: 'Marker'),
    );
  }

  Future<void> updateMarkerAndPolyline(LatLng newPosition) async {
    final GoogleMapController controller = await _controller.future;

    // Animate the movement over 2 seconds
    controller.animateCamera(CameraUpdate.newLatLng(newPosition));

    final int steps = 50;
    final double latStep = (newPosition.latitude - _currentPosition.latitude) / steps;
    final double lngStep = (newPosition.longitude - _currentPosition.longitude) / steps;

    for (int i = 1; i <= steps; i++) {
      await Future.delayed(Duration(milliseconds: (2000 / steps).round()));

      _marker = _marker.copyWith(
        positionParam: LatLng(
          _currentPosition.latitude + i * latStep,
          _currentPosition.longitude + i * lngStep,
        ),
      );

      _polylinePoints.add(_marker.position);
      notifyListeners();
    }

    _currentPosition = newPosition;
    notifyListeners();
  }

  Set<Polyline> buildPolyline() {
    if (_polylinePoints.length < 2) {
      return Set();
    }

    return {
      Polyline(
        polylineId: PolylineId('polyline'),
        color: Colors.blue,
        width: 5,
        points: _polylinePoints,
      )
    };
  }

  void setMapLoaded() {
    _mapLoaded = true;
    notifyListeners();
  }

  bool get isMapLoaded => _mapLoaded;

  Marker get marker => _marker;

  LatLng get currentPosition => _currentPosition;

  Completer<GoogleMapController> get controller => _controller;
}
