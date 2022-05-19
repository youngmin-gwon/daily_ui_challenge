import 'package:flutter/material.dart';

class DisableButtonScreen extends StatefulWidget {
  const DisableButtonScreen({Key? key}) : super(key: key);

  @override
  State<DisableButtonScreen> createState() => _DisableButtonScreenState();
}

class _DisableButtonScreenState extends State<DisableButtonScreen> {
  bool _isButtonActivated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: DeactivatableButton(
          isDeactivated: _isButtonActivated,
          child: MaterialButton(
            onPressed: () {},
            textColor: Colors.white,
            color: Colors.red,
            disabledColor: Colors.blue,
            disabledTextColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

class DeactivatableButton extends StatelessWidget {
  const DeactivatableButton({
    Key? key,
    required this.child,
    required this.isDeactivated,
  }) : super(key: key);

  final MaterialButton child;
  final bool isDeactivated;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: isDeactivated ? null : child.onPressed,
      onLongPress: isDeactivated ? null : child.onLongPress,
      onHighlightChanged: child.onHighlightChanged,
      textTheme: child.textTheme,
      textColor: child.textColor,
      disabledColor: child.disabledColor,
      focusColor: child.focusColor,
      hoverColor: child.hoverColor,
      highlightColor: child.highlightColor,
      splashColor: child.splashColor,
      colorBrightness: child.colorBrightness,
      elevation: child.elevation,
      focusElevation: child.focusElevation,
      hoverElevation: child.hoverElevation,
      highlightElevation: child.highlightElevation,
      disabledElevation: child.disabledElevation,
      padding: child.padding,
      visualDensity: child.visualDensity,
      shape: child.shape,
      clipBehavior: child.clipBehavior,
      focusNode: child.focusNode,
      autofocus: child.autofocus,
      materialTapTargetSize: child.materialTapTargetSize,
      animationDuration: child.animationDuration,
      minWidth: child.minWidth,
      height: child.height,
      enableFeedback: child.enableFeedback,
      child: child.child,
    );
  }
}
