import 'package:flutter/material.dart';

class TextConverterScreen extends StatefulWidget {
  const TextConverterScreen({Key? key}) : super(key: key);

  @override
  State<TextConverterScreen> createState() => _TextConverterScreenState();
}

class _TextConverterScreenState extends State<TextConverterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconTheme.of(context),
      ),
    );
  }
}
