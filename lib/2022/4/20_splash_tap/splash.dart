import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  final Widget child;
  final GestureTapCallback onTap;

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  static const double minRadius = 50;
  static const double maxRadius = 120;

  late AnimationController _controller;
  final radiusTween = Tween<double>(begin: 0, end: 50);
  final borderRadiusTween = Tween<double>(begin: 25, end: 1);
  AnimationStatus status = AnimationStatus.dismissed;
  Offset _tapPosition = const Offset(0, 0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addStatusListener((listener) {
        status = listener;
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap(TapUpDetails details) {
    final RenderBox renderBox = context.findRenderObject()! as RenderBox;
    _tapPosition = renderBox.globalToLocal(details.globalPosition);
    final radius = (renderBox.size.width > renderBox.size.height)
        ? renderBox.size.width
        : renderBox.size.height;

    double constraintRadius;
    if (radius > maxRadius) {
      constraintRadius = maxRadius;
    } else if (radius < minRadius) {
      constraintRadius = minRadius;
    } else {
      constraintRadius = radius;
    }

    radiusTween.end = constraintRadius * 0.6;
    borderRadiusTween.begin = radiusTween.end! / 2;
    borderRadiusTween.end = radiusTween.end! * 0.01;

    _controller.forward(from: 0);
    widget.onTap.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            foregroundPainter: SplashPainter(
              tapPosition: _tapPosition,
              radius: radiusTween
                  .animate(
                      CurvedAnimation(parent: _controller, curve: Curves.ease))
                  .value,
              borderRadius: borderRadiusTween
                  .animate(CurvedAnimation(
                      parent: _controller, curve: Curves.fastOutSlowIn))
                  .value,
              status: status,
            ),
            child: GestureDetector(
              onTapUp: _handleTap,
              child: widget.child,
            ),
          );
        });
  }
}

class SplashPainter extends CustomPainter {
  final double radius;
  final double borderRadius;
  final AnimationStatus status;
  final Offset tapPosition;

  late final Paint blackPaint;

  SplashPainter({
    required this.radius,
    required this.borderRadius,
    required this.status,
    required this.tapPosition,
  }) {
    blackPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderRadius;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (status == AnimationStatus.forward) {
      canvas.drawCircle(tapPosition, radius, blackPaint);
    }
  }

  @override
  bool shouldRepaint(covariant SplashPainter oldDelegate) {
    return radius != oldDelegate.radius ||
        borderRadius != oldDelegate.borderRadius ||
        status != oldDelegate.status;
  }
}
