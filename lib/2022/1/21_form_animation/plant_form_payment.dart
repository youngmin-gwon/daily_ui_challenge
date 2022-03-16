import 'package:daily_ui/2022/1/21_form_animation/component/submit_button.dart';
import 'package:daily_ui/2022/1/21_form_animation/demo_data.dart';
import 'package:daily_ui/2022/1/21_form_animation/form_mixin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'component/section_seperator.dart';
import 'component/section_title.dart';
import 'form_demo_screen.dart';
import 'form_inputs/checkbox_input.dart';
import 'form_inputs/credit_card_input.dart';
import 'form_inputs/text_input.dart';
import 'form_page.dart';
import 'styles.dart';

class PlantFormPayment extends StatefulWidget {
  const PlantFormPayment({
    Key? key,
    this.pageSize = .85,
  }) : super(key: key);

  final double pageSize;

  @override
  _PlantFormPaymentState createState() => _PlantFormPaymentState();
}

class _PlantFormPaymentState extends State<PlantFormPayment> with FormMixin {
  final _formKey = GlobalKey<FormState>();
  late CreditCardNetwork _cardNetwork;

  late SharedFormState sharedState;
  Map<String, String> get values => sharedState.valuesByName;

  @override
  void initState() {
    super.initState();
    sharedState = Provider.of<SharedFormState>(context, listen: false);
    _cardNetwork = CreditCardNetwork.amex;
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuilding payments @ ${DateTime.now().millisecondsSinceEpoch}");
    return FormPage(
      formKey: _formKey,
      pageSizeProportion: widget.pageSize,
      title: 'Payment',
      children: [
        Text('\$34.00', style: Styles.orderTotal),
        const Separator(),
        _buildShippingSection(),
        const Separator(),
        const FormSectionTitle(title: 'Gift card or discount code'),
        _buildInputWithButton(),
        const FormSectionTitle(
            title: 'Payment', padding: EdgeInsets.only(bottom: 16)),
        CreditCardInput(
          key: ValueKey(FormKeys.ccNumber),
          label: 'Card Number',
          helper: '4111 2222 3333 4440',
          cardNetwork: _cardNetwork,
          onValidate: onItemValidate,
          onChange: _handleItemChange,
          inputType: CreditCardInputType.number,
        ),
        TextInput(
            key: ValueKey(FormKeys.ccName),
            label: 'Card Name',
            helper: 'Cardholder Name',
            onValidate: onItemValidate),
        Row(
          children: <Widget>[
            Expanded(
                child: CreditCardInput(
              key: ValueKey(FormKeys.ccExpDate),
              label: 'Expiration',
              helper: 'MM/YY',
              onValidate: onItemValidate,
              inputType: CreditCardInputType.expirationData,
            )),
            const SizedBox(width: 24),
            Expanded(
              child: CreditCardInput(
                  key: ValueKey(FormKeys.ccCode),
                  cardNetwork: _cardNetwork,
                  label: 'Security Code',
                  helper: '000',
                  onValidate: onItemValidate,
                  inputType: CreditCardInputType.securityCode),
            ),
          ],
        ),
        const FormSectionTitle(title: 'Shipping Notifications'),
        const CheckboxInput(label: 'Send shipping updates'),
        _buildSubmitButton()
      ],
    );
  }

  Widget _buildInputWithButton() {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: TextInput(
            helper: "000 000 000 XX",
            type: InputType.number,
            onValidate: onItemValidate,
            isRequired: false,
            isActive: false,
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 26, left: 12),
            child: MaterialButton(
              onPressed: null,
              disabledColor: Styles.lightGrayColor,
              elevation: 0,
              color: Styles.secondaryColor,
              height: 56,
              child: Text("Apply", style: Styles.submitButtonText),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShippingSection() {
    return Column(children: <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              constraints: const BoxConstraints(minWidth: 85),
              child: Text('Contact', style: Styles.orderLabel)),
          Text(values[FormKeys.email] ?? "",
              overflow: TextOverflow.clip, style: Styles.orderPrice),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                constraints: const BoxConstraints(minWidth: 85),
                child: Text('Ship to', style: Styles.orderLabel)),
            Text(_getShippingAddress(),
                overflow: TextOverflow.clip, style: Styles.orderPrice),
          ],
        ),
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              constraints: const BoxConstraints(minWidth: 85),
              child: Text('Method', style: Styles.orderLabel)),
          Text('FREE', overflow: TextOverflow.clip, style: Styles.orderPrice),
        ],
      )
    ]);
  }

  String _getShippingAddress() {
    String aptNumber = values[FormKeys.apt]?.isNotEmpty ?? false
        ? '#${values[FormKeys.apt]} '
        : '';
    String? address = values[FormKeys.address];
    String? country = values[FormKeys.country];
    String? city = values[FormKeys.city];
    String? countrySubdivision =
        values[CountryData.getSubdivisionTitle(country ?? "")] ?? '';
    String? postalCode = values[FormKeys.postal];
    return '$aptNumber$address\n$city, $countrySubdivision ${postalCode?.toUpperCase()}\n${country?.toUpperCase()}';
  }

  Widget _buildSubmitButton() {
    return SubmitButton(
      onPressed: _handleSubmit,
      percentage: formCompletion,
      isErrorVisible: isFormErrorVisible,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Purchase', style: Styles.submitButtonText),
            Text('\$34', style: Styles.submitButtonText),
          ],
        ),
      ),
    );
  }

  @override
  void onItemChange({required String name, required String value}) {
    values[name] = value;
  }

  @override
  void onItemValidate(
      {required String name, required bool isValid, required String value}) {
    validInputsMap[name] = isValid;
    values[name] = value;

    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        if (mounted) {
          setState(() {
            formCompletion = super.countValidItems() / validInputsMap.length;
            if (formCompletion == 1) {
              isFormErrorVisible = false;
            }
          });
        }
      },
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate() && formCompletion == 1) {
    } else {
      setState(() {
        isFormErrorVisible = true;
      });
    }
  }

  void _handleItemChange(CreditCardNetwork cardNetwork) {
    setState(() {
      _cardNetwork = cardNetwork;
    });
  }
}
