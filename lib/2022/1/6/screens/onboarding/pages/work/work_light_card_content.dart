import 'package:daily_ui/2022/1/6/constants.dart';
import 'package:daily_ui/2022/1/6/screens/onboarding/widgets/icon_container.dart';
import 'package:flutter/material.dart';

class WorkLightCardContent extends StatelessWidget {
  const WorkLightCardContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        IconContainer(padding: kPaddingS, icon: Icons.event_seat),
        IconContainer(padding: kPaddingM, icon: Icons.business_center),
        IconContainer(padding: kPaddingS, icon: Icons.assessment),
      ],
    );
  }
}
