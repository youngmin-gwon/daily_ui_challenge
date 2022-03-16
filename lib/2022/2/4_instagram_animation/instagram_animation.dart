import 'dart:ui' as ui;

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
  late Animation<double> _checkAnimation;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
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
    _checkAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.4,
          0.8,
          curve: Curves.easeOutQuint,
        ),
      ),
    );
    _fadeInAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(
            0.8,
            1.0,
            curve: Curves.ease,
          )),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size.square(100),
                  painter: InstagramPainter(
                    circleProgress: _circleAnimation.value,
                    checkProgress: _checkAnimation.value,
                  ),
                );
              },
            ),
            const SizedBox(height: 100),
            FadeTransition(
              opacity: _fadeInAnimation,
              child: const Text(
                "You're All Caught Up",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InstagramPainter extends CustomPainter {
  const InstagramPainter({
    required this.circleProgress,
    required this.checkProgress,
  });

  final double circleProgress;
  final double checkProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint _paint = Paint()
      ..strokeCap = StrokeCap.round
      ..shader = const RadialGradient(
              stops: [0.1, 0.4, 0.9],
              colors: [Colors.amber, Colors.red, Colors.purple])
          .createShader(Rect.fromCircle(
              center: Offset(0, size.height), radius: size.width * 2))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15 + math.max((1 - circleProgress) * 30, 0);

    canvas.drawCircle(Offset(size.width / 2, size.height / 2),
        1 + circleProgress * size.width, _paint);

    final path = Path();
    path.moveTo(-size.width * 0.1, size.height * 0.4);
    path.lineTo(size.width * 0.4, size.height * 0.9);
    path.lineTo(size.width, size.height * 0.1);

    final pathMetrics = path.computeMetrics();
    for (ui.PathMetric pathMetric in pathMetrics) {
      final extractPath =
          pathMetric.extractPath(0.0, pathMetric.length * checkProgress);
      if (checkProgress > 0) {
        canvas.drawPath(extractPath, _paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant InstagramPainter oldDelegate) {
    return circleProgress != oldDelegate.circleProgress ||
        checkProgress != oldDelegate.checkProgress;
  }
}
