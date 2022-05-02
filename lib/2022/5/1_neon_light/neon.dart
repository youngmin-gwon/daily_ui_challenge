import 'package:async/async.dart';
import 'package:daily_ui/2022/5/1_neon_light/neon_char.dart';
import 'package:flutter/material.dart';

class Neon extends StatefulWidget {
  const Neon({
    Key? key,
    required this.text,
    required this.color,
    this.fontSize = 30,
    this.blurRadius = 30,
    this.flickeringText = false,
    this.flickeringLetters,
    this.glowing = false,
    this.glowingDuration = const Duration(milliseconds: 1500),
    this.textStyle,
  }) : super(key: key);

  final String text;
  final MaterialColor color;
  final double fontSize;
  final bool flickeringText;
  final List<int>? flickeringLetters;
  final double blurRadius;
  final bool glowing;
  final Duration glowingDuration;
  final TextStyle? textStyle;

  @override
  State<Neon> createState() => _NeonState();
}

class _NeonState extends State<Neon> with SingleTickerProviderStateMixin {
  late List<EnergyLevel?> _energyLevels;
  CancelableOperation? _cancelableWaitingForLowPower;
  CancelableOperation? _cancelableWaitingForHighPower;

  String get text => widget.text;
  MaterialColor get color => widget.color;
  double get fontSize => widget.fontSize;
  bool get flickeringText => widget.flickeringText;
  List<int>? get flickeringLetters => widget.flickeringLetters;
  double get blurRadius => widget.blurRadius;
  bool get glowing => widget.glowing;
  Duration get glowingDuration => widget.glowingDuration;
  TextStyle? get textStyle => widget.textStyle;

  @override
  void initState() {
    super.initState();
    _energyLevels = List.filled(text.length, null);
  }

  @override
  void dispose() {
    _cancelableWaitingForLowPower?.cancel();
    _cancelableWaitingForHighPower?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    );
  }
}
