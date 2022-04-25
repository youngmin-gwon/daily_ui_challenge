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
  WaveGroup waveGroup = WaveGroup(width: 0, height: 0);

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tickDraw)..start();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      size = MediaQuery.of(context).size;
      waveGroup.width = size.width;
      waveGroup.height = size.height;
      waveGroup.init();
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _tickDraw(Duration elapsedTime) {
    setState(() {
      waveGroup.draw();
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
        painter: _WavePainter(waveGroup: waveGroup),
        size: Size.infinite,
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final WaveGroup waveGroup;

  static final _dotPaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.fill;

  const _WavePainter({
    required this.waveGroup,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    var prevX = waveGroup.waves[0].points[0].x;
    var prevY = waveGroup.waves[0].points[0].y;
    path.lineTo(prevX, prevY);
    for (var i = 1; i < waveGroup.waves[0].totalPoints; i++) {
      final centerX = waveGroup.waves[0].points[i].x;
      final centerY = waveGroup.waves[0].points[i].y;

      // canvas.drawCircle(Offset(centerX, centerY), 20, _dotPaint);

      prevX = waveGroup.waves[0].points[i].x;
      prevY = waveGroup.waves[0].points[i].y;
      path.quadraticBezierTo(prevX, prevY, centerX, centerY);
    }
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, Paint()..color = waveGroup.colors[0]);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return true;
  }
}

class WaveGroup {
  final int totalWaves = 3;
  final int totalPoints = 6;

  double width;
  double height;

  final List<Color> colors = const [
    Color.fromRGBO(0, 199, 255, 0.4),
    Color.fromRGBO(0, 144, 199, 0.4),
    Color.fromRGBO(0, 87, 158, 0.4),
  ];

  late List<Wave> waves;

  WaveGroup({
    required this.width,
    required this.height,
  });

  void init() {
    waves = [];
    for (var i = 0; i < totalWaves; i++) {
      final wave = Wave(
        width: width,
        height: height,
        totalPoints: totalPoints,
      );
      waves.add(wave);
    }

    resize(width, height);
  }

  void resize(double width, double height) {
    for (var i = 0; i < totalWaves; i++) {
      waves[i].resize(width, height);
    }
  }

  void draw() {
    for (var i = 0; i < totalWaves; i++) {
      waves[i].draw();
    }
  }
}

class Wave {
  final double width;
  final double height;
  final int totalPoints;
  List<Point> points = [];

  late double pointGap;

  Wave({
    required this.width,
    required this.height,
    required this.totalPoints,
  }) {
    resize(width, height);
  }

  double get centerX => width / 2;
  double get centerY => height / 2;

  void init() {
    for (var i = 0; i < totalPoints; i++) {
      final point = Point(x: pointGap * i, y: centerY, index: i + 1);
      points.add(point);
    }
  }

  void resize(double width, double height) {
    pointGap = width / (totalPoints - 1);

    init();
  }

  void draw() {
    for (var i = 0; i < totalPoints; i++) {
      if (i > 0 && i < totalPoints - 1) {
        points[i].update();
      }
    }
  }
}

class Point {
  double x;
  double y;
  double speed = 0.1;

  double cur = 0;
  late double max;

  late double fixedY;

  Point({
    required this.x,
    required this.y,
    required int index,
  }) {
    fixedY = y;
    cur = index.toDouble();
    max = 120;
  }

  void update() {
    cur += speed;
    y = fixedY + math.sin(cur) * max;
  }
}
