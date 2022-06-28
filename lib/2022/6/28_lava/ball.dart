import 'dart:math' as math;
import 'package:flutter/material.dart';

class ForcePoint<T extends num> {
  ForcePoint(this.x, this.y);

  T x, y;

  num get magnitude => x * x + y * y;

  double computed = 0;
  double force = 0;

  ForcePoint<num> add(ForcePoint<T> point) =>
      ForcePoint(point.x + x, point.y + y);

  ForcePoint copyWith({T? x, T? y}) => ForcePoint(
        x ?? this.x,
        y ?? this.y,
      );
}

class Ball {
  late ForcePoint velocity;
  late ForcePoint pos;
  late double size;

  Ball(Size newSize) {
    double vel({double ratio = 1}) =>
        (math.Random().nextDouble() > .5 ? 1 : -1) *
        (.2 + .25 * math.Random().nextDouble());

    velocity = ForcePoint(vel(ratio: 0.25), vel());

    var i = .1;
    var h = 1.5;

    double calculatePosition(double fullSize) =>
        math.Random().nextDouble() * fullSize;

    pos = ForcePoint(
      calculatePosition(newSize.width),
      calculatePosition(newSize.height),
    );

    size = newSize.shortestSide / 15 +
        (math.Random().nextDouble() * (h - i) + i) *
            (newSize.shortestSide / 15);
  }

  moveIn(Size newSize) {
    if (pos.x >= newSize.width - size) {
      if (pos.x > 0) {
        velocity.x = -velocity.x;
      }
      pos = pos.copyWith(
        x: newSize.width - size,
      );
    } else if (pos.x <= size) {
      if (velocity.x < 0) {
        velocity.x = -velocity.x;
      }
      pos.x = size;
    }
    if (pos.y >= newSize.height - size) {
      if (velocity.y > 0) {
        velocity.y = -velocity.y;
      }
      pos.y = newSize.height - size;
    } else if (pos.y <= size) {
      if (velocity.y < 0) {
        velocity.y = -velocity.y;
      }
      pos.y = size;
    }
    pos = pos.add(velocity);
  }
}
