import 'dart:math';
import 'dart:ui';

import '../app/global.dart';

class Fuel {
  double x = 0;
  double y = 0;
  double angle = 0.0;
  double screenHeight;

  bool isReverse = false;

  Fuel(double screenWidth,this.screenHeight) {
    x = Random().nextInt(screenWidth.toInt()).toDouble();
  }

  update() {

    if (angle >= 0.2) {
      isReverse = true;
    }
    if (angle <= -0.2) {
      isReverse = false;
    }
    y += 3;
    angle = isReverse ? angle - 0.01 : angle + 0.01;
  }


}