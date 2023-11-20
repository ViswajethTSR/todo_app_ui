import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viswa_todo_app/app_provider/location_provider.dart';
import 'package:viswa_todo_app/app_provider/map_provider.dart';
import 'package:viswa_todo_app/provider_screens/todo_provider_page.dart';
import 'package:viswa_todo_app/screens/map_screen.dart';
import 'package:viswa_todo_app/screens/provider_practices_page.dart';
import 'package:viswa_todo_app/screens/todo.dart';
import 'package:viswa_todo_app/screens/web_socket.dart';

import 'app_provider/todo_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MapProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TodoProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    TodoProviderPage(),
    WebSocket(),
    MapPage(),
    const ProviderPracticesPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 20,
        enableFeedback: true,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: "Todo "),
          BottomNavigationBarItem(icon: Icon(Icons.webhook), label: "Websocket"),
          BottomNavigationBarItem(icon: Icon(Icons.place_sharp), label: "Maps"),
          BottomNavigationBarItem(icon: Icon(Icons.cyclone), label: "ProviderPractice"),
        ],
        unselectedItemColor: Colors.purple.shade300,
        selectedItemColor: Colors.purple.shade700,
      ),
    );
  }
}
