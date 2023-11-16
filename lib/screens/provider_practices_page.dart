import 'package:flutter/material.dart';
import 'package:viswa_todo_app/custom_designs/custom_app_bar.dart';
import 'package:viswa_todo_app/provider_screens/provider_websocket_page.dart';

import '../provider_screens/provider_map_page.dart';

class ProviderPracticesPage extends StatefulWidget {
  const ProviderPracticesPage({super.key});

  @override
  State<ProviderPracticesPage> createState() => _ProviderPracticesPageState();
}

class _ProviderPracticesPageState extends State<ProviderPracticesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("Provider Practices"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildNavigationPageButton(context, ProviderWebSocketPage(), 'Open WebSocketPage'),
            buildNavigationPageButton(context, ProviderMapPage(), 'Open MapPage'),
          ],
        ),
      ),
    );
  }

  Widget buildNavigationPageButton(BuildContext context, Widget pageName, String title) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => pageName,
          ),
        );
      },
      child: Container(
        height: 100,
        width: 130,
        decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.purple],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                blurStyle: BlurStyle.normal,
                blurRadius: 5,
              )
            ]),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
