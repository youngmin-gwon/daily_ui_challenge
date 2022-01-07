import 'package:daily_ui/2022/1/6/screens/login/widgets/index.dart';
import 'package:flutter/material.dart';

import 'package:daily_ui/2022/1/6/constants.dart';
import 'package:daily_ui/2022/1/6/widgets/logo.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.animation,
  }) : super(key: key);

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Logo(size: 48, color: kBlue),
          const SizedBox(height: kSpaceM),
          Text(
            "Welcome to Bubble",
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(color: kBlack, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: kSpaceS),
          FadeSlideTransition(
            animation: animation,
            additionalOffset: 16.0,
            child: Text(
              'Est ad dolor aute ex commodo tempor exercitation proident.',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.copyWith(color: kBlack.withOpacity(.5)),
            ),
          )
        ],
      ),
    );
  }
}
