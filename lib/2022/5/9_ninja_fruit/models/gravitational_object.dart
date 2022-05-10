import 'dart:ui';

abstract class GravitationalObject {
  Offset position;
  double gravitySpeed;
  Offset additionalForce;
  double _gravity = 1.0;

  GravitationalObject({
    required this.position,
    this.gravitySpeed = 0.0,
    this.additionalForce = const Offset(0, 0),
  });

  void applyGravity() {
    gravitySpeed += _gravity;
    position = Offset(
      position.dx + additionalForce.dx,
      position.dy + additionalForce.dy,
    );
  }
}
