import 'package:flutter/material.dart';

import 'package:daily_ui/2022/3/1/next_page.dart';

class PageTransitionExample extends StatefulWidget {
  const PageTransitionExample({Key? key}) : super(key: key);

  @override
  State<PageTransitionExample> createState() => _PageTransitionExampleState();
}

class _PageTransitionExampleState extends State<PageTransitionExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  static final _slideTween =
      Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).chain(
    CurveTween(
      curve: const Interval(0, 0.3, curve: Curves.easeInOutCirc),
    ),
  );

  late Animatable<Offset> _topLeftOffsetTween;
  late Animatable<Offset> _topRightOffsetTween;
  late Animatable<Offset> _bottomLeftOffsetTween;
  late Animatable<Offset> _bottomRightOffsetTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1000,
      ),
    );
    _setOffsetTween(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setOffsetTween(BuildContext context) {
    _topLeftOffsetTween =
        Tween<Offset>(begin: Offset.zero, end: const Offset(-100, -100)).chain(
      CurveTween(
        curve: const Interval(
          0.3,
          0.75,
          curve: Curves.ease,
        ),
      ),
    );
    _topRightOffsetTween =
        Tween<Offset>(begin: const Offset(200, 0), end: const Offset(300, -100))
            .chain(
      CurveTween(
        curve: const Interval(
          0.45,
          0.9,
          curve: Curves.ease,
        ),
      ),
    );
    _bottomLeftOffsetTween =
        Tween<Offset>(begin: const Offset(0, 250), end: const Offset(-100, 350))
            .chain(
      CurveTween(
        curve: const Interval(
          0.4,
          0.85,
          curve: Curves.ease,
        ),
      ),
    );
    _bottomRightOffsetTween = Tween<Offset>(
            begin: const Offset(200, 250), end: const Offset(300, 350))
        .chain(
      CurveTween(
        curve: const Interval(
          0.55,
          0.95,
          curve: Curves.ease,
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 2000),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const NextScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          SlideTransition(
            position: _controller.drive(_slideTween),
            child: Container(
              color: Colors.green,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          Positioned(
            bottom: size.height / 10,
            child: GestureDetector(
              onTap: () {
                if (_controller.status == AnimationStatus.dismissed) {
                  _controller.forward(from: 0);
                } else if (_controller.status == AnimationStatus.completed) {
                  _controller.reverse(from: 1);
                }
              },
              child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: StrechPainter(
                        topLeft: _controller.drive(_topLeftOffsetTween).value,
                        topRight: _controller.drive(_topRightOffsetTween).value,
                        bottomLeft:
                            _controller.drive(_bottomLeftOffsetTween).value,
                        bottomRight:
                            _controller.drive(_bottomRightOffsetTween).value,
                      ),
                      size: const Size(200, 250),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class StrechPainter extends CustomPainter {
  final Offset topLeft;
  final Offset topRight;
  final Offset bottomLeft;
  final Offset bottomRight;

  const StrechPainter({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
  });

  static final _paint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.amber;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(topLeft.dx, topLeft.dy);
    path.lineTo(topRight.dx, topRight.dy);
    path.lineTo(bottomRight.dx, bottomRight.dy);
    path.lineTo(bottomLeft.dx, bottomLeft.dy);
    path.close();

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(covariant StrechPainter oldDelegate) {
    return topLeft != oldDelegate.topLeft ||
        topRight != oldDelegate.topRight ||
        bottomLeft != oldDelegate.bottomLeft ||
        bottomRight != oldDelegate.bottomRight;
  }
}
