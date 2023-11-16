import 'package:flutter/material.dart';

class ProviderPractices extends ChangeNotifier {
  double _latitude = 21.1458;
  double _longitude = 79.0882;
  final List<String> messages = [];
  double get latitude => _latitude;
  double get longitude => _longitude;

  void updateLocation(double lat, double lng) {
    _latitude = lat;
    _longitude = lng;
    notifyListeners();
  }

  void updateLocationFromWebSocket(dynamic data) {
    double lat = data['latitude'] ?? 0.0;
    double lng = data['longitude'] ?? 0.0;
    messages.add("Latitude:${data['latitude']},Longitude:${data['longitude']}");
    updateLocation(lat, lng);
    notifyListeners();
  }
}
