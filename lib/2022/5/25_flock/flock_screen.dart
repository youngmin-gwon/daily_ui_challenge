import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FlockScreen extends StatefulWidget {
  const FlockScreen({Key? key}) : super(key: key);

  @override
  State<FlockScreen> createState() => _FlockScreenState();
}

class _FlockScreenState extends State<FlockScreen>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late ValueNotifier<double> time;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
    time = ValueNotifier(0);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    time.value = elapsed.inMicroseconds / 1e6;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: CustomPaint(
          painter: FlockPainter(time: time),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class FlockPainter extends CustomPainter {
  final ValueListenable<double> time;

  const FlockPainter({
    required this.time,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class Boid {
  late Offset position;
  late Offset velocity;
  late Offset acceleration;

  late double r;
  late double maxForce; // maximum steering force
  late double maxSpeed; // maximum speed

  Boid(double x, double y) {
    acceleration = Offset(x, y);

    // this is a new offset method not yet implemented
    double angle = math.Random().nextDouble() * math.pi;
    velocity = Offset(math.cos(angle), math.sin(angle));

    position = Offset(x, y);
    r = 2.0;
    maxSpeed = 2;
    maxForce = 0.03;
  }

  void run(List<Boid> boids) {
    flock(boids);
    update();
    borders();
    // render();
  }

  void applyForce(Offset force) {
    // we could add mass here if we want a = F / m
    acceleration += force;
  }

  void flock(List<Boid> boids) {
    // Offset sep = seperate(boids); // seperation
    // Offset ali = align(boids);
    // Offset coh = cohesion(boids);
    // Arbitrarily weight these forces
    // sep *= 1.5;
    // ali *= 1.0;
    // coh *= 1.0;
    // // Add the force vectors to acceleration
    // applyForce(sep);
    // applyForce(ali);
    // applyForce(coh);
  }

  void update() {
    // update velocity
    velocity += acceleration;
    // limit speed
    velocity = Offset(velocity.dx, velocity.dy);
    velocity = _getMaxOffset(velocity, maxSpeed);

    position += velocity;
    acceleration *= 0;
  }

  Offset seek(Offset target) {
    Offset desired = target - position;
    // scale to maximum speed
    final scale = 1 / desired.distance;
    desired = desired.scale(scale, scale);
    desired *= maxSpeed;

    // above two lines of code below could be condensed with new Offset setMag()
    // method.
    var steer = desired - velocity;
    steer = _getMaxOffset(steer, maxSpeed);
    return steer;
  }

  void render(Canvas canvas) {
    // Draw a triangle rotated in the direction of velocity
    double theta = velocity.direction + math.pi / 2;

    // todo: implement
  }

  void borders() {
    if (position.dx < -r) {
      // position.dx = width + r;
    }
  }

  Offset _getMaxOffset(Offset subject, double target) {
    if (subject.distance > target) {
      final scale = maxSpeed / subject.distance;
      return subject.scale(scale, scale);
    }
    return subject;
  }
}
