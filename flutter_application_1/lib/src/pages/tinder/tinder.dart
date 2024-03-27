import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/pages/tinder/tinderBackground.dart';
import 'package:flutter_application_1/src/pages/tinder/cardStack.dart';

// Define a model class to represent user profiles

class TinderPage extends StatefulWidget {
  @override
  _TinderPageState createState() => _TinderPageState();
}

class _TinderPageState extends State<TinderPage> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: const [
            BackgroudCurveWidget(),
            CardsStackWidget(),
          ],
        ),
    );
  }

}

enum Swipe { left, right, none }

