import 'package:daily_ui/2022/4/20_splash_tap/splash.dart';
import 'package:flutter/material.dart';

class SplashTapScreen extends StatelessWidget {
  const SplashTapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Splash(
              child: const Text("Click Me"),
              onTap: () {},
            ),
            const SizedBox(height: 30),
            Splash(
              onTap: () {},
              child: Container(
                width: 120,
                height: 200,
                color: Colors.blue,
                alignment: Alignment.center,
                child: const Text(
                  "Click Me for bigger splash",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
