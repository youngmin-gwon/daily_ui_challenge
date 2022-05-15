import 'package:flutter/material.dart';

class ParallaxEffectScreen extends StatefulWidget {
  const ParallaxEffectScreen({Key? key}) : super(key: key);

  @override
  _ParallaxEffectScreenState createState() => _ParallaxEffectScreenState();
}

class _ParallaxEffectScreenState extends State<ParallaxEffectScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  double localX = 0;
  double localY = 0;
  bool defaultPosition = true;
  bool downButton = false;

  double scaleX = 1;
  double scaleY = 1;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _setupAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    )..addListener(() => setState(() {
          scaleX = animation.value;
          scaleY = animation.value;
        }));
    animation = Tween<double>(begin: 1, end: 0.9).animate(CurvedAnimation(
      curve: Curves.decelerate,
      parent: animationController,
    ));
  }

  void _scaleAnimation() {
    animationController.forward();
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => downButton = true);
        animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // double percentageX = (localX / (size.width * 0.45) / 2) * 100;
    // double percentageY = (localY / ((size.height / 2) + 70) / 1.5) * 100;

    final x = ValueNotifier<double>(0);
    final y = ValueNotifier<double>(0);

    double screen = (size.width - 150) / (1280 - 150);
    screen = screen > 1.0
        ? 1.0
        : screen < 0
            ? 0
            : screen;
    double limits = ((screen * 100) * (0.4 - 0.75) / 100) + 0.75;
    double fontSize = ((screen * 100) * (1.0 - 0.3) / 100) + 0.3;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          MaterialButton(
            onPressed: () {},
            child: const Text(
              "About Us",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {},
            child: const Text(
              "Contact",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Background(),
          const EngineInfo(),
          Align(
            alignment: Alignment.center,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(x.value)
                ..rotateY(y.value),
              child: MouseRegion(
                onHover: (event) {
                  print(event.localPosition.dx);
                },
                child: Container(
                  width: size.width / 1.5,
                  height: size.height / 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black38,
                          blurRadius: 12,
                          spreadRadius: 2,
                          offset: Offset(5, 5))
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Background extends StatelessWidget {
  const Background({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromRGBO(81, 45, 168, 0.8),
          Color.fromRGBO(245, 124, 0, 0.8),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
    );
  }
}

class EngineInfo extends StatelessWidget {
  const EngineInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "Powered By",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
            SizedBox(width: 12),
            FlutterLogo(size: 15),
          ],
        ),
      ),
    );
  }
}
