import 'package:flutter/material.dart';
import 'package:viswa_todo_app/custom_designs/custom_app_bar.dart';

class PraticePage extends StatefulWidget {
  const PraticePage({super.key});

  @override
  State<PraticePage> createState() => _PraticePageState();
}

class _PraticePageState extends State<PraticePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("ProviderPractices"),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [],
              ),
            )
          ],
        ),
      ),
    );
  }
}
