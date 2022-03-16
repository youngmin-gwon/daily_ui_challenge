import 'package:daily_ui/2022/1/6_onboarding/constants.dart';
import 'package:daily_ui/2022/1/6_onboarding/screens/onboarding/widgets/icon_container.dart';
import 'package:flutter/material.dart';

class CommunityLightCardContent extends StatelessWidget {
  const CommunityLightCardContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        IconContainer(padding: kPaddingS, icon: Icons.person),
        IconContainer(padding: kPaddingM, icon: Icons.group),
        IconContainer(padding: kPaddingS, icon: Icons.insert_emoticon),
      ],
    );
  }
}
