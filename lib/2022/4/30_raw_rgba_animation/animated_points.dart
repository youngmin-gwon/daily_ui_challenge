import 'package:daily_ui/2022/4/30_raw_rgba_animation/rgba_point_scope.dart';
import 'package:daily_ui/2022/4/30_raw_rgba_animation/rgba_setttings_scope.dart';
import 'package:flutter/material.dart';

import 'package:daily_ui/2022/4/30_raw_rgba_animation/rgba_point_notifier.dart';
import 'package:daily_ui/2022/4/30_raw_rgba_animation/rgba_settings.dart';

class AnimatedPoints extends StatefulWidget {
  const AnimatedPoints({Key? key}) : super(key: key);

  @override
  State<AnimatedPoints> createState() => _AnimatedPointsState();
}

class _AnimatedPointsState extends State<AnimatedPoints>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      lowerBound: 0.0,
      upperBound: 1000.0,
      vsync: this,
      duration: const Duration(seconds: 1000),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: MediaQuery.of(context).size.width,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return CustomPaint(
            painter: PointPainter(
              points: RgbaPointScope.of(context).points,
              animationValue: _controller.value,
              settings: RgbaSettingsScope.of(context),
            ),
          );
        },
      ),
    );
  }
}

class PointPainter extends CustomPainter {
  final List<Point> points;
  final double animationValue;
  final RgbaSettings settings;

  const PointPainter({
    required this.points,
    required this.animationValue,
    required this.settings,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..style = PaintingStyle.fill;
    for (var point in points) {
      paint.color = point.color;
      // print(point.startDelay);
      if (animationValue >= point.startDelay) {
        var animationFactor =
            ((animationValue - point.startDelay) * settings.speed % kMax / kMax)
                .abs();

        var size = settings.size * point.sizeFactor * animationFactor;
        canvas.drawCircle(
          point.offset,
          size,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
