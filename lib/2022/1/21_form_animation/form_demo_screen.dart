import 'package:daily_ui/2022/1/21_form_animation/plant_form_summary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'component/header.dart';
import 'component/stack_pages_route.dart';

class SharedFormState {
  Map<String, String> valuesByName = {};

  SharedFormState();
}

class PlantFormDemoScreen extends StatefulWidget {
  const PlantFormDemoScreen({Key? key}) : super(key: key);

  @override
  _PlantFormDemoScreenState createState() => _PlantFormDemoScreenState();
}

class _PlantFormDemoScreenState extends State<PlantFormDemoScreen> {
  GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Header(),
        //Use provider to pass down a FormState to each of the form views, this way they can easily share and update the same state object
        Provider<SharedFormState>(
          create: (context) => SharedFormState(),
          //Use WillPopScope to intercept hardware back taps, and instead pop the nested navigator
          child: WillPopScope(
            onWillPop: _handleBackPop,
            //Use a nested navigator to group the 3 form views under 1 parent view
            child: Navigator(
              key: navKey,
              onGenerateRoute: (route) {
                return StackPagesRoute(
                  previousPages: [],
                  enterPage: const PlantFormSummary(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> _handleBackPop() async {
    if (navKey.currentState!.canPop()) {
      // if the pop worked, return false, preventing any pops in the materialapp's navigator
      return !navKey.currentState!.canPop();
    }
    return true;
  }
}
