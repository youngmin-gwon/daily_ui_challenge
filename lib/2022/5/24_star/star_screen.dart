import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class StarScreen extends StatefulWidget {
  const StarScreen({Key? key}) : super(key: key);

  @override
  State<StarScreen> createState() => _StarScreenState();
}

class _StarScreenState extends State<StarScreen>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late ValueNotifier<double> _time;

  @override
  void initState() {
    super.initState();
    _time = ValueNotifier<double>(0);
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    _time.value = elapsed.inMicroseconds / 10e6;
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
          painter: StarPainter(
            time: _time,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class StarPainter extends CustomPainter {
  const StarPainter({
    required this.time,
  }) : super(repaint: time);

  final ValueListenable<double> time;

  @override
  void paint(Canvas canvas, Size size) {
    double t = time.value;
    const period = 6;
    const factor = 1.75;
    const n = 5e3;

    t *= 3;
    t %= period;

    const d = 750.0;

    canvas.drawColor(const Color(0xFF000000), BlendMode.srcOver);

    canvas.translate((size.width - size.shortestSide) / 2,
        (size.height - size.shortestSide) / 2);

    final scaling = size.shortestSide / d;
    canvas.scale(scaling);
    const scaledSize = Size.square(d);

    canvas.clipRect(Offset.zero & scaledSize);

    final h = scaledSize.width / 2;
    canvas.translate(h, h);

    canvas.scale(1 / 2);

    canvas.rotate(-math.pi / 2);

    Offset oo(int i) => Offset.fromDirection(
        math.sin(i * math.pi / factor +
                t / (period * factor * 4) * math.pi * 2) *
            math.pi *
            2,
        d / n * (n - i) / 1.25);

    for (var i = 0; i < n; i++) {
      final o = oo(i), no = oo(i + 1);
      final p = Path()
        ..moveTo(no.dx, no.dy)
        ..lineTo(o.dx, o.dy);

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..blendMode = BlendMode.plus
        ..strokeWidth = 3
        ..color = HSVColor.fromAHSV(1 / 4, 360 / n * i, 3 / 4, 3 / 4).toColor();

      canvas.drawPath(p, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
