import 'dart:ui';

import 'package:daily_ui/2022/1/28/pages/home_page.dart';
import 'package:daily_ui/2022/1/28/styles/backgrounds.dart';
import 'package:daily_ui/2022/1/28/utils/fade_route.dart';
import 'package:daily_ui/2022/1/28/widgets/expanding_page_animation.dart';
import 'package:daily_ui/2022/1/28/widgets/forms/login_form.dart';
import 'package:daily_ui/2022/1/28/widgets/forms/singup_form.dart';
import 'package:daily_ui/2022/1/28/widgets/header.dart';
import 'package:flutter/material.dart';

enum AuthState {
  login,
  signup,
  home,
}

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pannelWidthAnimation;
  late Animation<double> _pannelHeightAnimation;
  late Animation<double> _headerHeightAnimation;
  late Animation<BorderRadiusGeometry> _borderRadiusAnimation;

  // variables to control the transition effect to the home page
  double _expandingWidth = 0;
  double _expandingHeight = 0;
  double _expandingBorderRadius = 500;

  // constant values for the login/registration panel
  static const double _pannelWidth = 350;
  static const double _pannelHeight = 500;
  static const double _headerHeight = 60;
  static const double _borderRadius = 30;

  bool _isLogin = true;
  AuthState _authState = AuthState.login;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..addStatusListener(_animationStatusListener);

    _initializeAnimations();
    _controller.forward();
  }

  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      if (_authState == AuthState.home) {
        _setHomeState();
        return;
      }

      _controller.forward(from: 0);

      if (_authState == AuthState.login) {
        _setLoginState(true);
        return;
      }
      if (_authState == AuthState.signup) {
        _setLoginState(false);
      }
    }
  }

  void _setHomeState() {
    setState(() {
      _expandingHeight = MediaQuery.of(context).size.height;
      _expandingWidth = MediaQuery.of(context).size.width;
      _expandingBorderRadius = 0;
      _routeTransition();
    });
  }

  void _onPressed(AuthState state) {
    _controller.reverse();
    _authState = state;
  }

  Future<void> _routeTransition() {
    return Future.delayed(
      const Duration(milliseconds: 500),
      () {
        Navigator.pushReplacement<dynamic, dynamic>(
            context, FadeRoute(child: const HomePage()));
      },
    );
  }

  void _setLoginState(bool isLogin) {
    setState(() {
      _isLogin = isLogin;
    });
  }

  void _initializeAnimations() {
    _scaleAnimation = Tween<double>(begin: 0, end: 1)
        .chain(
            CurveTween(curve: const Interval(0.5, 1.0, curve: Curves.easeIn)))
        .animate(_controller);

    _pannelWidthAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 0, end: _headerHeight)
              .chain(CurveTween(curve: Curves.ease)),
          weight: 25),
      TweenSequenceItem(
          tween: Tween<double>(begin: _headerHeight, end: _pannelWidth)
              .chain(CurveTween(curve: Curves.ease)),
          weight: 25),
      TweenSequenceItem(
          tween: Tween<double>(begin: _pannelWidth, end: _pannelWidth),
          weight: 50),
    ]).animate(_controller);

    _pannelHeightAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 0, end: _headerHeight)
              .chain(CurveTween(curve: Curves.ease)),
          weight: 25),
      TweenSequenceItem(
          tween: Tween<double>(begin: _headerHeight, end: _headerHeight),
          weight: 35),
      TweenSequenceItem(
          tween: Tween<double>(begin: _headerHeight, end: _pannelHeight),
          weight: 40),
    ]).animate(_controller);

    _headerHeightAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 0, end: _headerHeight)
              .chain(CurveTween(curve: Curves.ease)),
          weight: 25),
      TweenSequenceItem(
          tween: Tween<double>(begin: _headerHeight, end: _headerHeight),
          weight: 35),
      TweenSequenceItem(
          tween: Tween<double>(
              begin: _headerHeight,
              end: (_pannelHeight - _headerHeight) / 2 + _headerHeight),
          weight: 15),
      TweenSequenceItem(
          tween: Tween<double>(
                  begin: (_pannelHeight - _headerHeight) / 2 + _headerHeight,
                  end: _headerHeight)
              .chain(CurveTween(curve: Curves.ease)),
          weight: 25),
    ]).animate(_controller);

    _borderRadiusAnimation = Tween<BorderRadiusGeometry>(
            begin: BorderRadius.circular(0),
            end: BorderRadius.circular(_borderRadius))
        .chain(CurveTween(curve: const Interval(0, 0.5, curve: Curves.ease)))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backgroundAuthDecoration(),
        child: Stack(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: const FlutterLogo(
                textColor: Colors.blueGrey,
                style: FlutterLogoStyle.markOnly,
              ),
            ),
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(_borderRadius),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        height: _pannelHeightAnimation.value,
                        width: _pannelWidthAnimation.value,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300.withOpacity(0.1),
                            borderRadius: _borderRadiusAnimation.value),
                        child: Stack(
                          children: [
                            Center(
                              child: child,
                            ),
                            Header(
                                scale: _scaleAnimation.value,
                                height: _headerHeightAnimation.value,
                                isLogin: _isLogin),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: _isLogin
                    ? LoginForm(
                        onLoginPressed: () => _onPressed(AuthState.home),
                        onSignUpPressed: () => _onPressed(AuthState.signup),
                        safeArea: _headerHeight)
                    : SignUpForm(
                        onLoginPressed: () => _onPressed(AuthState.login),
                        onSignUpPressed: () => _onPressed(AuthState.home),
                        safeArea: _headerHeight),
              ),
            ),
            ExpandingPageAnimation(
              width: _expandingWidth,
              height: _expandingHeight,
              borderRadius: _expandingBorderRadius,
            ),
          ],
        ),
      ),
    );
  }
}
