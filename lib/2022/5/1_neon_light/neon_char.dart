import 'package:flutter/material.dart';

enum EnergyLevel {
  high,
  low,
}

class NeonChar extends StatefulWidget {
  const NeonChar({
    Key? key,
    required this.letter,
    required this.color,
    required this.fontSize,
    required this.blurRadius,
    required this.glowing,
    this.energyLevel,
    this.textStyle,
    required this.glowDuration,
  }) : super(key: key);

  final String letter;
  final MaterialColor color;
  final double fontSize;
  final double blurRadius;
  final bool glowing;
  final EnergyLevel? energyLevel;
  final TextStyle? textStyle;
  final Duration glowDuration;

  @override
  State<NeonChar> createState() => _NeonCharState();
}

class _NeonCharState extends State<NeonChar>
    with SingleTickerProviderStateMixin {
  late AnimationController _shadowController;

  String get letter => widget.letter;
  double get fontSize => widget.fontSize;
  MaterialColor get color => widget.color;
  double get blurRadius => widget.blurRadius;
  bool get glowing => widget.glowing;
  Duration get glowingDuration => widget.glowDuration;
  TextStyle? get textStyle => widget.textStyle;
  EnergyLevel? get energyLevel => widget.energyLevel;

  @override
  void initState() {
    super.initState();
    _shadowController = AnimationController(
      vsync: this,
      duration: glowingDuration,
    );
  }

  @override
  void dispose() {
    _shadowController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant NeonChar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (glowing) {
      _shadowController.repeat(min: 0.2, max: 1, reverse: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shadowController,
      builder: (context, child) {
        final radius = _shadowController.value * blurRadius * 1.5;
        return Text(
          letter,
          style:
              textStyle?.copyWith(shadows: _getShadows(energyLevel, radius)) ??
                  TextStyle(
                    color: _getPrimaryColor(energyLevel),
                    fontSize: fontSize,
                    shadows: _getShadows(energyLevel, radius),
                  ),
        );
      },
    );
  }

  List<Shadow> _getShadows(EnergyLevel? energyLevel, double radius) {
    if (energyLevel == EnergyLevel.low) {
      return [
        Shadow(color: color[400]!, blurRadius: radius / 6),
      ];
    } else {
      return [
        Shadow(color: color[300]!, blurRadius: radius / 2),
        Shadow(color: color[400]!, blurRadius: radius),
        Shadow(color: color[500]!, blurRadius: radius * 3),
      ];
    }
  }

  Color? _getPrimaryColor(EnergyLevel? energyLevel) {
    return energyLevel == EnergyLevel.low ? color[300] : color[50];
  }
}
