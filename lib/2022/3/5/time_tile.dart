import 'package:flutter/material.dart';

class TimeTile extends StatelessWidget {
  const TimeTile({
    Key? key,
    required this.text,
    this.useFillNumber = false,
  }) : super(key: key);

  final String text;
  final bool useFillNumber;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Center(
        child: Text(
          useFillNumber ? text.toString().padLeft(2, '0') : text,
          style: const TextStyle(
            fontSize: 35,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
