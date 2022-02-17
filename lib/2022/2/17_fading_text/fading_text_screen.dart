import 'dart:ui' as ui;

import 'package:daily_ui/core/utils/math.dart';
import 'package:flutter/material.dart';

class FadingTextScreen extends StatelessWidget {
  const FadingTextScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 63, 63, 63),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: RotatingTextWidget(
          labels: List.generate(5, (index) => "$index item", growable: false),
        ),
      ),
    );
  }
}

class RotatingTextWidget extends StatefulWidget {
  const RotatingTextWidget({
    Key? key,
    required this.labels,
  }) : super(key: key);

  final List<String> labels;

  @override
  _RotatingTextWidgetState createState() => _RotatingTextWidgetState();
}

class _RotatingTextWidgetState extends State<RotatingTextWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late String _label1;
  late String _label2;

  late List<String> rotatingLabels;

  static const Curve _curve = Interval(
    0.3,
    0.7,
    curve: Curves.easeInOut,
  );

  void _setLabels() {
    if (widget.labels.isEmpty) {
      rotatingLabels = [
        "Not enough Value provided",
        "Not enough Value provided",
      ];
    } else if (widget.labels.length < 2) {
      rotatingLabels = [
        widget.labels.first,
        widget.labels.first,
      ];
    } else {
      rotatingLabels = widget.labels;
    }

    _allocateLabel();
  }

  void _rotate() {
    juggleLeft(rotatingLabels, 1);
    _allocateLabel();
  }

  void _allocateLabel() {
    _label1 = rotatingLabels[0];
    _label2 = rotatingLabels[1];
  }

  @override
  void initState() {
    super.initState();
    _setLabels();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            _rotate();
            _controller.forward(from: 0);
          }
        },
      )
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RotatingPainter(
        label1: _label1,
        label2: _label2,
        scrollPosition: _curve.transform(_controller.value),
        textColor: Colors.white,
      ),
      size: const Size(double.infinity, 50),
    );
  }
}

class RotatingPainter extends CustomPainter {
  final String label1;
  final String label2;
  final double fontSize;
  final double scrollPosition;
  late LinearGradient _fadeGradient;

  RotatingPainter({
    required this.label1,
    required this.label2,
    required Color textColor,
    this.fontSize = 24,
    this.scrollPosition = 0,
  }) {
    _fadeGradient = LinearGradient(
      colors: [
        textColor.withOpacity(0.0),
        textColor,
        textColor,
        textColor.withOpacity(0.0),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: const [0.05, 0.3, 0.7, 0.95],
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    // for opacity
    final fadeShader = _fadeGradient.createShader(
      Rect.fromLTWH(0, 0, size.width, size.height),
    );
    final fadePaint = Paint()..shader = fadeShader;

    final paragraph1 = _buildParagraph(size, label1, fadePaint);
    final textHeight = paragraph1.height;
    final standardOffset = Offset(
      0,
      (size.height - textHeight) / 2 + size.height * scrollPosition,
    );

    // Paragraph, ParagraphBuilder 모두 package:ui 로 부터 나옴
    // 따로 style을 지정하기 위해서는 TextStyle을 써야하는데 package:widgets(상위 library)에 중복 됨
    canvas.drawParagraph(paragraph1, standardOffset);

    final dependentOffset = standardOffset.translate(0, -size.height);

    final ui.Paragraph paragraph2 = _buildParagraph(size, label2, fadePaint);
    canvas.drawParagraph(paragraph2, dependentOffset);
  }

  ui.Paragraph _buildParagraph(Size availableSpace, String label, Paint paint) {
    // ParagraphBuilder : for text drawing
    ui.ParagraphBuilder paragraphBuilder =
        ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: ui.TextAlign.center,
      maxLines: 1,
    ))
          // 순서가 매우 중요하다
          ..pushStyle(
            ui.TextStyle(
              foreground: paint,
              fontSize: fontSize,
            ),
          )
          ..addText(label);
    return paragraphBuilder.build()
      ..layout(
        ui.ParagraphConstraints(
          width: availableSpace.width,
        ),
      );
  }

  @override
  bool shouldRepaint(covariant RotatingPainter oldDelegate) {
    return true;
  }
}
