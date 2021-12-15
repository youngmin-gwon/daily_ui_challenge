import 'package:flutter/material.dart';

class Screen20211215 extends StatefulWidget {
  const Screen20211215({Key? key}) : super(key: key);

  @override
  State<Screen20211215> createState() => _Screen20211215State();
}

class _Screen20211215State extends State<Screen20211215>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 400,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.2),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.2),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    const _WindowBackgroundWidget(),
                    const _WindowBlindWidget(),
                    CustomPaint(
                      painter: BlindLinePainter(
                        startPosition: Offset(0, 0.0),
                        stopPosition: Offset(0, 50.0),
                      ),
                    ),
                    const _WindowBlindHeaderWidget(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Slider(
              value: 0,
              onChanged: (double newValue) {},
            )
          ],
        ),
      ),
    );
  }
}

class _WindowBackgroundWidget extends StatelessWidget {
  const _WindowBackgroundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          gradient: const RadialGradient(
            center: Alignment.topCenter,
            radius: 3.0,
            colors: [
              Color(0xFF98B9F2),
              Color(0xFF6895E2),
            ],
            stops: [
              0.1,
              0.4,
            ],
          )),
    );
  }
}

class _WindowBlindHeaderWidget extends StatelessWidget {
  const _WindowBlindHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 6,
        left: 8,
        right: 8,
      ),
      height: 22,
      decoration: BoxDecoration(
        color: const Color(0xFFFCFBFB),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
          bottomLeft: Radius.circular(2),
          bottomRight: Radius.circular(2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.4),
            offset: const Offset(3.0, 2.0),
            blurRadius: 2,
            spreadRadius: 1.0,
          ),
          BoxShadow(
            color: Colors.grey.withOpacity(.4),
            offset: const Offset(-3.0, 2.0),
            blurRadius: 2,
            spreadRadius: 1.0,
          ),
        ],
      ),
    );
  }
}

class _WindowBlindWidget extends StatelessWidget {
  const _WindowBlindWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 35,
        left: 14,
        right: 14,
      ),
      height: 22,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.4),
            offset: const Offset(1, 1),
            blurRadius: 20,
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey[300]!,
            Colors.grey[200]!,
            Colors.grey[100]!,
            Colors.white,
          ],
          stops: const [
            0.1,
            0.2,
            0.3,
            0.5,
          ],
        ),
      ),
    );
  }
}

class BlindLinePainter extends CustomPainter {
  final Offset startPosition;
  final Offset stopPosition;
  final Color color;

  BlindLinePainter({
    required this.startPosition,
    required this.stopPosition,
    this.color = Colors.grey,
  });

  final Paint linePaint = Paint()
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    linePaint.color = color;

    canvas.drawLine(
      startPosition,
      stopPosition,
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant BlindLinePainter oldDelegate) {
    return startPosition != oldDelegate.startPosition ||
        stopPosition != oldDelegate.stopPosition;
  }
}
