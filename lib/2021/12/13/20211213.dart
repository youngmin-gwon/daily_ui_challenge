import 'package:flutter/material.dart';

class Screen20211213 extends StatefulWidget {
  const Screen20211213({Key? key}) : super(key: key);

  @override
  State<Screen20211213> createState() => _Screen20211213State();
}

class _Screen20211213State extends State<Screen20211213>
    with SingleTickerProviderStateMixin {
  bool _isClicked = false;

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
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height / 4,
            child: FractionalTranslation(
              translation: const Offset(0.5, 0.5),
              child: Listener(
                onPointerDown: (event) {
                  setState(() {
                    _isClicked = !_isClicked;
                  });
                },
                child: Stack(
                  children: [
                    CustomPaint(
                      painter: Circle(
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                        radius: 24,
                        isFilled: _isClicked,
                      ),
                      child: const SizedBox(
                        width: 24,
                        height: 24,
                      ),
                    ),
                    const CustomPaint(
                      painter: Circle(
                        strokeWidth: 3,
                        strokeColor: Colors.yellow,
                        radius: 32,
                        isFilled: false,
                      ),
                      child: SizedBox(
                        width: 32,
                        height: 32,
                      ),
                    ),
                  ],
                ),
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
      this.center = const Offset(0.0, 0.0),
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
