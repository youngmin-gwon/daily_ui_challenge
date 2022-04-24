import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class WaveAnimationScreen extends StatefulWidget {
  const WaveAnimationScreen({Key? key}) : super(key: key);

  @override
  State<WaveAnimationScreen> createState() => _WaveAnimationScreenState();
}

class _WaveAnimationScreenState extends State<WaveAnimationScreen>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late Size size;
  // init
  Wave wave = Wave(width: 0, height: 0);

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tickDraw)..start();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      size = MediaQuery.of(context).size;
      wave = Wave(width: size.width, height: size.height);
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _tickDraw(Duration elapsedTime) {
    setState(() {
      wave.draw();
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: CustomPaint(
        painter: _WavePainter(wave: wave),
        size: Size.infinite,
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final Wave wave;

  static final _dotPaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.fill;

  const _WavePainter({
    required this.wave,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromCenter(
          center: Offset(wave.point.x, wave.point.y), width: 20, height: 20),
      _dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return true;
  }
}

class WaveGroup {
  final int totalWaves = 3;
  final int totalPoints = 6;
}

class Wave {
  final double width;
  final double height;

  late Point point;

  Wave({
    required this.width,
    required this.height,
  }) {
    init();
  }

  double get centerX => width / 2;
  double get centerY => height / 2;

  void init() {
    point = Point(x: centerX, y: centerY);
  }

  void draw() {
    point.update();
  }
}

class Point {
  double x;
  double y;
  double speed = 0.1;

  double cur = 0;
  double max = _random.nextDouble() * 100 + 150;

  static final _random = math.Random();

  late double fixedY;

  Point({
    required this.x,
    required this.y,
  }) {
    fixedY = y;
  }

  void update() {
    cur += speed;
    y = fixedY + math.sin(cur) * max;
  }
}
