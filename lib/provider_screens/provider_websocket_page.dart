import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viswa_todo_app/app_provider/location_provider.dart';
import 'package:viswa_todo_app/custom_designs/custom_app_bar.dart';
import 'package:viswa_todo_app/screens/web_socket.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ProviderWebSocketPage extends StatefulWidget {
  @override
  _ProviderWebSocketPageState createState() => _ProviderWebSocketPageState();
}

class _ProviderWebSocketPageState extends State<ProviderWebSocketPage> {
  final WebSocketChannel channel = IOWebSocketChannel.connect('ws://$wsIP:$wsPORT');

  @override
  void initState() {
    super.initState();

    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    locationProvider.messages = [];
    channel.stream.listen((data) {
      try {
        Map<String, dynamic> location = jsonDecode(data);
        locationProvider.updateLocationFromWebSocket(location);
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    channel.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);

    return Scaffold(
      appBar: buildAppBarForNormalPage("ProviderWebSocketPage"),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: locationProvider.messages.length,
                itemBuilder: (BuildContext context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 5,
                      child: ListTile(
                        title: Text(locationProvider.messages[index] as String),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(locationProvider.messages.isEmpty ? 'Connecting...' : 'Received Messages:'),
            ),
          ],
        ),
      ),
    );
  }
}
