import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:viswa_todo_app/screens/web_socket.dart';
import 'package:web_socket_channel/io.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../custom_designs/app_bar_clipper.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final channel = IOWebSocketChannel.connect('ws://$wsIP:$wsPORT');
  late Completer<GoogleMapController> _controller;
  late Marker _marker;
  late LatLng _currentPosition;

  @override
  void initState() {
    super.initState();
    _controller = Completer();
    _currentPosition = LatLng(21.1458, 79.0882);
    _marker = Marker(
      markerId: MarkerId('1'),
      position: _currentPosition,
      infoWindow: InfoWindow(title: 'Marker'),
    );

    channel.stream.listen((data) {
      // Parse received JSON data
      Map<String, dynamic> location = jsonDecode(data);

      // Move the marker smoothly to the new position
      moveMarkerToPosition(LatLng(location['latitude'], location['longitude']));
    });
  }

  void moveMarkerToPosition(LatLng newPosition) async {
    // Animate the movement over 1 second
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: newPosition,
        zoom: 15.0,
      ),
    ));

    final int steps = 100;
    final double latStep =
        (newPosition.latitude - _currentPosition.latitude) / steps;
    final double lngStep =
        (newPosition.longitude - _currentPosition.longitude) / steps;

    for (int i = 1; i <= steps; i++) {
      await Future.delayed(Duration(milliseconds: (1000 / steps).round()));

      setState(() {
        _marker = _marker.copyWith(
          positionParam: LatLng(
            _currentPosition.latitude + i * latStep,
            _currentPosition.longitude + i * lngStep,
          ),
        );
      });
    }

    setState(() {
      _currentPosition = newPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  GoogleMap buildBody() {
    return GoogleMap(
      // mapType: MapType.satellite,
      markers: Set.of([_marker]),
      initialCameraPosition: CameraPosition(
        target: _currentPosition,
        zoom: 12.0,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  PreferredSize buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: AppBar(
        title: Text('Maps with WebSocket'),
        centerTitle: true,
        backgroundColor: Colors.blue, // Set your desired background color
        // elevation: 0, // Remove the shadow below the app bar
        flexibleSpace: ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
