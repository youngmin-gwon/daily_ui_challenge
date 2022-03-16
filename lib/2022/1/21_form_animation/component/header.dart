import 'package:daily_ui/2022/1/21_form_animation/styles.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.topCenter,
      child: Scaffold(
        body: Container(
          height: screenSize.height * .25,
          width: screenSize.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/plant_header_background.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.white60, BlendMode.screen),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("The".toUpperCase(), style: Styles.appTitle),
                  Text("Plant Store", style: Styles.appTitle),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
