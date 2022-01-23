import 'package:daily_ui/2022/1/21/styles.dart';
import 'package:flutter/material.dart';

class FormSectionTitle extends StatelessWidget {
  const FormSectionTitle({
    Key? key,
    required this.title,
    this.padding = const EdgeInsets.all(0),
  }) : super(key: key);

  final String title;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10).add(padding),
      child: Text(title.toUpperCase(), style: Styles.formSection),
    );
  }
}
