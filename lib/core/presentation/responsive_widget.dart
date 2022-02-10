import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget({
    Key? key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  }) : super(key: key);

  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  // Responsive breakpoints
  static const double screenTablet = 580;
  static const double screenDesktop = 900;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < screenTablet;
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= screenTablet &&
      MediaQuery.of(context).size.width < screenDesktop;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= screenDesktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isMobile(context)) {
          return mobile;
        } else if (isTablet(context)) {
          return tablet;
        } else {
          return desktop;
        }
      },
    );
  }
}
