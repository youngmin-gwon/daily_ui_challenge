import 'package:daily_ui/2022/1/21_form_animation/styles.dart';
import 'package:flutter/material.dart';

class CheckboxInput extends StatefulWidget {
  const CheckboxInput({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;

  @override
  _CheckboxInputState createState() => _CheckboxInputState();
}

class _CheckboxInputState extends State<CheckboxInput> {
  bool _value = true;

  void _handleChange(bool? value) {
    setState(() {
      _value = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Styles.lightGrayColor),
      ),
      child: Row(
        children: [
          Checkbox(
            activeColor: Styles.secondaryColor,
            value: _value,
            onChanged: _handleChange,
          ),
          Text(
            widget.label,
            style: Styles.inputLabel,
          ),
        ],
      ),
    );
  }
}
