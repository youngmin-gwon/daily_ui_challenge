import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class PolygonsPage extends StatefulWidget {
  const PolygonsPage({Key? key}) : super(key: key);

  @override
  _PolygonsPageState createState() => _PolygonsPageState();
}

class _PolygonsPageState extends State<PolygonsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  double sides = 3.0;
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
      appBar: AppBar(title: const Text("Polygons")),
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
                        painter: PolygonsPainter(
                          progress: _controller.value,
                          sides: sides,
                          showDots: showDots,
                          showPath: showPath,
                        ),
                      ),
                    );
                  }),
            ),
            Row(
              children: [
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
              child: Text('Sides'),
            ),
            Slider(
                value: sides,
                min: 3,
                max: 10,
                label: sides.toInt().toString(),
                divisions: 7,
                onChanged: (value) {
                  setState(() {
                    sides = value;
                  });
                }),
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

class PolygonsPainter extends CustomPainter {
  final double progress;
  final double sides;
  final bool showDots;
  final bool showPath;

  const PolygonsPainter({
    required this.progress,
    required this.sides,
    required this.showDots,
    required this.showPath,
  });

  static final Paint _paint = Paint()
    ..color = Colors.purple
    ..strokeWidth = 4.0
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  static const _radius = 100;

  @override
  void paint(Canvas canvas, Size size) {
    final path = createPath();
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
        canvas.drawCircle(offset, 8, Paint());
      } catch (e) {
        return;
      }
    }
  }

  Path createPath() {
    final path = Path();
    final angle = 2 * math.pi / sides;
    path.moveTo(_radius * math.cos(0), _radius * math.sin(0));
    for (int i = 1; i <= sides; i++) {
      double x = _radius * math.cos(angle * i);
      double y = _radius * math.sin(angle * i);
      path.lineTo(x, y);
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant PolygonsPainter oldDelegate) {
    return sides != oldDelegate.sides ||
        progress != oldDelegate.progress ||
        showDots != oldDelegate.showDots ||
        showPath != oldDelegate.showDots;
  }
}
