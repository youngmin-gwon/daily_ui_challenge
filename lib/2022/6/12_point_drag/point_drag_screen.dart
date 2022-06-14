import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class PointDragScreen extends StatefulWidget {
  const PointDragScreen({Key? key}) : super(key: key);

  @override
  State<PointDragScreen> createState() => _PointDragScreenState();
}

class _PointDragScreenState extends State<PointDragScreen> {
  final List<Offset> points = [];
  late math.Random _random;

  var indexOfPoint = -1;

  @override
  void initState() {
    super.initState();
    _random = math.Random();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      const padding = 40;

      final size = MediaQuery.of(context).size;
      final width = MediaQuery.of(context).size.width - 2 * padding;

      var list = List.generate(
        10,
        (index) => Offset(
          padding + index * width / 10,
          lerpDouble(
            size.height / 2 - 100,
            size.height / 2 + 100,
            _random.nextDouble(),
          )!,
        ),
      ).toList();
      points.addAll(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: DragPainter(points: points),
            size: Size.infinite,
          ),
          GestureDetector(
            onLongPressStart: (details) {
              indexOfPoint = points.indexWhere((element) =>
                  (element.dx - details.localPosition.dx).abs() < 10 &&
                  (element.dy - details.localPosition.dy).abs() < 10);
              if (indexOfPoint > 0) {
                points.removeAt(indexOfPoint);
              }
              setState(() {});
            },
            onScaleStart: (details) {
              indexOfPoint = points.indexWhere(
                (element) {
                  return (element.dx - details.localFocalPoint.dx).abs() < 10 &&
                      (element.dy - details.localFocalPoint.dy).abs() < 10;
                },
              );

              if (indexOfPoint > 0) {
                points.add(details.localFocalPoint);
                points.sort((e1, e2) => e1.dx.compareTo(e2.dx));
                setState(() {});
              }
            },
            onScaleUpdate: (details) {
              if (indexOfPoint < 0) return;
              points[indexOfPoint] = details.localFocalPoint;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}

class DragPainter extends CustomPainter {
  const DragPainter({
    required this.points,
  });

  final List<Offset> points;

  @override
  void paint(Canvas canvas, Size size) {
    const ctrlValueT = 0.2;

    final linePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2;

    final pointPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 15;

    final path = Path();

    points.insert(0, points[0]);
    points.add(points.last);
    points.add(points.last);

    path.moveTo(points[0].dx, points[0].dy);

    for (var i = 1; i < points.length - 3; i++) {
      var ax =
          points[i].dx + (points[i + 1].dx - points[i - 1].dx) * ctrlValueT;
      var ay =
          points[i].dy + (points[i + 1].dy - points[i - 1].dy) * ctrlValueT;
      var bx =
          points[i + 1].dx - (points[i + 2].dx - points[i].dx) * ctrlValueT;
      var by =
          points[i + 1].dy - (points[i + 2].dy - points[i].dy) * ctrlValueT;

      path.cubicTo(ax, ay, bx, by, points[i + 1].dx, points[i + 1].dy);
    }

    canvas.drawPath(path, linePaint);
    canvas.drawPoints(PointMode.points, points, pointPaint);
  }

  @override
  bool shouldRepaint(covariant DragPainter oldDelegate) {
    return points != oldDelegate.points;
  }
}
