import 'dart:math';
import 'dart:ui';

import 'package:flutter_star_battle/app/global.dart';

class Player {
  double x;
  double y;
  double controlX = 0.0;
  double controlY = 0.0;
  int fuel = 15;
  int score = 0;
  double angle = 0.0;
  Speed speed = Speed(0, 0);

  Player(this.x, this.y);


  reset() {
    controlX = 0;
    controlX = 0;
    angle = 0;
    score = 0;
    fuel = 15;
    setSpeed(0, 0);
  }

  setXY(double x,double y) {
    this.x = x;
    this.y = y;
  }
  setSpeed(double vertical,double horizontal) {
    speed.vertical = vertical;
    speed.horizontal = horizontal;
  }

  move(double screenWidth,double screenHeight) {
    x += speed.horizontal;
    y += speed.vertical;
    angle = speed.horizontal * 5 * (pi / 180);

    x = min(screenWidth - Global.shipSize,max(0, x));
    y = min(screenHeight - Global.shipSize,max(0, y));
  }

  bool isCollision(Offset targetOffset,double targetWidth,double targetHeight) {
    return x + Global.playerShipSize >= targetOffset.dx &&
        x <= targetOffset.dx &&
        y <= targetOffset.dy + targetHeight &&
        y + Global.playerShipSize >= targetOffset.dy;
  }
}
class Speed {
  double vertical;
  double horizontal;

  Speed(this.vertical, this.horizontal);

}