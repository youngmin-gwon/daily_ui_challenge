import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class MovingGradationScreen extends StatefulWidget {
  const MovingGradationScreen({Key? key}) : super(key: key);

  @override
  State<MovingGradationScreen> createState() => _MovingGradationScreenState();
}

class _MovingGradationScreenState extends State<MovingGradationScreen>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;

  final _blobs = <_Blob>[];

  static final _random = math.Random();

  static const List<Color> _colors = [
    Color.fromRGBO(45, 74, 227, 1),
    Color.fromRGBO(250, 255, 89, 1),
    Color.fromRGBO(255, 104, 248, 1),
    Color.fromRGBO(44, 209, 252, 1),
    Color.fromRGBO(54, 233, 84, 1),
  ];

  static const _blobCount = 20, _blobSpeed = 4.0;
  static const _minRadius = 400.0, _maxRadius = 900.0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var i = 0; i < _blobCount; i++) {
        _blobs.add(
          _Blob(
            offset: Offset(
              _random.nextDouble() * MediaQuery.of(context).size.width,
              _random.nextDouble() * MediaQuery.of(context).size.height,
            ),
            velocity: Offset.fromDirection(
                _random.nextDouble() * math.pi * 2, _blobSpeed),
            minRadius: _minRadius,
            maxRadius: _maxRadius,
            color: _colors[i % _colors.length],
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsedDuration) {
    setState(() {
      for (var blob in _blobs) {
        blob.move(MediaQuery.of(context).size);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: CustomPaint(
        painter: MovingGradientPainter(
          blobs: _blobs,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class MovingGradientPainter extends CustomPainter {
  final List<_Blob> blobs;

  const MovingGradientPainter({
    required this.blobs,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // canvas.drawRect(
    //     Rect.fromLTWH(
    //       0,
    //       0,
    //       size.width,
    //       size.height,
    //     ),
    //     Paint()..color = Colors.black);
    for (var blob in blobs) {
      final shader = ui.Gradient.radial(
        blob.offset,
        blob.radius,
        [
          blob.color,
          blob.color.withOpacity(0),
        ],
        [
          0.01,
          1,
        ],
      );
      canvas.drawCircle(
        blob.offset,
        blob.radius,
        Paint()
          ..color = blob.color
          ..shader = shader
          ..blendMode = ui.BlendMode.saturation,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _Blob {
  Offset offset;
  Offset velocity;

  final double minRadius;
  final double maxRadius;
  final Color color;

  static final _random = math.Random();

  double _sinValue = _random.nextDouble();

  late double _radius;
  double get radius => _radius;

  _Blob({
    required this.offset,
    required this.velocity,
    required this.minRadius,
    required this.maxRadius,
    required this.color,
  }) {
    _radius = getRadius(_sinValue);
  }

  double getRadius(double value) {
    return minRadius + (maxRadius - minRadius) * math.sin(value).abs();
  }

  void move(Size screenSize) {
    // 너무 먼경우
    // if ((screenSize.width - offset.dx).abs() >= velocity.distance) {
    //   offset = Offset(screenSize.width / 2, screenSize.height / 2);
    //   velocity = Offset(-velocity.dx, velocity.dy);
    // }

    // if ((screenSize.height - offset.dy).abs() >= velocity.distance) {
    //   offset = Offset(screenSize.width / 2, screenSize.height / 2);
    // }

    _sinValue += 0.01;

    _radius = getRadius(_sinValue);

    if (offset.dx <= 0 || offset.dx >= screenSize.width) {
      velocity = Offset(-velocity.dx, velocity.dy);
    }

    if (offset.dy <= 0 || offset.dy >= screenSize.height) {
      velocity = Offset(velocity.dx, -velocity.dy);
    }

    offset += velocity;
  }
}
