import 'package:flutter/material.dart';

class GreyTopClipper extends CustomClipper<Path> {
  final double yOffset;

  const GreyTopClipper({
    required this.yOffset,
  });

  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0.0, 265.0 + yOffset)
      ..quadraticBezierTo(
          size.width / 2, 285.0 + yOffset, size.width, 185.0 + yOffset)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
