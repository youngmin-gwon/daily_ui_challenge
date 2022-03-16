import 'package:daily_ui/2022/1/6_onboarding/constants.dart';
import 'package:flutter/material.dart';

class WorkDarkCardContent extends StatelessWidget {
  const WorkDarkCardContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Icon(
              Icons.person_pin,
              color: kWhite,
              size: 32,
            )
          ],
        ),
        const SizedBox(height: kSpaceM),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Icon(
              Icons.person,
              color: kWhite,
              size: 32,
            ),
            Icon(
              Icons.group,
              color: kWhite,
              size: 32,
            ),
            Icon(
              Icons.insert_emoticon,
              color: kWhite,
              size: 32,
            ),
          ],
        ),
      ],
    );
  }
}
