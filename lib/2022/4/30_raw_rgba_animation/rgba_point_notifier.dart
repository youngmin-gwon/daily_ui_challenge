import 'dart:math' as math;
import 'package:daily_ui/2022/4/30_raw_rgba_animation/rgba_settings.dart';
import 'package:flutter/material.dart';

class RgbaPointNotifier with ChangeNotifier {
  List<Point> _points = [];
  bool _isReady = false;

  List<Point> get points => _points;
  bool get isReady => _isReady;

  void setPoints(List<Point> points) => _points = points;

  void setIsReady(bool isReady) {
    _isReady = isReady;
    notifyListeners();
  }
}

class Point {
  final Offset offset;
  late final double sizeFactor;
  late final Color color;
  late final double startDelay;

  Point({
    required this.offset,
    required int alfa,
    required int speed,
  }) {
    sizeFactor = alfa / 255;

    color = Colors.primaries[math.Random().nextInt(Colors.primaries.length)];
    startDelay = math.Random().nextDouble() * kMax - speed;
  }
}
