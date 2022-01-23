import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../styles.dart';

class DropdownMenu extends StatefulWidget {
  const DropdownMenu({
    Key? key,
    required this.onValidate,
    this.label = "",
    this.defaultOption = "",
    required this.options,
  }) : super(key: key);

  final Function onValidate;
  final String label;
  final String defaultOption;
  final List<String> options;

  @override
  _DropdownMenuState createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu> {
  late String _selectedOption;
  bool? _isValid;

  String get _keyValue => (widget.key as ValueKey).value as String;

  set isValid(bool isValid) {
    _isValid = isValid;
    widget.onValidate
        .call(name: _keyValue, isValid: _isValid, value: _selectedOption);
  }

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.defaultOption;
  }

  String? _validate(String? value) {
    if (value == null) {
      return "there is an error";
    } else {
      return null;
    }
  }

  Future<void> _showOptions() async {
    _selectedOption = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DropdownOptions(
                  title: widget.label,
                  selectedOption: _selectedOption,
                  options: widget.options,
                )));
  }

  @override
  Widget build(BuildContext context) {
    if (_isValid == null && _selectedOption.isNotEmpty) {
      isValid = true;
    }

    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        DropdownButtonFormField(
          key: UniqueKey(),
          onChanged: (val) {},
          value: _selectedOption,
          items: widget.options.map((o) {
            return DropdownMenuItem(
              value: o,
              child: Text(o, style: Styles.orderTotalLabel),
            );
          }).toList(),
          validator: _validate,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Styles.secondaryColor)),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Styles.errorColor)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Styles.lightGrayColor)),
            border: const OutlineInputBorder(),
            errorStyle: const TextStyle(color: Colors.transparent),
            helperText: '',
            hintText: widget.label,
            hintStyle: Styles.helperStyle,
          ),
        ),
        Positioned(
          top: 10,
          right: 15,
          child: Text('▼', style: Styles.iconDropdown),
        ),
        GestureDetector(
          onTap: _showOptions,
          child: Container(
            width: double.infinity,
            height: 60,
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }
}

class DropdownOptions extends StatefulWidget {
  const DropdownOptions({
    Key? key,
    required this.title,
    required this.options,
    this.selectedOption = "",
  }) : super(key: key);

  final String title;
  final List<String> options;
  final String selectedOption;

  @override
  _DropdownOptionsState createState() => _DropdownOptionsState();
}

class _DropdownOptionsState extends State<DropdownOptions> {
  late String _selectedOption;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption;
  }

  void _sendSelectedOption() {
    if (_selectedOption.isNotEmpty) {
      Navigator.pop(context, _selectedOption);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Select one of the options")));
    }
  }

  void _selectOption(String option) {
    setState(() {
      _selectedOption = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Center(
          child: Text(widget.title, style: Styles.optionsTitle),
        ),
        actions: [
          TextButton(
            onPressed: _sendSelectedOption,
            child: Text("Done", style: Styles.textButton),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF4F4F4),
      body: Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Styles.grayColor))),
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  for (String option in widget.options)
                    DropdownBuildOption(
                        onTap: () => _selectOption(option),
                        option: option,
                        iconColor: _selectedOption == option
                            ? Styles.secondaryColor
                            : Colors.transparent)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DropdownBuildOption extends StatelessWidget {
  const DropdownBuildOption({
    Key? key,
    required this.onTap,
    required this.option,
    required this.iconColor,
  }) : super(key: key);

  final VoidCallback onTap;
  final String option;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Styles.lightGrayColor,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(option, style: Styles.orderTotalLabel),
            Icon(Icons.check, color: iconColor, size: 40),
          ],
        ),
      ),
    );
  }
}
