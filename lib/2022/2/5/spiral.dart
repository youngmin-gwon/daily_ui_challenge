import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class SpiralPage extends StatefulWidget {
  const SpiralPage({Key? key}) : super(key: key);

  @override
  _SpiralPageState createState() => _SpiralPageState();
}

class _SpiralPageState extends State<SpiralPage>
    with SingleTickerProviderStateMixin {
  bool showDots = false, showPath = true;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spiral'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                print('${_controller.value}');
                return Expanded(
                  child: Center(
                    child: CustomPaint(
                      painter: SpiralPainter(
                        progress: _controller.value,
                        showPath: showPath,
                        showDots: showDots,
                      ),
                    ),
                  ),
                );
              },
            ),
            Row(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(left: 24.0, right: 0.0),
                  child: Text('Show Dots'),
                ),
                Switch(
                  value: showDots,
                  onChanged: (value) {
                    setState(() {
                      showDots = value;
                    });
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 24.0, right: 0.0),
                  child: Text('Show Path'),
                ),
                Switch(
                  value: showPath,
                  onChanged: (value) {
                    setState(() {
                      showPath = value;
                    });
                  },
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: Text('Progress'),
            ),
            Slider(
              value: _controller.value,
              min: 0.0,
              max: 1.0,
              onChanged: (value) {
                setState(() {
                  _controller.value = value;
                });
              },
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _controller.reset();
                  _controller.forward();
                },
                child: const Text('Animate'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpiralPainter extends CustomPainter {
  const SpiralPainter({
    required this.progress,
    required this.showPath,
    required this.showDots,
  });

  final double progress;
  final bool showDots, showPath;

  static final _paint = Paint()
    ..color = Colors.deepPurple
    ..strokeWidth = 4.0
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    Path path = createSpiralPath(size);
    PathMetric pathMetric = path.computeMetrics().first;
    Path extractPath =
        pathMetric.extractPath(0.0, pathMetric.length * progress);
    if (showPath) {
      canvas.drawPath(extractPath, _paint);
    }
    if (showDots) {
      try {
        var metric = extractPath.computeMetrics().first;
        final offset = metric.getTangentForOffset(metric.length)!.position;
        canvas.drawCircle(offset, 8.0, Paint());
      } catch (e) {
        return;
      }
    }
  }

  Path createSpiralPath(Size size) {
    double radius = 0, angle = 0;
    Path path = Path();
    for (int n = 0; n < 200; n++) {
      radius += 0.75;
      angle += (math.pi * 2) / 50;
      final x = size.width / 2 + radius * math.cos(angle);
      final y = size.height / 2 + radius * math.sin(angle);
      path.lineTo(x, y);
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant SpiralPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        showPath != oldDelegate.showPath ||
        showDots != oldDelegate.showDots;
  }
}
