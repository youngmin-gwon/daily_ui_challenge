import 'package:flutter/material.dart';

class DrawnLine {
  final List<Offset?> path;
  final Color color;
  final double width;

  const DrawnLine(this.path, this.color, this.width);
}
