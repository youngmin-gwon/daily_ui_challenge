import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class RotatingCharacterScreen extends StatefulWidget {
  const RotatingCharacterScreen({Key? key}) : super(key: key);

  @override
  State<RotatingCharacterScreen> createState() =>
      _RotatingCharacterScreenState();
}

class _RotatingCharacterScreenState extends State<RotatingCharacterScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotateController;
  late AnimationController _entranceController;

  final _rotateXTween = CurveTween(curve: Curves.ease);
  final _radiusTween = Tween<double>(begin: 500, end: 400)
      .chain(CurveTween(curve: Curves.easeIn));

  final _textCount = 20;

  double _fontSize = 10;
  double _letterSpacing = 50;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..repeat();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..forward();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _initialAnimation();
    });
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  void _initialAnimation() {
    setState(() {
      _fontSize = 110;
      _letterSpacing = 0;
    });
  }

  bool isOnLeft(double rotation) => math.cos(rotation) > 0;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(),
        body: SizedBox.expand(
          child: Stack(
            alignment: Alignment.center,
            children: List.generate(_textCount, (index) {
              return AnimatedBuilder(
                animation: _rotateController,
                builder: (context, child) {
                  final animationValue =
                      _rotateController.value * 2 * math.pi / _textCount;
                  double rotation = 2 * math.pi * index / _textCount +
                      math.pi / 2 +
                      animationValue;

                  if (isOnLeft(rotation)) {
                    rotation = -rotation +
                        2 * animationValue -
                        math.pi * 2 / _textCount;
                  }

                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: const Offset(0, 0),
                    )
                        .chain(
                          CurveTween(
                            curve: Curves.ease,
                          ),
                        )
                        .animate(_entranceController),
                    child: Transform(
                      transform: Matrix4.identity()
                        ..rotateX(
                          -math.pi /
                              3 *
                              (1 -
                                  _rotateXTween
                                      .animate(_entranceController)
                                      .value),
                        ),
                      child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(rotation),
                        alignment: Alignment.center,
                        child: _SentenceWidget(
                          radius:
                              _radiusTween.animate(_entranceController).value,
                          fontSize: _fontSize,
                          letterSpacing: _letterSpacing,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _SentenceWidget extends StatefulWidget {
  const _SentenceWidget({
    Key? key,
    required this.radius,
    required this.fontSize,
    required this.letterSpacing,
  }) : super(key: key);

  final double radius;
  final double fontSize;
  final double letterSpacing;

  @override
  State<_SentenceWidget> createState() => _SentenceWidgetState();
}

class _SentenceWidgetState extends State<_SentenceWidget> {
  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: -1,
      child: Container(
        alignment: Alignment.topCenter,
        height: widget.radius,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 1500),
          curve: Curves.ease,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: widget.fontSize,
            letterSpacing: widget.letterSpacing,
            foreground: Paint()
              ..shader = ui.Gradient.linear(
                  const Offset(0, 0), Offset(0, widget.radius / 2), [
                Colors.white,
                Colors.black,
              ], [
                0.2,
                0.9
              ]),
          ),
          child: const Text(
            "LINEAR",
          ),
        ),
      ),
    );
  }
}
