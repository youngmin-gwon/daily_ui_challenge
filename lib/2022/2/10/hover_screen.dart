import 'package:flutter/material.dart';

import '../../../core/presentation/responsive_widget.dart';

class HoverEffectScreen extends StatelessWidget {
  const HoverEffectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const ResponsiveWidget(
        mobile: HoverEffectPage(isMobileSize: true),
        tablet: HoverEffectPage(),
        desktop: HoverEffectPage(),
      ),
    );
  }
}

class HoverEffectPage extends StatefulWidget {
  const HoverEffectPage({
    Key? key,
    this.isMobileSize = false,
  }) : super(key: key);

  final bool isMobileSize;

  @override
  State<HoverEffectPage> createState() => _HoverEffectPageState();
}

class _HoverEffectPageState extends State<HoverEffectPage>
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

  void togglePointerSize(bool hovering) {
    if (hovering) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final children = [
      Expanded(
        child: TextColumn(
          backgroundColor: Colors.black,
          textColor: Colors.white,
          onLinkHovered: togglePointerSize,
        ),
      ),
      Expanded(
        child: GestureDetector(
          child: TextColumn(
            onLinkHovered: togglePointerSize,
          ),
        ),
      ),
    ];

    return MouseRegion(
      opaque: false,
      cursor: SystemMouseCursors.none,
      onHover: (e) => offsetNotifier.value = e.localPosition,
      onExit: (e) => offsetNotifier.value = null,
      child: ValueListenableBuilder<Offset?>(
        valueListenable: offsetNotifier,
        builder: (context, value, child) {
          return Stack(
            children: [
              if (widget.isMobileSize)
                Column(
                  children: children,
                )
              else
                Row(
                  children: children,
                ),
              if (offsetNotifier.value != null) ...[
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return AnimatedPointer(
                      pointerOffset: offsetNotifier.value!,
                      radius:
                          45 + 100 * _controller.drive(pointerAnimation).value,
                    );
                  },
                ),
                AnimatedPointer(
                  pointerOffset: offsetNotifier.value!,
                  movementDuration: const Duration(milliseconds: 10),
                  radius: 10,
                ),
              ],
            ],
          );
        },
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

  final void Function(bool) onLinkHovered;
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
          Text("Hello", style: _defaultTextStyle.copyWith(fontSize: 30)),
          const SizedBox(height: 20),
          Text("Check out this link:", style: _defaultTextStyle),
          const SizedBox(height: 30),
          InkWell(
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            onHover: onLinkHovered,
            mouseCursor: SystemMouseCursors.none,
            onTap: () {},
            child: Column(
              children: [
                Text('See what happens', style: _defaultTextStyle),
                const SizedBox(height: 7),
                Container(color: textColor, width: 50, height: 2)
              ],
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
    required this.pointerOffset,
    this.radius = 30,
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

class Pointer extends CustomPainter {
  final double radius;

  const Pointer(this.radius);

  static final _paint = Paint()
    ..color = Colors.white
    ..blendMode = BlendMode.difference;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(const Offset(0, 0), radius, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
