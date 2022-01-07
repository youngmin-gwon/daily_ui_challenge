import 'package:daily_ui/2022/1/6/constants.dart';
import 'package:flutter/material.dart';

class IconContainer extends StatelessWidget {
  const IconContainer({
    Key? key,
    required this.padding,
    required this.icon,
  }) : super(key: key);

  final double padding;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: kWhite.withOpacity(.25),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 32,
        color: kWhite,
      ),
    );
  }
}
