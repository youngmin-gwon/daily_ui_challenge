import 'dart:ui';

abstract class GravitationalObject {
  Offset position;
  double gravitySpeed;
  double rotation;
  Offset additionalForce;
  final _gravity = 1.0;

  GravitationalObject({
    required this.position,
    required this.rotation,
    this.gravitySpeed = 0.0,
    this.additionalForce = const Offset(0, 0),
  });

  void applyGravity() {
    gravitySpeed += _gravity;
    position = Offset(
      position.dx + additionalForce.dx,
      position.dy + gravitySpeed + additionalForce.dy,
    );
  }
}
