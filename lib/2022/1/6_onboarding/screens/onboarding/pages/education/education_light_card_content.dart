import 'package:daily_ui/2022/1/6_onboarding/constants.dart';
import 'package:daily_ui/2022/1/6_onboarding/screens/onboarding/widgets/icon_container.dart';
import 'package:flutter/material.dart';

class EducationLightCardContent extends StatelessWidget {
  const EducationLightCardContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        IconContainer(padding: kPaddingS, icon: Icons.brush),
        IconContainer(padding: kPaddingM, icon: Icons.camera_alt),
        IconContainer(padding: kPaddingS, icon: Icons.straighten),
      ],
    );
  }
}
