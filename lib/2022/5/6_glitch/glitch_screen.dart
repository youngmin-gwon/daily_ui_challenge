import 'dart:math' as math;
import 'package:daily_ui/2022/5/6_glitch/fake_price_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'currency.dart';
import 'glitch_theme.dart' as theme;

class GlitchScreen extends StatelessWidget {
  const GlitchScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: const Color(0xFF120821),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: FakePriceChangeWidget(builder: (context, price) {
            return GlitchyPrice(
              price: price,
            );
          }),
        ),
      ),
    );
  }
}

class GlitchyPrice extends StatefulWidget {
  const GlitchyPrice({
    Key? key,
    required this.price,
    this.baseTextStyle = const TextStyle(fontSize: 64),
    this.priceIncreaseColor = theme.glitchPriceIncreaseColor,
    this.priceDecreaseColor = theme.glitchPriceDecreaseColor,
  }) : super(key: key);

  final TextStyle baseTextStyle;
  final Color priceIncreaseColor;
  final Color priceDecreaseColor;
  final Usd price;
  @override
  State<GlitchyPrice> createState() => _GlitchyPriceState();
}

class _GlitchyPriceState extends State<GlitchyPrice>
    with SingleTickerProviderStateMixin {
  static const _glitchDuration = Duration(milliseconds: 500);

  late Ticker _ticker;
  double _glitchOffset = 0.0;
  Duration? _glitchStartTime;
  late Color _glitchColor;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _glitchColor = widget.priceIncreaseColor;
  }

  @override
  void dispose() {
    _ticker
      ..stop()
      ..dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant GlitchyPrice oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.price != oldWidget.price) {
      if (widget.price > oldWidget.price) {
        _glitchColor = widget.priceIncreaseColor;
      } else {
        _glitchColor = widget.priceDecreaseColor;
      }

      _glitch();
    }
  }

  void _onTick(Duration elapsed) {
    if (_glitchStartTime == null) {
      _ticker.stop();
      return;
    }

    final dt = elapsed - _glitchStartTime!;
    if (dt >= _glitchDuration) {
      _glitchStartTime = null;
      _ticker.stop();
    }

    // offset maximum
    const maxOffset = 15;
    // completion percentage
    final percent = dt.inMilliseconds / _glitchDuration.inMilliseconds;

    if (mounted) {
      setState(() {
        final jitterPercent =
            math.sin(maxOffset * math.sin(percent * math.pi * 5));
        _glitchOffset = maxOffset * math.sin(percent * math.pi) * jitterPercent;
      });
    }
  }

  void _glitch() {
    _ticker.stop();

    _glitchStartTime = Duration.zero;
    _ticker.start();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -_glitchOffset,
          child: Text(
            widget.price.toFormattedString(),
            style: widget.baseTextStyle.copyWith(
              color: _glitchColor.withOpacity(.7),
            ),
          ),
        ),
        Positioned(
          left: _glitchOffset,
          child: Text(
            widget.price.toFormattedString(),
            style: widget.baseTextStyle.copyWith(
              color: _glitchColor.withOpacity(.7),
            ),
          ),
        ),
        Text(
          widget.price.toFormattedString(),
          style: widget.baseTextStyle,
        ),
      ],
    );
  }
}
