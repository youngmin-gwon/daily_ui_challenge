import 'dart:math';

import 'package:daily_ui/2022/1/13/demo_data.dart';
import 'package:daily_ui/2022/1/13/liquid_painter.dart';
import 'package:daily_ui/2022/1/13/rounded_shadow.dart';
import 'package:daily_ui/2022/1/13/styles.dart';
import 'package:flutter/material.dart';

class DrinkCard extends StatefulWidget {
  static double nominalHeightClosed = 96;
  static double nominalHeightOpen = 290;

  final Function(DrinkData)? onTap;

  final bool isOpen;
  final DrinkData drinkData;
  final int earnedPoints;

  const DrinkCard({
    Key? key,
    this.onTap,
    this.isOpen = false,
    this.earnedPoints = 100,
    required this.drinkData,
  }) : super(key: key);

  @override
  _DrinkCardState createState() => _DrinkCardState();
}

class _DrinkCardState extends State<DrinkCard>
    with SingleTickerProviderStateMixin {
  late bool _wasOpen = false;
  late Animation<double> _fillTween;
  late Animation<double> _pointsTween;
  late AnimationController _liquidSimController;

  // Create 2 simulations, taht will be passed to the LiquidPainter to be drawn
  final _liquidSim1 = LiquidSimulation();
  final _liquidSim2 = LiquidSimulation();

  @override
  void initState() {
    _liquidSimController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000));
    _liquidSimController.addListener(_rebuildIfOpen);
    _fillTween = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _liquidSimController,
        curve: const Interval(.12, .45, curve: Curves.easeOut),
      ),
    );
    _pointsTween = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _liquidSimController,
        curve: const Interval(.1, .5, curve: Curves.easeOutQuart),
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _liquidSimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If our open state has changed...
    if (widget.isOpen != _wasOpen) {
      // Kickoff the fill animations if we're opening up
      if (widget.isOpen) {
        // Start both of the liquid simulations, they will initialize to random values
        _liquidSim1.start(_liquidSimController, true);
        _liquidSim2.start(_liquidSimController, false);
        // Run the animation controller, kicking off all tweens
        _liquidSimController.forward(from: 0);
      }
      _wasOpen = widget.isOpen;
    }

    // Determine the points required text value, using the _pointsTween
    var pointsRequired = widget.drinkData.requiredPoints;
    var pointsValue = pointsRequired -
        _pointsTween.value * min(widget.earnedPoints, pointsRequired);
    // Determine current fill level, based on _fillTween
    double _maxFillLevel =
        min(1, widget.earnedPoints / widget.drinkData.requiredPoints);
    double fillLevel = _maxFillLevel; // _maxFillLevel * _fillTween.value;
    double cardHeight = widget.isOpen
        ? DrinkCard.nominalHeightOpen
        : DrinkCard.nominalHeightClosed;

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        curve: !_wasOpen ? const ElasticOutCurve(.9) : Curves.elasticOut,
        duration: Duration(milliseconds: !_wasOpen ? 1200 : 1500),
        height: cardHeight,
        child: RoundedShadow.fromRadius(
          12,
          child: Container(
            color: const Color(0xFF303238),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background liquid layer
                AnimatedOpacity(
                  opacity: widget.isOpen ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
                  child: _buildLiquidBackground(_maxFillLevel, fillLevel),
                ),

                // Card Content
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        // Top Header Row
                        _buildTopContent(),
                        // Spacer
                        const SizedBox(height: 12),
                        // Bottom Content, use AnimatedOpacity to fade
                        AnimatedOpacity(
                          opacity: widget.isOpen ? 1 : 0,
                          duration: Duration(
                              milliseconds: widget.isOpen ? 1000 : 500),
                          curve: Curves.easeOut,
                          child: _buildBottomContent(pointsValue),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stack _buildLiquidBackground(double _maxFillLevel, double fillLevel) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Transform.translate(
          offset: Offset(
            0,
            DrinkCard.nominalHeightOpen * 1.2 -
                DrinkCard.nominalHeightOpen *
                    _fillTween.value *
                    _maxFillLevel *
                    1.2,
          ),
          child: CustomPaint(
            painter: LiquidPainter(
                fillLevel: fillLevel,
                simulation1: _liquidSim1,
                simulation2: _liquidSim2,
                waveHeight: 100),
          ),
        )
      ],
    );
  }

  Row _buildTopContent() {
    return Row(
      children: [
        // Icon
        Image.asset(
          widget.drinkData.iconImage,
          fit: BoxFit.fitWidth,
          width: 50,
        ),
        const SizedBox(width: 24),
        //Label
        Expanded(
          child: Text(
            widget.drinkData.title.toUpperCase(),
            style: Styles.text(18, Colors.white, true),
          ),
        ),
        //Star Icon
        Icon(Icons.star, size: 20, color: AppColors.orangeAccent),
        const SizedBox(width: 4),
        //Points Text
        Text("${widget.drinkData.requiredPoints}",
            style: Styles.text(20, Colors.white, true))
      ],
    );
  }

  Column _buildBottomContent(double pointsValue) {
    bool isDisabled = widget.earnedPoints < widget.drinkData.requiredPoints;

    List<Widget> rowChildren = [];
    if (pointsValue == 0) {
      rowChildren.add(
          Text("Congratulations!", style: Styles.text(16, Colors.white, true)));
    } else {
      rowChildren.addAll([
        Text("You're only ", style: Styles.text(12, Colors.white, false)),
        Text(" ${pointsValue.round()} ",
            style: Styles.text(16, AppColors.orangeAccent, true)),
        Text(" points away", style: Styles.text(12, Colors.white, false)),
      ]);
    }

    return Column(
      children: [
        //Body Text
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: rowChildren,
        ),
        const SizedBox(height: 16),
        Text(
          "Redeem your points for a cup of happiness! Our signature espresso is blanced with steamed milk and topped with a light layer of foam. ",
          textAlign: TextAlign.center,
          style: Styles.text(14, Colors.white, false, height: 1.5),
        ),
        const SizedBox(height: 16),
        //Main Button
        ButtonTheme(
          minWidth: 200,
          height: 40,
          child: Opacity(
            opacity: isDisabled ? .6 : 1,
            child: TextButton(
              //Enable the button if we have enough points. Can do this by assigning a onPressed listener, or not.
              onPressed: isDisabled ? () {} : null,
              child: Text("REDEEM", style: Styles.text(16, Colors.white, true)),
            ),
          ),
        )
      ],
    );
  }

  void _handleTap() {
    widget.onTap?.call(widget.drinkData);
  }

  void _rebuildIfOpen() {
    if (widget.isOpen) {
      setState(() {});
    }
  }
}
