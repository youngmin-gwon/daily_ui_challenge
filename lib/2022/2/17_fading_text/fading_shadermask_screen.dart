import 'package:flutter/material.dart';

class FadingShaderMaskScreen extends StatefulWidget {
  const FadingShaderMaskScreen({Key? key}) : super(key: key);

  @override
  State<FadingShaderMaskScreen> createState() => _FadingShaderMaskScreenState();
}

class _FadingShaderMaskScreenState extends State<FadingShaderMaskScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  String _label1 = "Not yet disappearing";
  String _label2 = "Tada!";

  static const Curve _curve = Interval(
    0.3,
    0.7,
    curve: Curves.easeInOut,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _switchLabels();
          _controller.forward(from: 0);
        }
      })
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _switchLabels() {
    if (_label1 == "Not yet disappearing") {
      _label1 = "Tada!";
      _label2 = "Not yet disappearing";
    } else {
      _label1 = "Not yet disappearing";
      _label2 = "Tada!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 63, 63, 63),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: ClipRect(
            child: ShaderMask(
              // shader region
              shaderCallback: (Rect availableSpace) {
                return LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0),
                    Colors.white,
                    Colors.white,
                    Colors.white.withOpacity(0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [
                    0.05,
                    0.3,
                    0.7,
                    0.95,
                  ],
                ).createShader(availableSpace);
              },
              child: SizedBox(
                width: double.infinity,
                height: 30,
                child: Stack(
                  children: [
                    FractionalTranslation(
                      translation:
                          Offset(0, -1 + _curve.transform(_controller.value)),
                      child: Center(
                        child: Text(
                          _label2,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    FractionalTranslation(
                      translation:
                          Offset(0.0, _curve.transform(_controller.value)),
                      child: Center(
                        child: Text(
                          _label1,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
