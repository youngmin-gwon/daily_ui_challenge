import 'package:flutter/material.dart';

class ShimmerTextScreen extends StatefulWidget {
  const ShimmerTextScreen({Key? key}) : super(key: key);

  @override
  State<ShimmerTextScreen> createState() => _ShimmerTextScreenState();
}

class _ShimmerTextScreenState extends State<ShimmerTextScreen> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: const Center(
          child: _Shimmer(
            child: Text(
              "Hello World!",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Shimmer extends StatefulWidget {
  const _Shimmer({
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  State<_Shimmer> createState() => __ShimmerState();
}

class __ShimmerState extends State<_Shimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat();
    _shimmerAnimation = CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.ease,
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  RadialGradient get gradient => RadialGradient(
          colors: const [
            Color.fromARGB(100, 0, 255, 217),
            Color.fromARGB(100, 0, 255, 115),
            Color.fromARGB(100, 229, 255, 0),
            Color(0xFF3E3E3E),
          ],
          stops: const [
            0.01,
            0.15,
            0.30,
            0.45,
          ],
          tileMode: TileMode.clamp,
          center: const Alignment(-1, -0.7),
          radius: 4,
          transform:
              _SlidingGradientTransform(slidePercent: _shimmerAnimation.value));

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return gradient.createShader(bounds);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({
    required this.slidePercent,
  });

  final double slidePercent;
  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}
