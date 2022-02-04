import 'package:flutter/material.dart';
import 'dart:math' as math;

class InstagramPage extends StatefulWidget {
  const InstagramPage({Key? key}) : super(key: key);

  @override
  State<InstagramPage> createState() => _InstagramPageState();
}

class _InstagramPageState extends State<InstagramPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _circleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _circleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.1,
          0.5,
          curve: Curves.elasticOut,
        ),
      ),
    );
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: InstagramPainter(
                  animValue: _circleAnimation.value,
                ),
              );
            }),
      ),
    );
  }
}

class InstagramPainter extends CustomPainter {
  const InstagramPainter({required this.animValue});

  final double animValue;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint _circlePaint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6 + math.max((1 - animValue) * 30, 0);

    canvas.drawCircle(Offset(size.width / 2, size.height / 2),
        1 + animValue * 40, _circlePaint);
  }

  @override
  bool shouldRepaint(covariant InstagramPainter oldDelegate) {
    return true;
  }
}
