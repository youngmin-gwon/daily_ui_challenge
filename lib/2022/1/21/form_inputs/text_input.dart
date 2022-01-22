import 'package:daily_ui/2022/1/21/styles.dart';
import 'package:flutter/material.dart';

import 'package:daily_ui/2022/1/21/demo_data.dart';

import 'input_validator.dart';

class TextInput extends StatefulWidget {
  const TextInput({
    Key? key,
    this.label = "",
    this.helper = "",
    this.initialValue = "",
    this.type = InputType.text,
    required this.onValidate,
    this.onChange,
    this.isRequired = true,
    this.isActive = true,
    this.valueNotifier,
  }) : super(key: key);

  final String label;
  final String helper;
  final String initialValue;
  final bool isRequired;
  final InputType type;
  final Function onValidate;
  final Function? onChange;
  final bool isActive;
  final ValueNotifier? valueNotifier;

  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool _isAutoValidating = false;
  bool? _isValid;

  String _value = "";
  String _errorText = "";

  String get _keyValue => (widget.key as ValueKey).value as String;

  @override
  void initState() {
    super.initState();
    // Reset the valid state on notifier change
    widget.valueNotifier?.addListener(() => _isValid = false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  set isValid(bool isValid) {
    if (_isValid != isValid) {
      _isValid = isValid;
      widget.onValidate(_keyValue, _isValid, value: _value);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Validate based on initial value, only do this once.
    // We do it here instead of initState as it may trigger rebuilds up the tree.
    if (_isValid == null) {
      if (widget.initialValue.isNotEmpty) {
        _validateField(widget.initialValue);
      }
    }

    // build input
    return Container(
      padding: EdgeInsets.only(top: widget.label.isEmpty ? 18 : 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (widget.label.isNotEmpty)
            Positioned(
              top: -24,
              child: Text(
                widget.label,
                style: Styles.inputLabel,
              ),
            ),
          TextFormField(
            initialValue: widget.initialValue,
            style: Styles.orderTotalLabel,
            enabled: widget.isActive,
            onChanged: _handleChange,
            keyboardType: _setKeyboardType(),
            autovalidateMode: _isAutoValidating
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            validator: _validateField,
            decoration: Styles.getInputDecoration(helper: widget.helper),
          ),
          Positioned(
            top: 6,
            left: 12,
            child: Text(
              _getLabel().toUpperCase(),
              style: Styles.labelOptional,
            ),
          ),
          if (_errorText.isNotEmpty)
            Positioned(
              top: 8,
              right: 14,
              child: Text(
                _errorText.toUpperCase(),
                style: Styles.labelNotValid,
              ),
            ),
        ],
      ),
    );
  }

  String _getLabel() {
    String label = "";
    if (!widget.isRequired && _value.isEmpty) label = "Optional";
    if (_value.isNotEmpty && widget.label.isEmpty ||
        widget.initialValue.isNotEmpty) return widget.helper;
    return label;
  }

  void _handleChange(String value) {
    // save value status
    _value = value;
    widget.onChange?.call(_keyValue, value);

    // activate validation
    Future.delayed(const Duration(milliseconds: 300), () => setState(() {}));
    if (!_isAutoValidating) {
      setState(() {
        _isAutoValidating = true;
      });
    }
  }

  TextInputType? _setKeyboardType() {
    switch (widget.type) {
      case InputType.text:
        return TextInputType.text;
      case InputType.email:
        return TextInputType.emailAddress;
      case InputType.number:
        return const TextInputType.numberWithOptions(
            signed: true, decimal: true);
      case InputType.telephone:
        return const TextInputType.numberWithOptions(decimal: true);
      default:
        return null;
    }
  }

  String? _validateField(String? value) {
    _value = value ?? "";
    // if the value is required
    if (widget.isRequired && _value.isEmpty) {
      isValid = false;
      _errorText = "Required";
      // Update error label,
      // wait a frame because this was causing markAsBuild errors
      Future.delayed(const Duration(milliseconds: 17), () => setState(() {}));
      return _errorText;
    } else if (!widget.isRequired && _value.isEmpty) {
      isValid = true;
      _errorText = "";
      return null;
    } else if (_value.isNotEmpty &&
        InputValidator.validate(widget.type, _value)) {
      isValid = true;
      _errorText = "";
      return null;
    } else {
      isValid = false;
      _errorText = "Not Valid";
      return _errorText;
    }
  }
}
