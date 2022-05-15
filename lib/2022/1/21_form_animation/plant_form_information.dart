import 'package:daily_ui/2022/1/21_form_animation/component/section_title.dart';
import 'package:daily_ui/2022/1/21_form_animation/component/stack_pages_route.dart';
import 'package:daily_ui/2022/1/21_form_animation/component/submit_button.dart';
import 'package:daily_ui/2022/1/21_form_animation/demo_data.dart';
import 'package:daily_ui/2022/1/21_form_animation/form_inputs/dropdown_menu.dart';
import 'package:daily_ui/2022/1/21_form_animation/form_mixin.dart';
import 'package:daily_ui/2022/1/21_form_animation/form_page.dart';
import 'package:daily_ui/2022/1/21_form_animation/plant_form_payment.dart';
import 'package:daily_ui/2022/1/21_form_animation/plant_form_summary.dart';
import 'package:daily_ui/2022/1/21_form_animation/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'form_demo_screen.dart';
import 'form_inputs/text_input.dart';

class PlantFormInformation extends StatefulWidget {
  const PlantFormInformation({
    Key? key,
    this.pageSize = 0.85,
    this.isHidden = false,
  }) : super(key: key);

  final double pageSize;
  final bool isHidden;

  @override
  _PlantFormInformationState createState() => _PlantFormInformationState();
}

class _PlantFormInformationState extends State<PlantFormInformation>
    with FormMixin {
  final _formKey = GlobalKey<FormState>();

  late SharedFormState formState;
  Map<String, String> get values => formState.valuesByName;
  String get _selectedCountry => _getFormValue(FormKeys.country);

  late ValueNotifier<String> _country;
  String? _countrySubdivisionKey;
  late List<String> _countries;

  @override
  void initState() {
    super.initState();
    _countries = CountryData.getCountries();
    formState = Provider.of<SharedFormState>(context, listen: false);
    if (!values.containsKey(FormKeys.country)) {
      // if not value, set default country
      _country = ValueNotifier(_countries[2]);
      values[FormKeys.country] = _country.value;
    } else {
      _country = ValueNotifier(values[FormKeys.country]!);
    }
    _updateCountrySubdivision(_selectedCountry);
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuilding information @ ${DateTime.now().millisecondsSinceEpoch}");
    return FormPage(
      formKey: _formKey,
      pageSizeProportion: widget.pageSize,
      title: "Information",
      children: <Widget>[
        // All countries share the a title and country selector at the top of the form
        const FormSectionTitle(title: "Contact Information"),
        // Email Input
        _buildText(FormKeys.email, type: InputType.email, isRequired: true),
        const FormSectionTitle(title: "Shipping Address"),
        // Country Selector
        DropdownMenu(
          key: ValueKey(FormKeys.country),
          label: "Country / Region",
          options: _countries,
          defaultOption: _selectedCountry,
          onValidate: onItemValidate,
        ),
        // Inject the country-specific fields into the list
        ..._buildCountrySpecificFormElements(),
        // Phone number is always last
        _buildText(FormKeys.phone,
            title: "Phone Number", type: InputType.telephone),

        SubmitButton(
          isErrorVisible: isFormErrorVisible,
          child: Text("Continue to payment", style: Styles.submitButtonText),
          percentage: formCompletion,
          onPressed: () => _handleSubmit(context),
        ),
      ],
    );
  }

  DropdownMenu _buildSubdivisionDropdown() {
    return DropdownMenu(
      key: ValueKey(_countrySubdivisionKey),
      label: _countrySubdivisionKey!,
      defaultOption: _getFormValue(_countrySubdivisionKey!),
      options: CountryData.getSubdivisionList(_countrySubdivisionKey!),
      onValidate: onItemValidate,
    );
  }

  List<Widget> _buildCountrySpecificFormElements() {
    var postalTitle =
        _selectedCountry == "United States" ? "Zip Code" : "Postal Code";
    List<Widget> elements = [];
    switch (_selectedCountry) {
      case "United States":
      case "Canada":
        elements = [
          _buildText(FormKeys.firstName),
          _buildText(FormKeys.lastName, isRequired: true),
          _buildText(FormKeys.address, isRequired: true),
          _buildText(FormKeys.apt, title: "Apartment, suite, etc."),
          _buildText(FormKeys.city, isRequired: true),
          _buildSubdivisionDropdown(),
          _buildText(FormKeys.postal, title: postalTitle, isRequired: true),
        ];
        break;
      case "Japan":
        elements = [
          _buildText(FormKeys.company),
          _buildText(FormKeys.lastName, isRequired: true),
          _buildText(FormKeys.firstName),
          _buildText(FormKeys.postal, title: postalTitle, isRequired: true),
          _buildSubdivisionDropdown(),
          _buildText(FormKeys.city, isRequired: true),
          _buildText(FormKeys.address, isRequired: true),
          _buildText(FormKeys.apt, title: "Apartment, suite, etc."),
        ];
        break;
      case "France":
        elements = [
          _buildText(FormKeys.firstName),
          _buildText(FormKeys.lastName, isRequired: true),
          _buildText(FormKeys.company),
          _buildText(FormKeys.address, isRequired: true),
          _buildText(FormKeys.apt, title: "Apartment, suite, etc."),
          _buildText(FormKeys.postal, title: postalTitle, isRequired: true),
          _buildText(FormKeys.city, isRequired: true),
        ];
        break;
    }
    return elements;
  }

  TextInput _buildText(String key,
      {String? title,
      bool isRequired = false,
      InputType type = InputType.text}) {
    title = title ?? _snakeToTitleCase(key);
    // Register the input validity
    if (!validInputsMap.containsKey(key)) {
      validInputsMap[key] = !isRequired;
    }
    return TextInput(
      key: ValueKey(key),
      helper: title,
      type: type,
      initialValue: _getFormValue(key),
      onValidate: onItemValidate,
      onChange: onItemChange,
      isRequired: isRequired,
      valueNotifier: _country,
    );
  }

  @override
  void onItemValidate({
    required String name,
    required bool isValid,
    required String value,
  }) {
    // update the input validity
    validInputsMap[name] = isValid;
    bool hasChanged = values[name] != value;
    values[name] = value;
    // on country updated
    if (name == FormKeys.country && hasChanged) {
      _country.value = value;
      validInputsMap.clear();
      _updateCountrySubdivision(value);
      onItemChange(name: name, value: value);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        formCompletion = countValidItems() / validInputsMap.length;
      });
    });
  }

  @override
  void onItemChange({required String name, required String value}) {
    values[name] = value;
  }

  String _snakeToTitleCase(String value) {
    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
    List<String> words = value.split("_");
    words = words.map((w) => capitalize(w)).toList();
    return words.join(" ");
  }

  String _getFormValue(String name) {
    return values.containsKey(name) ? values[name] ?? "" : "";
  }

  void _updateCountrySubdivision(String country) {
    // Invalidate input maps
    validInputsMap.clear();
    // Get the key for this country
    _countrySubdivisionKey = CountryData.getSubdivisionTitle(country);
    // Select default is nothing is currently set
    if (!values.containsKey(_countrySubdivisionKey) &&
        _countrySubdivisionKey!.isNotEmpty) {
      values[_countrySubdivisionKey!] =
          CountryData.getSubdivisionList(_countrySubdivisionKey!)[0];
    }
  }

  void _handleSubmit(BuildContext context) {
    if (_formKey.currentState!.validate() && formCompletion == 1) {
      Navigator.push(
        context,
        StackPagesRoute(
          previousPages: [
            const PlantFormSummary(
              pageSize: .85,
              isHidden: true,
            ),
            const PlantFormInformation(
              isHidden: true,
              pageSize: .85,
            )
          ],
          enterPage: const PlantFormPayment(),
        ),
      );
    } else {
      setState(() {
        isFormErrorVisible = true;
      });
    }
  }
}
