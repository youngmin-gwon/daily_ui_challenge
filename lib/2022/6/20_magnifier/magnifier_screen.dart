import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MagnifierScreen extends StatefulWidget {
  const MagnifierScreen({Key? key}) : super(key: key);

  @override
  State<MagnifierScreen> createState() => _MagnifierScreenState();
}

class _MagnifierScreenState extends State<MagnifierScreen> {
  double touchBubbleSize = 20;

  Offset? position;
  late double currentBubbleSize;
  bool magnifierVisible = false;

  @override
  void initState() {
    super.initState();
    currentBubbleSize = touchBubbleSize;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
  }

  void _startDragging(Offset newPosition) {
    setState(() {
      magnifierVisible = true;
      position = newPosition;
      currentBubbleSize = touchBubbleSize * 1.5;
    });
  }

  void _drag(Offset newPosition) {
    setState(() {
      position = newPosition;
    });
  }

  void _endDragging() {
    setState(() {
      currentBubbleSize = touchBubbleSize;
      magnifierVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Magnifier(
            child: Image.asset("assets/images/lenna.png"),
            position: position,
            visible: magnifierVisible,
          ),
          TouchBubble(
            position: position,
            bubbleSize: currentBubbleSize,
            onStartDragging: _startDragging,
            onDrag: _drag,
            onEndDragging: _endDragging,
          ),
        ],
      ),
    );
  }
}

class TouchBubble extends StatelessWidget {
  const TouchBubble({
    Key? key,
    required this.position,
    required this.bubbleSize,
    required this.onStartDragging,
    required this.onDrag,
    required this.onEndDragging,
  })  : assert(bubbleSize > 0),
        super(key: key);

  final Offset? position;
  final double bubbleSize;
  final Function(Offset) onStartDragging;
  final Function(Offset) onDrag;
  final Function onEndDragging;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position == null ? 0 : position!.dy - bubbleSize / 2,
      left: position == null ? 0 : position!.dx - bubbleSize / 2,
      child: GestureDetector(
        onPanStart: (details) => onStartDragging(details.globalPosition),
        onPanUpdate: (details) => onDrag(details.globalPosition),
        onPanEnd: (_) => onEndDragging(),
        child: Container(
          width: bubbleSize,
          height: bubbleSize,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.5)),
        ),
      ),
    );
  }
}

class Magnifier extends StatefulWidget {
  const Magnifier({
    Key? key,
    required this.child,
    required this.position,
    this.visible = true,
    this.scale = 1.5,
    this.size = const Size(160, 160),
  }) : super(key: key);

  final Widget child;
  final Offset? position;
  final bool visible;
  final double scale;
  final Size size;

  @override
  State<Magnifier> createState() => _MagnifierState();
}

class _MagnifierState extends State<Magnifier> {
  late Size _magnifierSize;
  late double _scale;
  late Matrix4 _matrix;

  @override
  void initState() {
    super.initState();
    _magnifierSize = widget.size;
    _scale = widget.scale;
    _calculateMatrix();
  }

  @override
  void didUpdateWidget(covariant Magnifier oldWidget) {
    super.didUpdateWidget(oldWidget);

    _calculateMatrix();
  }

  void _calculateMatrix() {
    if (widget.position == null) {
      return;
    }

    setState(() {
      double newX = widget.position!.dx - (_magnifierSize.width / 2 / _scale);
      double newY = widget.position!.dy - (_magnifierSize.height / 2 / _scale);

      final updateMatrix = Matrix4.identity()
        ..scale(_scale, _scale)
        ..translate(-newX, -newY);

      _matrix = updateMatrix;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.visible && widget.position != null) _getMagnifier(),
      ],
    );
  }

  Widget _getMagnifier() {
    return Align(
      alignment: _getAlignment(),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.matrix(_matrix.storage),
          child: CustomPaint(
            painter: MagnifierPainter(
                color: Theme.of(context).colorScheme.secondary),
            size: _magnifierSize,
          ),
        ),
      ),
    );
  }

  Alignment _getAlignment() {
    if (_bubbleCrossesMagnifier()) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  bool _bubbleCrossesMagnifier() =>
      widget.position!.dx < widget.size.width &&
      widget.position!.dy < widget.size.height;
}

class MagnifierPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;

  const MagnifierPainter({
    this.strokeWidth = 5,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawCircle(canvas, size);
    _drawCrosshair(canvas, size);
  }

  void _drawCircle(Canvas canvas, Size size) {
    Paint paintObject = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color;

    canvas.drawCircle(
        size.center(const Offset(0, 0)), size.longestSide / 2, paintObject);
  }

  void _drawCrosshair(Canvas canvas, Size size) {
    Paint crossPaint = Paint()
      ..strokeWidth = strokeWidth / 2
      ..color = color;

    double crossSize = size.longestSide * 0.04;

    canvas.drawLine(size.center(Offset(-crossSize, -crossSize)),
        size.center(Offset(crossSize, crossSize)), crossPaint);

    canvas.drawLine(size.center(Offset(crossSize, -crossSize)),
        size.center(Offset(-crossSize, crossSize)), crossPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
