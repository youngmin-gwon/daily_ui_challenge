import 'package:flutter/material.dart';

const _shimmerGradient = LinearGradient(
  colors: [
    Color(0xFF121212),
    Color(0xFF454545),
    Color(0xFF121212),
  ],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment(-1, -3),
  end: Alignment(1, 3),
  tileMode: TileMode.clamp,
);

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
        appBar: AppBar(),
        body: Center(
          child: _Shimmer(
            linearGradient: _shimmerGradient,
            child: _ShimmerLoading(
              child: Text("Hello World!"),
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
    required this.linearGradient,
  }) : super(key: key);

  final Widget? child;
  final LinearGradient linearGradient;

  static __ShimmerState? of(BuildContext context) {
    return context.findRootAncestorStateOfType<__ShimmerState>();
  }

  @override
  State<_Shimmer> createState() => __ShimmerState();
}

class __ShimmerState extends State<_Shimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController.unbounded(
      vsync: this,
    )..repeat(
        min: -0.5,
        max: 1.5,
        period: const Duration(seconds: 1),
      );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  Listenable get shimmerChanges =>
      CurvedAnimation(parent: _shimmerController, curve: Curves.slowMiddle);

  LinearGradient get gradient => LinearGradient(
        colors: widget.linearGradient.colors,
        stops: widget.linearGradient.stops,
        begin: widget.linearGradient.begin,
        end: widget.linearGradient.end,
        transform: _SlidingGradientTransform(
          slidePercent: _shimmerController.value,
        ),
      );

  bool get isSized =>
      (context.findRenderObject() as RenderBox?)?.hasSize ?? false;

  Size get size => (context.findRenderObject() as RenderBox).size;

  Offset getDescendantOffset({
    required RenderBox descendant,
    Offset offset = Offset.zero,
  }) {
    final shimmerBox = context.findRenderObject() as RenderBox;
    return descendant.localToGlobal(offset, ancestor: shimmerBox);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
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

class _ShimmerLoading extends StatefulWidget {
  const _ShimmerLoading({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  State<_ShimmerLoading> createState() => __ShimmerLoadingState();
}

class __ShimmerLoadingState extends State<_ShimmerLoading> {
  Listenable? _shimmerChange;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_shimmerChange != null) {
      _shimmerChange!.removeListener(_onShimmerChange);
    }
    _shimmerChange = _Shimmer.of(context)?.shimmerChanges;
    if (_shimmerChange != null) {
      _shimmerChange!.addListener(_onShimmerChange);
    }
  }

  @override
  void dispose() {
    _shimmerChange?.removeListener(_onShimmerChange);
    super.dispose();
  }

  void _onShimmerChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Collect ancestor shimmer information
    final shimmer = _Shimmer.of(context)!;
    if (!shimmer.isSized) {
      return const SizedBox();
    }

    final shimmerSize = shimmer.size;
    final gradient = shimmer.gradient;
    final offsetWithinShimmer = shimmer.getDescendantOffset(
      descendant: context.findRenderObject() as RenderBox,
    );

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return gradient.createShader(Rect.fromLTWH(
          -offsetWithinShimmer.dx,
          -offsetWithinShimmer.dy,
          shimmerSize.width,
          shimmerSize.height,
        ));
      },
      child: widget.child,
    );
  }
}
