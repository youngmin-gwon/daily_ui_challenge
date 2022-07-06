import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:daily_ui/2022/6/27_particle/particle_counter_screen.dart';

class BubbleRotatingCounterScreen extends StatefulWidget {
  const BubbleRotatingCounterScreen({Key? key}) : super(key: key);

  @override
  State<BubbleRotatingCounterScreen> createState() =>
      _BubbleRotatingCounterScreenState();
}

class _BubbleRotatingCounterScreenState
    extends State<BubbleRotatingCounterScreen> {
  static const colors = <Color>[
    Color(0xFFFF2964),
    Color(0xFF32FF3A),
    Color(0xFF4255FF),
  ];

  final math.Random random = math.Random();
  final List<double> radii = <double>[];

  void _increment() {
    setState(() {
      radii.add(random.nextInt(25) + 12.5);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: Theme.of(context).iconTheme,
        ),
        body: Stack(
          children: [
            for (int i = 0; i < radii.length; i++)
              Positioned.fill(
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: radii[i]),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                  builder: (_, double radius, __) {
                    return RotatingBubble(
                      random: random,
                      radius: radius,
                      color: colors[i % colors.length],
                    );
                  },
                ),
              ),
            CounterText(count: radii.length),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _increment,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class RotatingBubble extends StatefulWidget {
  const RotatingBubble({
    Key? key,
    required this.random,
    required this.radius,
    required this.color,
  }) : super(key: key);

  final math.Random random;
  final double radius;
  final Color color;

  @override
  State<RotatingBubble> createState() => _RotatingBubbleState();
}

class _RotatingBubbleState extends State<RotatingBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> angle;
  late double shift;

  static const twoPi = math.pi * 2;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.random.nextInt(1200) + 800),
    )..repeat();
    final startAngle = widget.random.nextDouble() * twoPi;
    final endAngle = startAngle + (twoPi * (widget.random.nextBool() ? 1 : -1));
    angle = _controller.drive(Tween(begin: startAngle, end: endAngle));

    shift = widget.random.nextDouble() / 10 + 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RotatingBubblePainter(
        angle: angle,
        shift: shift,
        radius: widget.radius,
        color: widget.color,
      ),
    );
  }
}

class RotatingBubblePainter extends CustomPainter {
  final Animation<double> angle;
  final double shift;
  final double radius;
  final Color color;

  const RotatingBubblePainter({
    required this.angle,
    required this.shift,
    required this.radius,
    required this.color,
  }) : super(repaint: angle);

  @override
  void paint(Canvas canvas, Size size) {
    final appCenter = size.center(Offset.zero);
    final bigRadius = size.width / 2.7;
    final center =
        (Offset.fromDirection(angle.value, bigRadius * shift)) + appCenter;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..blendMode = BlendMode.lighten
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
