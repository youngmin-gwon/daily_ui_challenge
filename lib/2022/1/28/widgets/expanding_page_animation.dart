import 'package:daily_ui/2022/1/28/styles/backgrounds.dart';
import 'package:flutter/material.dart';

class ExpandingPageAnimation extends StatelessWidget {
  const ExpandingPageAnimation({
    Key? key,
    required double width,
    required double height,
    required double borderRadius,
  })  : _width = width,
        _height = height,
        _borderRadius = borderRadius,
        super(key: key);

  final double _width;
  final double _height;
  final double _borderRadius;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
        height: _height,
        width: _width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_borderRadius),
          gradient: linearGradientHomeDecoration(),
        ),
      ),
    );
  }
}
