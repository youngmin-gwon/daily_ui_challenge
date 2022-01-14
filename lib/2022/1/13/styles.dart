import 'package:flutter/material.dart';

class AppColors {
  static Color orangeAccent = const Color(0xFFF1A35D);
  static Color orangeAccentLight = const Color(0xFFFF7F33);
  static Color redAccent = const Color(0xFFF1A35D);
  static Color grey = const Color(0xFF4D4D4D);
}

class Styles {
  static TextStyle text(double size, Color color, bool bold, {double? height}) {
    return TextStyle(
      fontSize: size,
      color: color,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      height: height,
      package: "drink_rewards_list",
    );
  }
}
