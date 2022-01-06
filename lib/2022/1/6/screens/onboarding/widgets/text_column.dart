import 'package:daily_ui/2022/1/6/constants.dart';
import 'package:flutter/material.dart';

class TextColumn extends StatelessWidget {
  const TextColumn({
    Key? key,
    required this.title,
    required this.text,
  }) : super(key: key);

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline5?.copyWith(
                color: kWhite,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: kSpaceM),
        Text(
          text,
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                color: kWhite,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
