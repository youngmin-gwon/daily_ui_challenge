import 'dart:ui';

class FruitPart {
  final Offset position;
  final double width;
  final double height;
  final bool isLeft;

  const FruitPart({
    required this.position,
    required this.width,
    required this.height,
    required this.isLeft,
  });
}
