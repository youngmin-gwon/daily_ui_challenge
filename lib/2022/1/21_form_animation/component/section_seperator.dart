import 'package:daily_ui/2022/1/21_form_animation/styles.dart';
import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  const Separator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      color: Styles.lightGrayColor,
      height: 1,
    );
  }
}
