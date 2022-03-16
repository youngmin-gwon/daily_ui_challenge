import 'package:flutter/material.dart';

class CardGradientScreen extends StatelessWidget {
  const CardGradientScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          color: Colors.red,
          height: 300,
          width: 200,
        ),
      ),
    );
  }
}
