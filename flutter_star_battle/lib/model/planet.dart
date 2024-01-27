import 'dart:math';

import 'package:flutter_star_battle/app/global.dart';


class Planet {
  double x = 0.0;
  double y = 0.0;
  double size = 0.0;

  double screenWidth;
  double screenHeight;
  String imagePath;

  Planet(this.screenWidth, this.screenHeight, this.imagePath) {
    init(screenWidth, screenHeight);
  }

  double getPlantSize() {
    return size;
  }

  void init(double screenWidth, double screenHeight, {bool isReStart = false}) {
    var random = Random();
    var randomX = random.nextInt((screenWidth - getPlantSize() / 2).toInt());
    x = randomX.toDouble();
    size = Global.minPlanetSize +  random.nextInt(Global.maxPlanetSize - Global.minPlanetSize.toInt()).toDouble();

    if (isReStart) {
      y = -getPlantSize();
      return;
    }
    y = random.nextInt((screenHeight - getPlantSize()).round()).toDouble();
  }

  void move() {
    y += (2 * (size - Global.minPlanetSize) / (Global.maxPlanetSize - Global.minPlanetSize)) + 0.03;

    if (y > screenHeight) {
      init(screenWidth, screenHeight, isReStart: true);
    }
  }
}

