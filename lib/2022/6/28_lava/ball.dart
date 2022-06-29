import 'dart:math' as math;
import 'package:flutter/material.dart';

class ForcePoint {
  ForcePoint(this.x, this.y);

  double x, y;

  num get magnitude => x * x + y * y;

  double computed = 0;
  double force = 0;

  ForcePoint add(ForcePoint point) => ForcePoint(point.x + x, point.y + y);

  ForcePoint copyWith({double? x, double? y}) => ForcePoint(
        x ?? this.x,
        y ?? this.y,
      );
}

class Ball {
  late ForcePoint velocity;
  late ForcePoint pos;
  late double radius;

  Ball(Size size) {
    double vel() =>
        (math.Random().nextDouble() > .5 ? 1 : -1) *
        (.2 + .25 * math.Random().nextDouble());

    velocity = ForcePoint(vel(), vel());

    var i = .1;
    var h = 1.5;

    double calculatePosition(double fullSize) =>
        math.Random().nextDouble() * fullSize;

    pos = ForcePoint(
      calculatePosition(size.width),
      calculatePosition(size.height),
    );

    radius = size.shortestSide / 15 +
        (math.Random().nextDouble() * (h - i) + i) * (size.shortestSide / 15);
  }

  void moveIn(Size size) {
    if (pos.x >= size.width - radius) {
      if (pos.x > 0) {
        velocity.x = -velocity.x;
      }
      pos = pos.copyWith(
        x: size.width - radius,
      );
    } else if (pos.x <= radius) {
      if (velocity.x < 0) {
        velocity.x = -velocity.x;
      }
      pos.x = radius;
    }
    if (pos.y >= size.height - radius) {
      if (velocity.y > 0) {
        velocity.y = -velocity.y;
      }
      pos.y = size.height - radius;
    } else if (pos.y <= radius) {
      if (velocity.y < 0) {
        velocity.y = -velocity.y;
      }
      pos.y = radius;
    }
    pos = pos.add(velocity);
  }
}
