import 'package:flutter/material.dart';

class DisableButtonScreen extends StatefulWidget {
  const DisableButtonScreen({Key? key}) : super(key: key);

  @override
  State<DisableButtonScreen> createState() => _DisableButtonScreenState();
}

class _DisableButtonScreenState extends State<DisableButtonScreen> {
  bool _isButtonActivated = false;
  bool _showClearButton = false;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController()
      ..addListener(() {
        setState(() {
          _showClearButton = _textEditingController.text.isNotEmpty;
          _isButtonActivated = _textEditingController.text.isNotEmpty;
        });
      });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // const ClearableTextField(),
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: "show a beatiful word",
                suffixIcon: _buildClearButton(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isButtonActivated
                  ? () {
                      print("taptap");
                    }
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("not activated")));
                    },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  _isButtonActivated ? Colors.blue : Colors.grey,
                ),
                splashFactory:
                    _isButtonActivated ? InkSplash.splashFactory : null,
              ),
              child: const Text("Click"),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildClearButton() {
    return _showClearButton
        ? IconButton(
            onPressed: _textEditingController.clear,
            icon: const Icon(Icons.clear))
        : null;
  }
}

class ClearableTextField extends StatefulWidget {
  const ClearableTextField({Key? key}) : super(key: key);

  @override
  State<ClearableTextField> createState() => _ClearableTextFieldState();
}

class _ClearableTextFieldState extends State<ClearableTextField> {
  late TextEditingController _textEditingController;

  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController()
      ..addListener(() {
        setState(() {
          _showClearButton = _textEditingController.text.isNotEmpty;
        });
      });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textEditingController,
      decoration: InputDecoration(
        hintText: "Write beatiful words",
        suffixIcon: _buildClearIcon(),
      ),
    );
  }

  Widget? _buildClearIcon() {
    return _showClearButton
        ? IconButton(
            onPressed: _textEditingController.clear,
            icon: const Icon(Icons.clear),
          )
        : null;
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
