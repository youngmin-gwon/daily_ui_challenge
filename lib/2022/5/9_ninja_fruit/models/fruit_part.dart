import 'dart:ui';

import 'package:daily_ui/2022/5/9_ninja_fruit/models/gravitational_object.dart';

class FruitPart extends GravitationalObject {
  final double width;
  final double height;
  final bool isLeft;

  FruitPart({
    required Offset position,
    required this.width,
    required this.height,
    required this.isLeft,
    double gravitySpeed = 0.0,
    double rotation = 0.0,
    Offset additionalForce = const Offset(0, 0),
  }) : super(
          position: position,
          gravitySpeed: gravitySpeed,
          additionalForce: additionalForce,
          rotation: rotation,
        );
}
