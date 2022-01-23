import 'package:daily_ui/2022/1/21/component/header.dart';
import 'package:flutter/material.dart';

class StackPagesRoute extends PageRouteBuilder {
  final Widget enterPage;
  final List<Widget> previousPages;

  StackPagesRoute({required this.previousPages, required this.enterPage})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              enterPage,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return Stack(
              clipBehavior: Clip.hardEdge,
              fit: StackFit.expand,
              children: [
                const Header(),
                for (int i = 0; i < previousPages.length; i++)
                  SlideTransition(
                    position: Tween<Offset>(
                      begin:
                          Offset(0, ((previousPages.length - i) * -.05) + .05),
                      end: Offset(0, ((previousPages.length - i) * -.05)),
                    ).animate(
                      CurvedAnimation(
                          parent: animation, curve: Curves.easeInCubic),
                    ),
                    child: previousPages[i],
                  ),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: enterPage,
                )
              ],
            );
          },
        );
}
