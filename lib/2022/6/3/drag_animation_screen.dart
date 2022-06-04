import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DragAnimationScreen extends StatefulWidget {
  const DragAnimationScreen({Key? key}) : super(key: key);

  @override
  State<DragAnimationScreen> createState() => _DragAnimationScreenState();
}

class _DragAnimationScreenState extends State<DragAnimationScreen>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late math.Random _random;

  List<StickyPoint> points = [];

  @override
  void initState() {
    super.initState();
    _random = math.Random();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    setState(() {
      for (var i = 0; i < points.length; i++) {
        points[i].shrink();

        if (points[i].radius <= 0) {
          points.removeAt(i);
        }
      }
    });
  }

  void _updatePointsToTouch(ScaleUpdateDetails details) {
    setState(() {
      points.add(
        StickyPoint(
          center: details.localFocalPoint,
          radius: ui.lerpDouble(300, 500, _random.nextDouble())!,
          declineSpeed: ui.lerpDouble(3, 10, _random.nextDouble())!,
          randomness: Offset.lerp(
              const Offset(-1, -1), const Offset(1, 1), _random.nextDouble())!,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          _buildBackground(),
          _buildPaint(),
          _buildGestureDetector(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.yellow,
            Colors.amber,
            Colors.orange,
            Colors.red,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        backgroundBlendMode: BlendMode.dstOver,
      ),
    );
  }

  Widget _buildPaint() {
    return CustomPaint(
      size: Size.infinite,
      painter: DotsPainter(
        points: points,
      ),
    );
  }

  Widget _buildGestureDetector() {
    return GestureDetector(
      onScaleUpdate: _updatePointsToTouch,
    );
  }
}

class DotsPainter extends CustomPainter {
  final List<StickyPoint> points;
  final List<Color> _colors = [];
  final List<double> _stops = [];

  static const _shaderResolution = 0x1ffe;

  DotsPainter({
    required this.points,
  });

  final _paint = Paint()
    ..color = Colors.white
    ..blendMode = BlendMode.srcOver
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(Colors.black, BlendMode.srcOver);

    if (_colors.isEmpty) {
      assert(_stops.isEmpty);
      _colors.addAll(
        [
          for (var i = _shaderResolution; i >= 0; i--)
            Color.fromRGBO(
              0xff,
              0xff,
              0xff,
              const Cubic(1, 0, 0, 1)
                  .transform(math.pow(i / _shaderResolution, 2).toDouble()),
            ),
        ],
      );

      _stops.addAll(
        [
          for (var i = 0; i < _shaderResolution + 1; i++)
            math.pow(i / _shaderResolution, 2).toDouble(),
        ],
      );
    }

    if (points.isNotEmpty) {
      for (final point in points) {
        final shader =
            ui.Gradient.radial(point.center, point.radius, _colors, _stops);

        canvas.drawCircle(
          point.center,
          point.radius,
          _paint
            ..blendMode = ui.BlendMode.plus
            ..shader = shader,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class StickyPoint {
  Offset center;
  double radius;
  final double declineSpeed;
  final Offset randomness;

  StickyPoint({
    required this.center,
    required this.radius,
    required this.declineSpeed,
    required this.randomness,
  });

  void shrink() {
    center += randomness;
    radius -= declineSpeed;
  }
}
