import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class BackgroundShaderScreen extends StatefulWidget {
  const BackgroundShaderScreen({Key? key}) : super(key: key);

  @override
  State<BackgroundShaderScreen> createState() => _BackgroundShaderScreenState();
}

class _BackgroundShaderScreenState extends State<BackgroundShaderScreen>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late math.Random _random;

  final _points = <MetaballPoint>[];

  @override
  void initState() {
    super.initState();

    _ticker = createTicker(_onTick)..start();
    _random = math.Random();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    if (_points.isNotEmpty) {
      setState(() {
        for (var i = 0; i < _points.length; i++) {
          _points[i].shrink();
          if (_points[i].radius <= 0) {
            _points.removeAt(i);
          }
        }
      });
    }
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _points.add(
        MetaballPoint(
          center: details.localFocalPoint,
          radius: ui.lerpDouble(50, 150, _random.nextDouble())!,
          velocity: Offset(
            ui.lerpDouble(-2, 2, _random.nextDouble())!,
            ui.lerpDouble(-2, 2, _random.nextDouble())!,
          ),
          declineSpeed: ui.lerpDouble(2.2, 2.5, _random.nextDouble())!,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            CustomPaint(
              size: Size.infinite,
              painter: BackgroundShaderPainter(
                points: _points,
              ),
            ),
            GestureDetector(
              onScaleUpdate: _onScaleUpdate,
            ),
          ],
        ),
      ),
    );
  }
}

class BackgroundShaderPainter extends CustomPainter {
  static final double devicePixelRatio = ui.window.devicePixelRatio;

  final List<MetaballPoint> points;

  const BackgroundShaderPainter({
    required this.points,
  });

  static const backgroundPattern = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.red,
    ],
  );

  @override
  void paint(Canvas canvas, Size size) {
    final shader = backgroundPattern.createShader(
      Rect.fromLTWH(0, 0, size.width, size.height),
    );

    final innerPaint = Paint()..blendMode = ui.BlendMode.dstOut
        // ..colorFilter = ui.ColorFilter.mode(Colors.black, ui.BlendMode.plus)
        // ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 10)
        // ..imageFilter = ui.ImageFilter.blur(sigmaX: 13, sigmaY: 13)
        // ..colorFilter = ui.ColorFilter.matrix(
        //   [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 20, -1200],
        // );
        ;

    if (points.isNotEmpty) {
      for (var point in points) {
        canvas.drawCircle(
          point.center,
          point.radius,
          innerPaint,
          // Paint()
          //   ..color = Colors.white
          //   ..style = ui.PaintingStyle.stroke
          //   ..strokeWidth = 2
        );
      }

      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()
          ..shader = shader
          ..blendMode = ui.BlendMode.dstOver,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MetaballPoint {
  MetaballPoint({
    required this.center,
    required this.radius,
    required this.velocity,
    required this.declineSpeed,
  });

  Offset center;
  double radius;
  final Offset velocity;
  final double declineSpeed;

  void shrink() {
    center += velocity;
    radius -= declineSpeed;
  }
}
