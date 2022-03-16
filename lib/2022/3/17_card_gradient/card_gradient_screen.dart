import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CardGradientScreen extends StatefulWidget {
  const CardGradientScreen({Key? key}) : super(key: key);

  @override
  State<CardGradientScreen> createState() => _CardGradientScreenState();
}

class _CardGradientScreenState extends State<CardGradientScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Size size;

  /// y : angles to show dynamic gradient effect
  ///  range = [-pi/10, pi/10]
  double y = 0;
  void _onLongPressDown(LongPressDownDetails details) {
    print('global:${details.globalPosition.dx}');
    print('local:${size.width}');
    if (details.globalPosition.dx < size.width / 2) {
      setState(() {
        y = math.pi / 10;
      });
    } else if (details.globalPosition.dx > size.width / 2) {
      setState(() {
        y = -math.pi / 10;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SizedBox(
          width: size.width / 2.5,
          child: AspectRatio(
            aspectRatio: 3 / 5,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(y)
                ..rotateZ(-math.pi / 12),
              alignment: FractionalOffset.center,
              child: GestureDetector(
                onLongPressDown: _onLongPressDown,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
