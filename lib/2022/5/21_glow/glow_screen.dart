import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class GlowScreen extends StatefulWidget {
  const GlowScreen({Key? key}) : super(key: key);

  @override
  State<GlowScreen> createState() => _GlowScreenState();
}

class _GlowScreenState extends State<GlowScreen>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;

  late ValueNotifier<double> _time;

  @override
  void initState() {
    super.initState();
    _time = ValueNotifier(0);
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _time.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    _time.value = elapsed.inMicroseconds / 1e6;
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
          size: Size.infinite,
          painter: GlowPainter(
            time: _time,
          ),
        ),
      ),
    );
  }
}

class GlowPainter extends CustomPainter {
  final ValueListenable<double> time;

  const GlowPainter({
    required this.time,
  }) : super(repaint: time);

  @override
  void paint(Canvas canvas, Size size) {
    var t = time.value;
    t /= 2;
    t *= math.pi / 2;
    canvas.drawColor(const Color(0xFF000000), BlendMode.srcOver);
    const d = 750.0, r = d / 2.1;

    // place it to middle
    canvas.translate((size.width - size.shortestSide) / 2,
        (size.height - size.shortestSide) / 2);

    final scaling = size.shortestSide / d;
    const scaledSize = Size.square(d);
    canvas.scale(scaling);
    canvas.clipRect(Offset.zero & scaledSize);

    canvas.translate(d / 2, d / 2);
    const n = 5;
    for (var i = 0; i < n; i++) {
      _drawWheel(t + 2 * math.pi / n * i, r, canvas);
    }
  }

  void _drawWheel(double t, double r, Canvas canvas) {
    canvas.save();

    const n = 42;
    for (var i = 0; i < n; i++) {
      canvas.rotate(2 * math.pi / n);
      _drawStreak(t, r, 5, i / n, canvas);
    }

    canvas.restore();
  }

  void _drawStreak(
      double t, double r, double pr, double offset, Canvas canvas) {
    const n = 14;
    const delay = 0.4;
    const opacity = 0xaa / 0xff;
    for (var i = n; i >= 0; i--) {
      final lt = t - delay / n * i;
      final lo = opacity * (1 - 1 / n * i);

      _drawParticle(
        lt,
        r,
        pr,
        offset,
        const Color(0xFFFF0000).withOpacity(lo),
        canvas,
      );

      _drawParticle(
        lt - delay / 8,
        r,
        pr,
        offset,
        const Color(0xFF00FF00).withOpacity(lo),
        canvas,
      );

      _drawParticle(
        lt - delay / 4,
        r,
        pr,
        offset,
        const Color(0xFF0000FF).withOpacity(lo),
        canvas,
      );
    }
  }

  void _drawParticle(double t, double r, double pr, double offset, Color color,
      Canvas canvas) {
    canvas.drawCircle(
      Offset(
          r / 2 +
              r /
                  2 *
                  math.sin(1 / 2 + 1 / 2 * math.cos(t + 2 * math.pi * offset)),
          0),
      pr,
      Paint()
        ..color = color
        ..blendMode = BlendMode.screen,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
