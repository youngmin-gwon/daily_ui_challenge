import 'dart:ui';

import 'package:daily_ui/2022/5/9_ninja_fruit/models/gravitational_object.dart';

class Fruit extends GravitationalObject {
  final double width;
  final double height;

  Fruit({
    required Offset position,
    required this.width,
    required this.height,
    double gravitySpeed = 0.0,
    double rotation = 0.0,
    Offset additionalForce = const Offset(0, 0),
  }) : super(
          position: position,
          gravitySpeed: gravitySpeed,
          additionalForce: additionalForce,
          rotation: rotation,
        );

  bool isPointInside(Offset point) {
    if (point.dx < position.dx) {
      return false;
    }

    if (point.dx > position.dx + width) {
      return false;
    }

    if (point.dy < position.dy) {
      return false;
    }

    if (point.dy > position.dy + height) {
      return false;
    }

    return true;
  }
}
