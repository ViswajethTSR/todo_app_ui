import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:viswa_todo_app/app_provider/location_provider.dart';

import 'package:viswa_todo_app/custom_designs/custom_app_bar.dart';

class ProviderMapPage extends StatefulWidget {
  const ProviderMapPage({super.key});

  @override
  State<ProviderMapPage> createState() => _ProviderMapPageState();
}

class _ProviderMapPageState extends State<ProviderMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          buildGoogleMap(),
          buildAppBarForMaps("Maps with Providers"),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context);
        },
        label: Text('Go back'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
    );
  }

  Widget buildGoogleMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(0.0, 0.0),
      ),
    );
  }
}
