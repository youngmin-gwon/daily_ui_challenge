import 'package:daily_ui/2022/1/6/constants.dart';
import 'package:flutter/material.dart';

class Ripple extends StatelessWidget {
  const Ripple({
    Key? key,
    required this.radius,
  }) : super(key: key);

  final double radius;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Positioned(
      left: screenWidth / 2 - radius,
      bottom: 2 * kPaddingL - radius,
      child: Container(
        width: 2 * radius,
        height: 2 * radius,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: kWhite,
        ),
      ),
    );
  }
}
