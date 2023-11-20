import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:web_socket_channel/io.dart';
import 'package:provider/provider.dart';

import 'package:viswa_todo_app/app_provider/map_provider.dart';

import '../custom_designs/custom_app_bar.dart';
import '../screens/web_socket.dart';

final channel = IOWebSocketChannel.connect('ws://$wsIP:$wsPORT');

class ProviderMapPage extends StatefulWidget {
  @override
  _ProviderMapPageState createState() => _ProviderMapPageState();
}

class _ProviderMapPageState extends State<ProviderMapPage> {
  late MapProvider _mapProvider;
  final IOWebSocketChannel channel = IOWebSocketChannel.connect('ws://$wsIP:$wsPORT');

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MapProvider(),
      child: Scaffold(
        appBar: null,
        body: Stack(
          children: [
            MapContent(channel: channel),
            Consumer<MapProvider>(
              builder: (context, model, child) {
                if (!model.isMapLoaded) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return SizedBox.shrink();
              },
            ),
            buildAppBarForMaps("Provider Map Page"),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 65, 0, 0),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mapProvider = Provider.of<MapProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _mapProvider.dispose(); // Dispose resources in MapProvider
    channel.sink.close();
    super.dispose();
  }
}

class MapContent extends StatelessWidget {
  final IOWebSocketChannel channel;

  MapContent({required this.channel});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MapProvider>(context);

    return GoogleMap(
      markers: Set.of([model.marker]),
      polylines: model.buildPolyline(),
      initialCameraPosition: CameraPosition(
        target: model.currentPosition,
        zoom: 12.0,
      ),
      onMapCreated: (GoogleMapController controller) {
        model.controller.complete(controller);
        model.setMapLoaded();
        startListeningToWebSocket(model, channel);
      },
    );
  }

  void startListeningToWebSocket(MapProvider model, IOWebSocketChannel channel) {
    channel.stream.listen(
      (data) {
        if (model.isMapLoaded) {
          print('Received WebSocket data: $data');
          try {
            Map<String, dynamic> location = jsonDecode(data);
            print('Decoded location: $location');
            model.updateMarkerAndPolyline(LatLng(location['latitude'], location['longitude']));
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
}
