import 'package:flutter/material.dart';

import 'package:daily_ui/2022/1/6_onboarding/constants.dart';
import 'package:daily_ui/2022/1/6_onboarding/widgets/logo.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.onSkip,
  }) : super(key: key);

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Logo(size: 32, color: kWhite),
        GestureDetector(
          onTap: onSkip,
          child: Text(
            "Skip",
            style:
                Theme.of(context).textTheme.subtitle1?.copyWith(color: kWhite),
          ),
        ),
      ],
    );
  }
}
