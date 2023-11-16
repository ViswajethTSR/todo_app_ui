import 'package:flutter/material.dart';
import 'package:viswa_todo_app/custom_designs/custom_app_bar.dart';

class ProviderMapPage extends StatefulWidget {
  const ProviderMapPage({super.key});

  @override
  State<ProviderMapPage> createState() => _ProviderMapPageState();
}

class _ProviderMapPageState extends State<ProviderMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: buildAppBar('ProviderMapPage'));
  }
}
