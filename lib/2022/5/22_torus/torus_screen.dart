import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TorusScreen extends StatefulWidget {
  const TorusScreen({Key? key}) : super(key: key);

  @override
  State<TorusScreen> createState() => _TorusScreenState();
}

class _TorusScreenState extends State<TorusScreen>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;

  final time = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    time.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    time.value = elapsed.inMicroseconds / 10e6;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: CustomPaint(
          painter: TorusPainter(time: time),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class TorusPainter extends CustomPainter {
  final ValueListenable<double> time;

  const TorusPainter({
    required this.time,
  }) : super(repaint: time);

  @override
  void paint(Canvas canvas, Size size) {
    const d = 750.0, n = 1420 / 2;

    double t = time.value;
    t *= (2 * math.pi) * 1.5;

    canvas.drawColor(const Color(0xFF000000), BlendMode.srcOver);

    // place it to middle
    canvas.translate((size.width - size.shortestSide) / 2,
        (size.height - size.shortestSide) / 2);

    final scaling = size.shortestSide / d;
    const scaledSize = Size.square(d);
    canvas.scale(scaling);
    canvas.clipRect(Offset.zero & scaledSize);

    canvas.translate(d / 2, d / 2);

    for (var i = 0.0; i < n; i++) {
      canvas.save();
      canvas.scale(11.2, 11.2);
      canvas.rotate(i / n * math.pi * 2);

      _drawPart(canvas, i, t / 2, 0xFFFF0000);
      _drawPart(canvas, i, t / 2 - 1 / 50, 0xFF00FF00);
      _drawPart(canvas, i, t / 2 - 2 / 50, 0xFF0000FF);
      canvas.restore();
    }
  }

  void _drawPart(Canvas canvas, double i, double t, int color) {
    final a = i + t * 4;
    final w = math.cos(a) * 2;
    canvas.drawOval(
      Rect.fromLTWH(20 + 9 * math.sin(a), -math.cos(i + t) * math.sin(t) * 12,
          w, w > 0 ? 2 : 0),
      Paint()
        ..blendMode = BlendMode.plus
        ..color = Color(0xFFFFFFFF & color),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
