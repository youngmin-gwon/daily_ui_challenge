import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:daily_ui/2022/6/27_particle/particle_counter_screen.dart';

class CircleWaveScreen extends StatefulWidget {
  const CircleWaveScreen({Key? key}) : super(key: key);

  @override
  State<CircleWaveScreen> createState() => _CircleWaveScreenState();
}

class _CircleWaveScreenState extends State<CircleWaveScreen>
    with TickerProviderStateMixin {
  static const colors = [
    Color(0xFFFF2964),
    Color(0xFF32FF3A),
    Color(0xFF4255FF),
  ];

  late AnimationController _controller;
  late AnimationController _addPointController;
  late Animation<double> _addPointAnimation;

  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      upperBound: 2,
      duration: const Duration(seconds: 10),
    )..repeat();
    _addPointController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _addPointAnimation =
        _addPointController.drive(CurveTween(curve: Curves.ease));
  }

  @override
  void dispose() {
    _controller.dispose();
    _addPointController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      _addPointController.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
      body: Stack(
        children: [
          for (int i = 0; i < 3; i++)
            Positioned.fill(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
                builder: (_, double opacity, __) {
                  return CustomPaint(
                    painter: CircleWavePainter(
                      animation: _controller,
                      addAnimation: _addPointAnimation,
                      index: i,
                      color: colors[i].withOpacity(opacity),
                      count: _counter,
                    ),
                  );
                },
              ),
            ),
          CounterText(count: _counter),
        ],
      ),
    );
  }
}

class CircleWavePainter extends CustomPainter {
  const CircleWavePainter({
    required this.animation,
    required this.addAnimation,
    required this.index,
    required this.color,
    required this.count,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Animation<double> addAnimation;
  final int index;
  final Color color;
  final int count;

  static const halfPi = math.pi / 2;
  static const twoPi = math.pi * 2;
  final n = 7;

  @override
  void paint(Canvas canvas, Size size) {
    final t = animation.value;
    final halfWidth = size.width / 2;
    final halfHeight = size.height / 2;
    final q = index * halfPi;

    List<Offset> computeOffsets(int length) {
      final offsets = <Offset>[];
      for (var i = 0; i < length; i++) {
        final th = i * twoPi / length;
        double os = map(math.cos(th - twoPi * t), -1, 1, 0, 1);
        os = 0.125 * math.pow(os, 2.75);
        final r = 165 * (1 + os * math.cos(n * th + 1.5 * twoPi * t + q));
        offsets.add(
          Offset(r * math.sin(th) + halfWidth, -r * math.cos(th) + halfHeight),
        );
      }
      return offsets;
    }

    final offsets = computeOffsets(count);

    if (count > 1 && addAnimation.value < 1) {
      final t = addAnimation.value;
      final oldOffsets = computeOffsets(count - 1);
      for (var i = 0; i < count - 1; i++) {
        offsets[i] = Offset.lerp(oldOffsets[i], offsets[i], t)!;
      }
      offsets[count - 1] = Offset.lerp(
        oldOffsets[count - 2],
        offsets[count - 1],
        t,
      )!;
    }

    final path = Path()..addPolygon(offsets, true);
    canvas.drawPath(
      path,
      Paint()
        ..blendMode = BlendMode.lighten
        ..color = color
        ..strokeWidth = 8
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
