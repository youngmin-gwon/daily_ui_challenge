import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class CirclesPage extends StatefulWidget {
  const CirclesPage({Key? key}) : super(key: key);

  @override
  _CirclesPageState createState() => _CirclesPageState();
}

class _CirclesPageState extends State<CirclesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double circles = 5.0;
  bool showDots = false, showPath = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _controller.value = 1;
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
        title: const Text("Circles"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Center(
                    child: CustomPaint(
                      painter: CirclesPainter(
                        circles: circles,
                        progress: _controller.value,
                        showDots: showDots,
                        showPath: showPath,
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 24, right: 0),
                  child: Text("Show Dots"),
                ),
                Switch(
                    value: showDots,
                    onChanged: (value) {
                      setState(() {
                        showDots = value;
                      });
                    }),
                const Padding(
                  padding: EdgeInsets.only(left: 24, right: 0),
                  child: Text("Show Path"),
                ),
                Switch(
                    value: showPath,
                    onChanged: (value) {
                      setState(() {
                        showPath = value;
                      });
                    })
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 24),
              child: Text("Circles"),
            ),
            Slider(
              value: circles,
              min: 1,
              max: 10,
              divisions: 9,
              label: circles.toInt().toString(),
              onChanged: (value) {
                setState(() {
                  circles = value;
                });
              },
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
                child: const Text('Animate'),
                onPressed: () {
                  _controller.reset();
                  _controller.forward();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CirclesPainter extends CustomPainter {
  final double circles, progress;
  final bool showDots, showPath;

  static const radius = 80.0;

  static final myPaint = Paint()
    ..color = Colors.purple
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5.0;

  const CirclesPainter({
    required this.circles,
    required this.progress,
    required this.showDots,
    required this.showPath,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = createPath();
    final pathMetrics = path.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      final extractPath =
          pathMetric.extractPath(0.0, pathMetric.length * progress);

      if (showPath) {
        canvas.drawPath(extractPath, myPaint);
      }
      if (showDots) {
        try {
          var metric = extractPath.computeMetrics().first;
          final offset = metric.getTangentForOffset(metric.length)!.position;
          canvas.drawCircle(offset, 8, Paint());
        } catch (e) {
          return;
        }
      }
    }
  }

  Path createPath() {
    var path = Path();
    int n = circles.toInt();
    var range = List<int>.generate(n, (i) => i + 1);
    double angle = 2 * math.pi / n;
    for (int i in range) {
      double x = radius * math.cos(angle * i);
      double y = radius * math.sin(angle * i);
      path.addOval(Rect.fromCircle(center: Offset(x, y), radius: radius));
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant CirclesPainter oldDelegate) {
    return circles != oldDelegate.circles ||
        progress != oldDelegate.progress ||
        showDots != oldDelegate.showDots ||
        showPath != oldDelegate.showDots;
  }
}
