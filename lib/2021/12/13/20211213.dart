import 'package:flutter/material.dart';

class Screen20211213 extends StatelessWidget {
  const Screen20211213({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2729),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            left: MediaQuery.of(context).size.width / 2,
            bottom: MediaQuery.of(context).size.height / 4,
            child: const CustomPaint(
              painter: Circle(
                strokeWidth: 3,
                strokeColor: Colors.yellow,
                radius: 36,
                center: Offset(0, 0),
                isFilled: false,
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 2,
            bottom: MediaQuery.of(context).size.height / 4,
            child: const CustomPaint(
              painter: Circle(
                strokeWidth: 2,
                strokeColor: Colors.white,
                radius: 24,
                center: Offset(0, 0),
                isFilled: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Circle extends CustomPainter {
  final double strokeWidth;
  final Color strokeColor;
  final double radius;
  final Offset center;
  final bool isFilled;

  const Circle(
      {required this.strokeWidth,
      required this.strokeColor,
      required this.radius,
      required this.center,
      required this.isFilled});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..strokeWidth = strokeWidth
      ..color = strokeColor
      ..style = isFilled ? PaintingStyle.fill : PaintingStyle.stroke;

    canvas.drawCircle(center, radius, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
