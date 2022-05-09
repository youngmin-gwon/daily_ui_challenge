import 'dart:ui';

class Fruit {
  final Offset position;
  final double width;
  final double height;

  const Fruit({
    required this.position,
    required this.width,
    required this.height,
  });

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
