import 'package:flutter/material.dart';
import 'app_bar_clipper.dart';

PreferredSize buildAppBarForNormalPage(String title) {
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
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.purple],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget buildAppBarForMaps(String title) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(40, 70, 40, 0),
    child: Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        shape: BoxShape.rectangle,
        gradient: const LinearGradient(
          colors: [
            Colors.white10,
            Colors.white10,
            Colors.white10,
          ],
        ),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300),
        ],
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Serif',
          ),
        ),
      ),
    ),
  );
}
