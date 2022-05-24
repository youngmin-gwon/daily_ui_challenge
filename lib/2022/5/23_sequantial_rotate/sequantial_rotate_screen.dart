import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SequantialRotateScreen extends StatefulWidget {
  const SequantialRotateScreen({Key? key}) : super(key: key);

  @override
  State<SequantialRotateScreen> createState() => _SequantialRotateScreenState();
}

class _SequantialRotateScreenState extends State<SequantialRotateScreen>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late ValueNotifier<double> time;

  @override
  void initState() {
    super.initState();
    time = ValueNotifier(0);
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
          painter: SequantialRotatePainter(time: time),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class SequantialRotatePainter extends CustomPainter {
  final ValueListenable<double> time;

  const SequantialRotatePainter({
    required this.time,
  }) : super(repaint: time);

  @override
  void paint(Canvas canvas, Size size) {
    // Center the square.

    final t = time.value * 10;

    const width = 750.0;

    canvas.translate((size.width - size.shortestSide) / 2,
        (size.height - size.shortestSide) / 2);

    final scaling = size.shortestSide / width;
    canvas.scale(scaling);
    const scaledSize = Size.square(width);

    final h = scaledSize.width / 2;

    canvas.clipRect(Offset.zero & scaledSize);

    canvas.drawColor(const Color(0xFF303030), BlendMode.srcOver);

    canvas.translate(h, h);

    int i, j, s;
    for (i = 9; i > 0; i--) {
      // the piece of code responsible for the angle is taken from
      // https://www.dwitter.net/d/20577, whici was created by pavel.
      // That animation is inspired by Dave Whyte (beesandbombs)
      for (j = s = 4 << (i ~/ 3) + 1; j > 0; j--) {
        final af = s / (j + i / (1 + math.pow(4, 4 + i - t % 4.5 * 4)));
        final p = Offset.fromDirection(2 * math.pi / af - math.pi / 2, i * 37);
        final co = HSLColor.fromAHSL(1, (-360 / af - 42) % 360, 1, 3 / 4);
        canvas.drawCircle(p, 11 - i / 1.5, Paint()..color = co.toColor());
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
