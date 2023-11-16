import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:viswa_todo_app/custom_designs/custom_app_bar.dart';
import 'package:viswa_todo_app/screens/web_socket.dart';
import 'package:web_socket_channel/io.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final channel = IOWebSocketChannel.connect('ws://$wsIP:$wsPORT');
  late Completer<GoogleMapController> _controller;
  late Marker _marker;
  List<LatLng> _polylinePoints = [];
  late LatLng _currentPosition;
  bool _mapLoaded = false;

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
  }

  Future<void> updateMarkerAndPolyline(LatLng newPosition) async {
    final GoogleMapController controller = await _controller.future;

    // Animate the movement over 1 second
    controller.animateCamera(CameraUpdate.newLatLng(newPosition));

    final int steps = 50;
    final double latStep = (newPosition.latitude - _currentPosition.latitude) / steps;
    final double lngStep = (newPosition.longitude - _currentPosition.longitude) / steps;

    for (int i = 1; i <= steps; i++) {
      await Future.delayed(Duration(milliseconds: (2000 / steps).round()));

      setState(() {
        _marker = _marker.copyWith(
          positionParam: LatLng(
            _currentPosition.latitude + i * latStep,
            _currentPosition.longitude + i * lngStep,
          ),
        );

        _polylinePoints.add(_marker.position);
      });
    }

    setState(() {
      _currentPosition = newPosition;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Stack(
      children: [
        buildGoogleMap(),
        if (!_mapLoaded)
          Center(
            child: CircularProgressIndicator(),
          ),
        buildAppBarForMaps("Map with WebSocket")
      ],
    );
  }

  GoogleMap buildGoogleMap() {
    return GoogleMap(
      markers: Set.of([_marker]),
      polylines: buildPolyline(),
      initialCameraPosition: CameraPosition(
        target: _currentPosition,
        zoom: 12.0,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        setState(() {
          _mapLoaded = true;
        });
        startListeningToWebSocket();
      },
    );
  }

  void startListeningToWebSocket() {
    channel.stream.listen(
      (data) {
        if (_mapLoaded) {
          print('Received WebSocket data: $data');
          try {
            Map<String, dynamic> location = jsonDecode(data);
            print('Decoded location: $location');
            updateMarkerAndPolyline(LatLng(location['latitude'], location['longitude']));
          } catch (e) {
            print('Error decoding JSON: $e');
          }
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket channel closed.');
      },
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
