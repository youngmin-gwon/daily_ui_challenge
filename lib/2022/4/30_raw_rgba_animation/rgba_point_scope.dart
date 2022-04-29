import 'package:daily_ui/2022/4/30_raw_rgba_animation/rgba_point_notifier.dart';
import 'package:flutter/material.dart';

class RgbaPointScope extends InheritedWidget {
  const RgbaPointScope({
    Key? key,
    required Widget child,
    required this.pointNotifier,
  }) : super(key: key, child: child);

  final RgbaPointNotifier pointNotifier;

  static RgbaPointNotifier of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<RgbaPointScope>()!
        .pointNotifier;
  }

  @override
  bool updateShouldNotify(RgbaPointScope oldWidget) {
    return pointNotifier != oldWidget.pointNotifier;
  }
}
