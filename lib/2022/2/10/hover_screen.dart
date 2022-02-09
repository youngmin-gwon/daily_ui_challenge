import 'package:flutter/material.dart';

class HoverEffectScreen extends StatefulWidget {
  const HoverEffectScreen({Key? key}) : super(key: key);

  @override
  State<HoverEffectScreen> createState() => _HoverEffectScreenState();
}

class _HoverEffectScreenState extends State<HoverEffectScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  static final pointerAnimation = Tween<double>(begin: 0, end: 1)
      .chain(CurveTween(curve: Curves.easeInOutCubic));

  final offsetNotifier = ValueNotifier<Offset?>(null);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void togglePointerSize(bool hovering) async {
    if (hovering) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MouseRegion(
        opaque: false,
        cursor: SystemMouseCursors.none,
        onHover: (e) => offsetNotifier.value = e.localPosition,
        onExit: (e) => offsetNotifier.value = null,
        child: ValueListenableBuilder<Offset?>(
            valueListenable: offsetNotifier,
            builder: (context, offset, child) {
              return Stack(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextColumn(
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          onLinkHovered: togglePointerSize,
                        ),
                      ),
                      Expanded(
                        child: TextColumn(
                          onLinkHovered: togglePointerSize,
                        ),
                      ),
                    ],
                  ),
                  if (offset != null) ...[
                    AnimatedBuilder(
                        animation: _controller,
                        builder: (context, snapshot) {
                          return AnimatedPointer(
                            pointerOffset: offset,
                            radius: 45 +
                                100 * _controller.drive(pointerAnimation).value,
                          );
                        }),
                    AnimatedPointer(
                      pointerOffset: offset,
                      movementDuration: const Duration(milliseconds: 200),
                      radius: 10,
                    )
                  ]
                ],
              );
            }),
      ),
    );
  }
}

class TextColumn extends StatelessWidget {
  const TextColumn({
    Key? key,
    required this.onLinkHovered,
    this.textColor = Colors.black,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  final Function(bool) onLinkHovered;
  final Color textColor;
  final Color backgroundColor;

  TextStyle get _defaultTextStyle => TextStyle(color: textColor);
  @override
  Widget build(BuildContext context) {
    return Ink(
      width: double.infinity,
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Hello',
            style: _defaultTextStyle.copyWith(fontSize: 30),
          ),
          const SizedBox(height: 20),
          Text('Check out this link:', style: _defaultTextStyle),
          const SizedBox(height: 30),
          InkWell(
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            onHover: onLinkHovered,
            mouseCursor: SystemMouseCursors.none,
            onTap: () => null,
            child: Ink(
              child: Column(
                children: [
                  Text('See what happens', style: _defaultTextStyle),
                  const SizedBox(height: 7),
                  Container(color: textColor, width: 50, height: 2)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedPointer extends StatelessWidget {
  const AnimatedPointer({
    Key? key,
    this.movementDuration = const Duration(milliseconds: 700),
    this.radius = 30,
    required this.pointerOffset,
  }) : super(key: key);
  final Duration movementDuration;
  final Offset pointerOffset;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: movementDuration,
      curve: Curves.easeOutExpo,
      top: pointerOffset.dy,
      left: pointerOffset.dx,
      child: CustomPaint(
        painter: Pointer(radius),
      ),
    );
  }
}

// Multiple containers stacked on top of each other will block hover events
// events, and the blending behaviour of an InkWell is a bit strange, so
// I resorted to using a CustomPainter.
class Pointer extends CustomPainter {
  final double radius;

  Pointer(this.radius);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      const Offset(0, 0),
      radius,
      Paint()
        ..color = Colors.white
        ..blendMode = BlendMode.difference,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
