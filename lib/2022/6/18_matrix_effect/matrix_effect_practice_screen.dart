import 'dart:math' as math;
import 'dart:async';

import 'package:flutter/material.dart';

class MatrixEffectPracticeScreen extends StatefulWidget {
  const MatrixEffectPracticeScreen({Key? key}) : super(key: key);

  @override
  State<MatrixEffectPracticeScreen> createState() =>
      _MatrixEffectPracticeScreenState();
}

class _MatrixEffectPracticeScreenState
    extends State<MatrixEffectPracticeScreen> {
  final List<Widget> _textLines = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(milliseconds: 300),
      (_) {
        setState(() {
          _textLines.add(
            _getTextLine(),
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
          children: _textLines,
        ),
      ),
    );
  }

  Widget _getTextLine() {
    final key = GlobalKey();
    final random = math.Random();
    return Positioned(
      key: key,
      left: random.nextDouble() * MediaQuery.of(context).size.width,
      child: VerticalText(
        speed: 1 + random.nextDouble() * 20,
        maxLength: random.nextInt(10) + 5,
        onFinish: () {
          setState(() {
            _textLines.removeWhere(
              (element) => element.key == key,
            );
          });
        },
      ),
    );
  }
}

class VerticalText extends StatefulWidget {
  const VerticalText({
    Key? key,
    required this.onFinish,
    this.speed = 12,
    this.maxLength = 10,
  }) : super(key: key);

  final double speed;
  final int maxLength;
  final VoidCallback onFinish;

  @override
  State<VerticalText> createState() => _VerticalTextState();
}

class _VerticalTextState extends State<VerticalText> {
  late Timer _timer;
  late Duration _stepInterval;

  final _characters = <String>[];

  @override
  void initState() {
    super.initState();
    _stepInterval = Duration(milliseconds: 1000 ~/ widget.speed);
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(_stepInterval, (timer) {
      final _random = math.Random();
      String element = String.fromCharCode(
        _random.nextInt(512),
      );
      final box = context.findRenderObject() as RenderBox;

      if (box.size.height > MediaQuery.of(context).size.height * 2) {
        widget.onFinish();
        return;
      }

      setState(() {
        _characters.add(element);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.transparent,
      Colors.greenAccent,
      Colors.greenAccent,
      Colors.white,
    ];

    double greenStart;
    double whiteStart = (_characters.length - 1) / _characters.length;

    if ((_characters.length - widget.maxLength) / _characters.length < 0.3) {
      greenStart = 0.3;
    } else {
      greenStart = (_characters.length - widget.maxLength) / _characters.length;
    }

    final stops = [0.0, greenStart, whiteStart, whiteStart];

    return _getShaderMask(stops, colors);
  }

  Widget _getShaderMask(List<double> stops, List<Color> colors) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
          stops: stops,
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcIn,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: _getCharacters(),
      ),
    );
  }

  List<Widget> _getCharacters() {
    final textCharacters = <Widget>[];

    for (var character in _characters) {
      textCharacters.add(Text(
        character,
        style: const TextStyle(color: Colors.white),
      ));
    }
    return textCharacters;
  }
}
