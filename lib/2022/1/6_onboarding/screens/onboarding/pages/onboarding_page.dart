import 'package:daily_ui/2022/1/6_onboarding/constants.dart';
import 'package:flutter/material.dart';

import 'package:daily_ui/2022/1/6_onboarding/screens/onboarding/widgets/cards_stack.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    Key? key,
    required this.number,
    required this.lightCardChild,
    required this.darkCardChild,
    required this.textColumn,
    required this.lightCardOffsetAnimation,
    required this.darkCardOffsetAnimation,
  }) : super(key: key);

  final int number;
  final Widget lightCardChild;
  final Widget darkCardChild;
  final Widget textColumn;

  final Animation<Offset> lightCardOffsetAnimation;
  final Animation<Offset> darkCardOffsetAnimation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardsStack(
          pageNumber: number,
          lightCardChild: lightCardChild,
          darkCardChild: darkCardChild,
          lightCardOffsetAnimation: lightCardOffsetAnimation,
          darkCardOffsetAnimation: darkCardOffsetAnimation,
        ),
        SizedBox(
          height: number % 2 == 1 ? 75 : 50,
        ),
        AnimatedSwitcher(
          duration: kCardAnimationDuration,
          child: textColumn,
        ),
      ],
    );
  }
}
