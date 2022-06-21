import 'dart:async';

import 'package:flutter/material.dart';

class BezierScreen extends StatefulWidget {
  const BezierScreen({Key? key}) : super(key: key);

  @override
  State<BezierScreen> createState() => _BezierScreenState();
}

class _BezierScreenState extends State<BezierScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  List<Offset> pointList = [];
  List<Offset> pivotList = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Timer(const Duration(seconds: 1), () {
          pointList.clear();
          _controller.reverse();
        });
      } else if (status == AnimationStatus.dismissed) {
        Timer(const Duration(seconds: 1), () {
          pointList.clear();
          _controller.forward();
        });
      }
    });
    _controller.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      setState(() {
        pivotList = [
          Offset(size.width * 3 / 6, size.height * 1 / 6),
          Offset(size.width * 5 / 6, size.height * 3 / 6),
          Offset(size.width * 3 / 6, size.height * 5 / 6),
          Offset(size.width * 1 / 6, size.height * 3 / 6),
          Offset(size.width * 3 / 6, size.height * 1 / 6),
        ];
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation:
              CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
          builder: (context, child) {
            return CustomPaint(
              size: Size.infinite,
              painter: BezierPainter(
                screenSize: MediaQuery.of(context).size,
                animation: _controller.value,
                pointList: pointList,
                pivotList: pivotList,
              ),
            );
          },
        ),
      ),
    );
  }
}

class BezierPainter extends CustomPainter {
  final Size screenSize;
  final double animation;
  final List<Offset> pointList;
  final List<Offset> pivotList;

  BezierPainter({
    required this.screenSize,
    required this.animation,
    required this.pointList,
    required this.pivotList,
  });

  final painter = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.black;

  final painter2 = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.red;

  @override
  void paint(Canvas canvas, Size size) {
    getQuadraticBezier(pivotList, animation, canvas: canvas, paint: painter2);

    for (var o in pointList) {
      // canvas.drawCircle(o, 1.0, painter);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

Offset getQuadraticBezier(List<Offset> offsetList, double t,
    {required Canvas canvas, required Paint paint}) {
  return getQuadraticBezier2(
      offsetList, t, 0, offsetList.length - 1, canvas, paint);
}

Offset getQuadraticBezier2(List<Offset> offsetList, double t, int i, int j,
    Canvas canvas, Paint paint) {
  if (i == j) return offsetList[i];

  Offset b0 = getQuadraticBezier2(offsetList, t, i, j - 1, canvas, paint);
  Offset b1 = getQuadraticBezier2(offsetList, t, i + 1, j, canvas, paint);
  Offset res = Offset((1 - t) * b0.dx + t * b1.dx, (1 - t) * b0.dy + t * b1.dy);
  canvas.drawLine(b1, b0, paint);
  canvas.drawCircle(res, 2.0, paint);
  return res;
}
