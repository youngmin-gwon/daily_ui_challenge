import 'package:daily_ui/2022/1/6_onboarding/constants.dart';
import 'package:flutter/material.dart';

class CommunityDarkCardContent extends StatelessWidget {
  const CommunityDarkCardContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        Padding(
          padding: EdgeInsets.only(
            top: kPaddingL,
          ),
          child: Icon(
            Icons.brush,
            color: kWhite,
            size: 32,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            bottom: kPaddingL,
          ),
          child: Icon(
            Icons.camera_alt,
            color: kWhite,
            size: 32,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: kPaddingL,
          ),
          child: Icon(
            Icons.straighten,
            color: kWhite,
            size: 32,
          ),
        ),
      ],
    );
  }
}
