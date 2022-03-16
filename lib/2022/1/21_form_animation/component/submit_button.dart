import 'package:daily_ui/2022/1/21_form_animation/styles.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    Key? key,
    this.percentage = 1,
    this.isErrorVisible = false,
    this.padding = const EdgeInsets.all(0),
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  final double percentage;
  final Widget child;
  final VoidCallback onPressed;
  final bool isErrorVisible;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Styles.vtFormPadding).add(padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RawMaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            elevation: 0,
            onPressed: onPressed,
            fillColor: Styles.primaryColor,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizeTransition(
                    sizeFactor: Tween<double>(begin: 0, end: 1).animate(
                      AlwaysStoppedAnimation(percentage.isNaN ? 0 : percentage),
                    ),
                    axisAlignment: -1,
                    axis: Axis.horizontal,
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Styles.secondaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                child,
              ],
            ),
          ),
          if (isErrorVisible)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                "You haven't finished filling out your information",
                style: Styles.formError,
              ),
            ),
        ],
      ),
    );
  }
}
