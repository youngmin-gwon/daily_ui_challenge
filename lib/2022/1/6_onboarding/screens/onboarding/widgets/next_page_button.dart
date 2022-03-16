import 'package:daily_ui/2022/1/6_onboarding/constants.dart';
import 'package:flutter/material.dart';

class NextPageButton extends StatelessWidget {
  const NextPageButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      padding: const EdgeInsets.all(kPaddingM),
      elevation: 0,
      shape: const CircleBorder(),
      fillColor: kWhite,
      child: const Icon(
        Icons.arrow_forward,
        color: kBlue,
        size: 32.0,
      ),
    );
  }
}
