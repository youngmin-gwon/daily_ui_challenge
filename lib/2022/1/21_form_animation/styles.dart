import 'package:flutter/material.dart';

class Styles {
  static double formRadius = 20;
  static double hzPadding = 37;
  static double vtFormPadding = 18;

  static Color primaryColor = const Color(0xff00b27f);
  static Color secondaryColor = const Color(0xff007b80);
  static Color baseColor = const Color(0xff4a4a4a);

  static Color lightGrayColor = const Color(0xffe6e6e6);
  static Color grayColor = const Color(0xff505050);
  static Color darkGrayColor = const Color(0xff2d2d2d);

  static Color helperColor = const Color(0xff787878);
  static Color optionalColor = const Color(0xffA7A7A7);
  static Color errorColor = const Color(0xffea6060);

  static final BoxDecoration formContainerDecoration = BoxDecoration(
    color: Colors.white,
    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
    border: Border.all(color: const Color(0xffd4d4d4)),
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(Styles.formRadius),
    ),
  );

  static TextStyle appTitle = TextStyle(
    color: Styles.primaryColor,
    fontWeight: FontWeight.w800,
    fontSize: 8,
    letterSpacing: 1.95,
  );

  static TextStyle formTitle = TextStyle(
      color: Styles.primaryColor, height: 1, fontSize: 30, letterSpacing: 0.22);

  static TextStyle formSection = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      color: secondaryColor);

  static TextStyle imageBatch = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
      letterSpacing: 0.5);

  static TextStyle productName = TextStyle(
      fontWeight: FontWeight.w600,
      color: Styles.secondaryColor,
      letterSpacing: 0.63,
      fontSize: 20);
  static TextStyle productPrice = const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 20,
      height: 1.8,
      letterSpacing: 0.63);
  static TextStyle orderLabel = TextStyle(
      fontSize: 14,
      color: Styles.baseColor,
      letterSpacing: 0.44,
      fontWeight: FontWeight.w500);
  static TextStyle orderPrice = TextStyle(
      fontSize: 14,
      color: Styles.baseColor,
      letterSpacing: 0.44,
      fontWeight: FontWeight.w600);
  static TextStyle orderTotalLabel = TextStyle(
      fontSize: 16,
      color: Styles.baseColor,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w500);
  static TextStyle orderTotal = TextStyle(
      fontSize: 20,
      color: Styles.baseColor,
      letterSpacing: 0.63,
      fontWeight: FontWeight.bold);

  static TextStyle helperStyle = TextStyle(
      fontSize: 16,
      color: helperColor,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w500);
  static TextStyle inputStyle = TextStyle(
      fontSize: 16,
      color: Styles.baseColor,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w500);

  static TextStyle submitButtonText = const TextStyle(
      fontSize: 16,
      color: Colors.white,
      letterSpacing: 0.44,
      fontWeight: FontWeight.bold);

  static TextStyle labelOptional = TextStyle(
      fontSize: 8,
      color: optionalColor,
      fontWeight: FontWeight.bold,
      letterSpacing: 1);
  static TextStyle labelNotValid = TextStyle(
      fontSize: 8,
      color: errorColor,
      fontWeight: FontWeight.bold,
      letterSpacing: 1);
  static TextStyle labelRequired = TextStyle(
      fontSize: 6,
      color: grayColor,
      fontWeight: FontWeight.bold,
      letterSpacing: .5);

  static TextStyle textButton = TextStyle(
      fontSize: 16,
      color: Styles.secondaryColor,
      letterSpacing: 0.5,
      fontWeight: FontWeight.bold);
  static TextStyle optionsTitle = TextStyle(
      fontSize: 20,
      color: Styles.darkGrayColor,
      letterSpacing: 0.63,
      fontWeight: FontWeight.w600);

  static TextStyle iconDropdown = TextStyle(
    color: Styles.secondaryColor,
    fontSize: 27,
  );

  static TextStyle formError = TextStyle(
      fontSize: 12,
      color: errorColor,
      fontStyle: FontStyle.italic,
      letterSpacing: 0.38,
      fontWeight: FontWeight.w500);

  static TextStyle inputLabel = TextStyle(
      fontSize: 16,
      color: Styles.baseColor,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w600);

  static InputDecoration getInputDecoration({required String helper}) {
    return InputDecoration(
      helperStyle: Styles.helperStyle,
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Styles.secondaryColor)),
      errorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Styles.errorColor)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Styles.lightGrayColor)),
      border: const OutlineInputBorder(),
      errorStyle: const TextStyle(color: Colors.transparent),
      helperText: '',
      hintText: helper,
      hintStyle: Styles.helperStyle,
    );
  }
}
