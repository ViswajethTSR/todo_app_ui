import 'package:flutter/material.dart';
import 'app_bar_clipper.dart';

PreferredSize buildAppBar(String title) {
  return PreferredSize(
    preferredSize: Size.fromHeight(80.0),
    child: AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: ClipPath(
        clipper: CustomShapeClipper(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.purple],
            ),
          ),
        ),
      ),
    ),
  );
}
