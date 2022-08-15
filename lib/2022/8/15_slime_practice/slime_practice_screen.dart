import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SlimePracticeScreen extends StatefulWidget {
  const SlimePracticeScreen({Key? key}) : super(key: key);

  @override
  State<SlimePracticeScreen> createState() => _SlimePracticeScreenState();
}

class _SlimePracticeScreenState extends State<SlimePracticeScreen>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  _MetaballsEffect? effect;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      effect = _MetaballsEffect(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height,
      );
      effect!.init(20);
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    if (effect != null) {
      setState(() {
        effect!.update();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(),
        body: effect != null
            ? CustomPaint(
                size: Size.infinite,
                painter: SlimePainter(
                  effect: effect!,
                ),
              )
            : null,
      ),
    );
  }
}

class SlimePainter extends CustomPainter {
  final _MetaballsEffect effect;

  final Paint ballPaint = Paint()
    ..color = Colors.orange
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10)
    ..blendMode = BlendMode.plus;

  SlimePainter({
    required this.effect,
  });

  @override
  void paint(Canvas canvas, Size size) {
    effect.draw(canvas, ballPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _Ball {
  final _MetaballsEffect effect;
  late double x;
  late double y;
  late double radius;
  late double speedX;
  late double speedY;

  _Ball(this.effect) {
    x = effect.width * 0.5;
    y = effect.height * 0.5;
    radius = math.Random().nextDouble() * 80 + 20;
    speedX = math.Random().nextDouble() - 0.5;
    speedY = math.Random().nextDouble() - 0.5;
  }

  update() {
    if (x < radius || x > effect.width - radius) {
      speedX *= -1;
    }

    if (y < radius || y > effect.height - radius) {
      speedY *= -1;
    }
    x += speedX;
    y += speedY;
  }

  draw(Canvas canvas, Paint paint) {
    final path = Path();
    path.addArc(
      Rect.fromCenter(
          center: Offset(x, y), width: 2 * radius, height: 2 * radius),
      0,
      2 * math.pi,
    );
    paint.style = PaintingStyle.fill;
    path.close();
    canvas.drawPath(path, paint);
  }
}

class _MetaballsEffect {
  final double width;
  final double height;
  late final List<_Ball> metaballsArray;

  _MetaballsEffect(this.width, this.height) {
    metaballsArray = [];
  }

  void init(int numberOfBalls) {
    for (var i = 0; i < numberOfBalls; i++) {
      metaballsArray.add(_Ball(this));
    }
  }

  void update() {
    for (final metaball in metaballsArray) {
      metaball.update();
    }
  }

  void draw(Canvas canvas, Paint paint) {
    for (final metaball in metaballsArray) {
      metaball.draw(canvas, paint);
    }
  }
}
