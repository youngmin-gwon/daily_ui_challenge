import 'package:flutter/material.dart';

import 'package:daily_ui/2022/1/6/constants.dart';
import 'package:daily_ui/2022/1/6/screens/login/widgets/index.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
    required this.screenHeight,
  }) : super(key: key);

  final double screenHeight;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _headerTextAnimation;
  late Animation<double> _formElementAnimation;
  late Animation<double> _whiteTopClipperAnimation;
  late Animation<double> _blueTopClipperAnimation;
  late Animation<double> _greyTopClipperAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: kLoginAnimationDuration,
    );

    final fadeSlideTween = Tween<double>(
      begin: 0.0,
      end: 1.0,
    );

    // Text Animation
    _headerTextAnimation = fadeSlideTween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.0,
          0.6,
          curve: Curves.easeInOut,
        ),
      ),
    );

    _formElementAnimation = fadeSlideTween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.8,
          1.0,
          curve: Curves.easeInOut,
        ),
      ),
    );

    final clipperOffset = Tween<double>(begin: widget.screenHeight, end: 0.0);

    _blueTopClipperAnimation = clipperOffset.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.2,
          0.7,
          curve: Curves.easeInOut,
        ),
      ),
    );
    _greyTopClipperAnimation = clipperOffset.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.35,
          0.7,
          curve: Curves.easeInOut,
        ),
      ),
    );
    _whiteTopClipperAnimation = clipperOffset.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.5,
          0.7,
          curve: Curves.easeInOut,
        ),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kWhite,
      body: Stack(
        children: [
          AnimatedBuilder(
              animation: _whiteTopClipperAnimation,
              child: Container(color: kGrey),
              builder: (_, Widget? child) {
                return ClipPath(
                  clipper: WhiteTopClipper(
                    yOffset: _whiteTopClipperAnimation.value,
                  ),
                  child: child,
                );
              }),
          AnimatedBuilder(
              animation: _greyTopClipperAnimation,
              child: Container(color: kBlue),
              builder: (_, Widget? child) {
                return ClipPath(
                  clipper: GreyTopClipper(
                    yOffset: _greyTopClipperAnimation.value,
                  ),
                  child: child,
                );
              }),
          AnimatedBuilder(
              animation: _blueTopClipperAnimation,
              child: Container(color: kWhite),
              builder: (_, Widget? child) {
                return ClipPath(
                  clipper: BlueTopClipper(
                    yOffset: _blueTopClipperAnimation.value,
                  ),
                  child: child,
                );
              }),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: kPaddingL),
              child: Column(
                children: [
                  Header(
                    animation: _headerTextAnimation,
                  ),
                  const Spacer(),
                  LoginForm(
                    animation: _formElementAnimation,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
