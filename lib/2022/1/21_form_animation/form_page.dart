import 'package:daily_ui/2022/1/21_form_animation/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormPage extends StatelessWidget {
  const FormPage({
    Key? key,
    required this.children,
    required this.pageSizeProportion,
    this.formKey,
    this.title = "",
    this.isHidden = false,
  }) : super(key: key);

  static Map<String, String> formState = {};

  final List<Widget> children;
  final double pageSizeProportion;
  final String title;
  final bool isHidden;

  final GlobalKey<FormState>? formKey;

  void _handleTap(BuildContext context) {
    // to improve user experience, we'll unfocus any textfields when the users taps on the background of the form
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      SystemChannels.textInput.invokeMethod("TextInput.hide");
    }
    WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
  }

  void _handleBackGesture(BuildContext context) {
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        if (!isHidden)
          Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onTap: () => _handleBackGesture(context),
              child: Container(
                width: double.infinity,
                height: screenSize.height * (1 - pageSizeProportion),
                color: Colors.transparent,
              ),
            ),
          ),
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () => _handleTap(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: Styles.hzPadding),
              width: screenSize.width,
              height: screenSize.height * pageSizeProportion,
              decoration: Styles.formContainerDecoration,
              child: Scaffold(
                backgroundColor: Colors.white,
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(title, style: Styles.formTitle),
                    Expanded(
                      child: Form(
                        key: formKey,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: children,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
