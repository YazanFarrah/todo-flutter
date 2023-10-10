import 'package:flutter/material.dart';

String uri = '10.0.2.2:5000';

class GlobalVariables {
  // COLORS
  static const appBarGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 29, 201, 192),
      Color.fromARGB(255, 153, 214, 212),
    ],
    stops: [0.5, 1.0],
  );

  static const secondaryColor = Color(0xffFCD200);
  static const backgroundColor = Colors.white;
  static const Color greyBackgroundColor = Color(0xffebecee);
}
