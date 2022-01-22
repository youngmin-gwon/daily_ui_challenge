import 'dart:html';

import 'package:daily_ui/2022/1/21/form_inputs/input_validator.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';

import 'package:daily_ui/2022/1/21/demo_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../styles.dart';

class CreditCardInput extends StatefulWidget {
  const CreditCardInput({
    Key? key,
    this.label = "",
    this.helper = "",
    required this.inputType,
    required this.onValidate,
    this.cardNetwork,
    this.onChange,
  }) : super(key: key);

  final String label;
  final String helper;
  final CreditCardInputType inputType;
  final CreditCardNetwork? cardNetwork;
  final Function onValidate;
  final Function(CreditCardNetwork?)? onChange;

  @override
  _CreditCardInputState createState() => _CreditCardInputState();
}

class _CreditCardInputState extends State<CreditCardInput> {
  late MaskedTextController _textController;
  late CreditCardNetwork? _creditCardType;

  bool _isAutoValidating = false;
  bool? _isValid;

  String _value = "";
  String _errorText = "";

  String get keyValue => (widget.key as ValueKey).value as String;

  @override
  void initState() {
    super.initState();
    _textController = MaskedTextController(mask: "00");
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  set isValid(bool isValid) {
    if (isValid != _isValid) {
      _isValid = isValid;
      widget.onValidate(keyValue, _isValid, value: _value);
    }
  }

  @override
  Widget build(BuildContext context) {
    // set isValid
    isValid = false;

    return Container(
      padding: EdgeInsets.only(top: widget.label.isNotEmpty ? 18 : 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (widget.label.isNotEmpty)
            Positioned(
                top: -24, child: Text(widget.label, style: Styles.inputLabel)),
          TextFormField(
            controller: _textController,
            style: Styles.orderTotalLabel,
            onChanged: _handleChange,
            keyboardType: TextInputType.number,
            autovalidateMode: _isAutoValidating
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            validator: _validateField,
            decoration: Styles.getInputDecoration(helper: widget.helper),
          ),
          Positioned(
            top: 6,
            left: 16,
            child: Text(_getLabel().toUpperCase(), style: Styles.labelOptional),
          ),
          if (_errorText.isNotEmpty)
            Positioned(
              top: 8,
              right: 14,
              child: Text(
                _errorText,
                style: Styles.labelNotValid,
              ),
            ),
          if (widget.inputType == CreditCardInputType.number)
            Positioned(
              top: 15,
              right: 18,
              child: Icon(_getCreditCardIcon(),
                  size: 28, color: Styles.darkGrayColor),
            ),
        ],
      ),
    );
  }

  IconData _getCreditCardIcon() {
    switch (_creditCardType) {
      case CreditCardNetwork.visa:
        return FontAwesomeIcons.ccVisa;
      case CreditCardNetwork.mastercard:
        return FontAwesomeIcons.ccMastercard;
      case CreditCardNetwork.amex:
        return FontAwesomeIcons.ccAmex;
      default:
        return Icons.credit_card;
    }
  }

  String _getLabel() {
    String label = "";
    if (_value.isEmpty && widget.label.isEmpty) return widget.helper;
    return label;
  }

  void _handleChange(String value) {
    _value = value;
    Future.delayed(const Duration(milliseconds: 100), () => setState(() {}));
    if (value.length == 2) _updateInputMask();
    if (!_isAutoValidating) {
      setState(() {
        _isAutoValidating = true;
      });
    }
  }

  String? _validateField(String? value) {
    _value = value ?? "";
    // if is required
    if (_value.isEmpty) {
      isValid = false;
      _errorText = "Required";
      return _errorText;
    }
    // validate when the input has a value
    else if (_value.isNotEmpty &&
        InputValidator.validate(widget.inputType, _value,
            cardNetwork: widget.cardNetwork)) {
      isValid = true;
      _errorText = "";
      return null;
    } else {
      isValid = false;
      _errorText = "Not Valid";
      return _errorText;
    }
  }

  void _updateInputMask() {
    switch (widget.inputType) {
      case CreditCardInputType.number:
        // Visa
        if (_value.substring(0, 1).compareTo("4") == 0) {
          _creditCardType = CreditCardNetwork.visa;
          _textController.updateMask("0000 0000 0000 0000");
        }
        // AMEX
        else if (_value.substring(0, 2) == "34" ||
            _value.substring(0, 2) == "37") {
          _creditCardType = CreditCardNetwork.amex;
          _textController.updateMask("0000 000000 00000");
        }
        // Mastercard
        else if (_value.substring(0, 2) == "51" ||
            _value.substring(0, 2) == '52' ||
            _value.substring(0, 2) == '53' ||
            _value.substring(0, 2) == '54' ||
            _value.substring(0, 2) == '55') {
          _creditCardType = CreditCardNetwork.mastercard;
          _textController.updateMask("0000 0000 0000 0000");
        } else {
          _creditCardType = null;
        }
        break;
      case CreditCardInputType.expirationData:
        _textController.updateMask("00/00");
        _textController.beforeChange = (String previous, String next) {
          return next.length <= 5;
        };
        break;
      case CreditCardInputType.securityCode:
        if (widget.cardNetwork == CreditCardNetwork.amex) {
          _textController.updateMask("0000");
        } else {
          _textController.updateMask("000");
        }
        break;
    }
    widget.onChange?.call(_creditCardType);
  }
}
