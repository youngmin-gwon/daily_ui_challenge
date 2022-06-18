import 'dart:math' as math;
import 'dart:async';

import 'package:flutter/material.dart';

class MatrixEffectScreen extends StatefulWidget {
  const MatrixEffectScreen({Key? key}) : super(key: key);

  @override
  State<MatrixEffectScreen> createState() => _MatrixEffectScreenState();
}

class _MatrixEffectScreenState extends State<MatrixEffectScreen> {
  List<Widget> _verticalLines = [];
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    timer = Timer.periodic(
      const Duration(milliseconds: 300),
      (timer) {
        setState(() {
          _verticalLines.add(
            _getVerticalTextLine(),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          children: _verticalLines,
        ),
      ),
    );
  }

  Widget _getVerticalTextLine() {
    Key key = GlobalKey();
    return Positioned(
      key: key,
      left: math.Random().nextDouble() * MediaQuery.of(context).size.width,
      child: VerticalTextLine(
        speed: 1 + math.Random().nextDouble() * 9,
        maxLength: math.Random().nextInt(10) + 5,
        onFinished: () {
          setState(() {
            _verticalLines.removeWhere(
              (element) => element.key == key,
            );
          });
        },
      ),
    );
  }
}

class VerticalTextLine extends StatefulWidget {
  const VerticalTextLine({
    Key? key,
    this.speed = 12.0,
    this.maxLength = 10,
    required this.onFinished,
  }) : super(key: key);

  final double speed;
  final int maxLength;
  final VoidCallback onFinished;

  @override
  State<VerticalTextLine> createState() => _VerticalTextLineState();
}

class _VerticalTextLineState extends State<VerticalTextLine> {
  List<String> _characters = [];

  late Timer timer;
  late Duration _stepInterval;

  @override
  void initState() {
    super.initState();
    _stepInterval = Duration(milliseconds: (1000 ~/ widget.speed));
    _startTimer();
  }

  void _startTimer() {
    timer = Timer.periodic(
      _stepInterval,
      (timer) {
        final _random = math.Random();
        String element = String.fromCharCode(
          _random.nextInt(512),
        );

        final box = context.findRenderObject() as RenderBox;

        if (box.size.height > MediaQuery.of(context).size.height * 2) {
          widget.onFinished();
          return;
        }

        setState(() {
          _characters.add(element);
        });
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [
      Colors.transparent,
      Colors.green,
      Colors.green,
      Colors.white
    ];

    double greenStart;
    double whiteStart = (_characters.length - 1) / (_characters.length);

    if (((_characters.length - widget.maxLength) / _characters.length) < 0.3) {
      greenStart = 0.3;
    } else {
      greenStart = (_characters.length - widget.maxLength) / _characters.length;
    }

    List<double> stops = [0, greenStart, whiteStart, whiteStart];

    return _getShaderMask(stops, colors);
  }

  Widget _getShaderMask(List<double> stops, List<Color> colors) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: stops,
          colors: colors,
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcIn,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: _getCharacters(),
      ),
    );
  }

  List<Widget> _getCharacters() {
    List<Widget> textWidgets = [];

    for (final character in _characters) {
      textWidgets.add(
        Text(
          character,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      );
    }

    return textWidgets;
  }
}
