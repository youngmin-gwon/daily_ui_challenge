import 'package:flutter/material.dart';

class FillingButtonScreen extends StatefulWidget {
  const FillingButtonScreen({Key? key}) : super(key: key);

  @override
  _FillingButtonScreenState createState() => _FillingButtonScreenState();
}

class _FillingButtonScreenState extends State<FillingButtonScreen>
    with TickerProviderStateMixin {
  late AnimationController _buttonAnimController;
  late AnimationController _birdAnimController;

  static final _fillTween =
      CurveTween(curve: const Interval(0, 0.9, curve: Curves.ease));

  static final _glowTween = Tween<double>(
    begin: 0,
    end: 6,
  ).chain(
    CurveTween(curve: const Interval(0.4, 1, curve: Curves.easeOut)),
  );

  static final _buttonScaleTween = Tween<double>(
    begin: 0,
    end: 5,
  ).chain(
    CurveTween(curve: Curves.ease),
  );

  static final _textColorTween = ColorTween(
    begin: Colors.white,
    end: Colors.black,
  ).chain(CurveTween(curve: Curves.decelerate));

  @override
  void initState() {
    super.initState();
    _buttonAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _birdAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  static const _backgroundColor = Color.fromARGB(255, 48, 45, 45);

  @override
  void dispose() {
    _buttonAnimController.dispose();
    _birdAnimController.dispose();
    super.dispose();
  }

  void toggleAnimation(bool hovering) {
    if (hovering) {
      _buttonAnimController.forward();
      _birdAnimController.repeat(reverse: true);
    } else {
      _buttonAnimController.reverse();
      _birdAnimController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: InkWell(
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          onHover: toggleAnimation,
          child: GestureDetector(
            onTapDown: (_) {
              _buttonAnimController.forward();
              _birdAnimController.repeat(reverse: true);
            },
            onTapUp: (_) {
              _buttonAnimController.reverse();
              _birdAnimController.reverse();
            },
            child: AnimatedBuilder(
                animation: _buttonAnimController,
                builder: (context, child) {
                  return Container(
                    width: 250 +
                        _buttonAnimController.drive(_buttonScaleTween).value,
                    height: 60 +
                        _buttonAnimController.drive(_buttonScaleTween).value,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: _backgroundColor,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius:
                              _buttonAnimController.drive(_glowTween).value,
                        ),
                      ],
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CustomPaint(
                          painter: FillingPainter(
                            fillPercent:
                                _buttonAnimController.drive(_fillTween).value,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AnimatedBuilder(
                              animation: _birdAnimController,
                              builder: (context, child) {
                                return FractionalTranslation(
                                  translation: Offset(
                                      0, -0.5 * _birdAnimController.value),
                                  child: child,
                                );
                              },
                              child: Image.network(
                                "https://upload.wikimedia.org/wikipedia/ko/thumb/9/9e/트위터_로고_%282012%29.svg/172px-트위터_로고_%282012%29.svg.png",
                                width: 30,
                              ),
                            ),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: TextStyle(
                                color: _buttonAnimController
                                    .drive(_textColorTween)
                                    .value,
                                fontWeight: FontWeight.w600,
                              ),
                              child: const Text(
                                "SHARE IT ON TWITTER!",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}

class FillingPainter extends CustomPainter {
  const FillingPainter({required this.fillPercent});

  final double fillPercent;

  static final _paint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.lineTo(size.width * fillPercent, 0);
    path.lineTo(size.width * fillPercent, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(covariant FillingPainter oldDelegate) {
    return fillPercent != oldDelegate.fillPercent;
  }
}
