import 'dart:ui';

import 'package:flutter_star_battle/model/ray.dart';

import '../app/global.dart';

class Enemy {
  double x;
  double y;

  double imageX = -0.99;

  // int durable = 2;
  Enemy(this.x, this.y);

  void changeImageX() {
    imageX += 0.67;
    if (imageX >= 1) {
      imageX = -.99;
    }
  }
  bool isCollision(Offset targetOffset, double targetWidth, double targetHeight) {
    return targetOffset.dx + targetWidth >= x - Global.shipSize / 2 &&
        targetOffset.dx <= x + Global.shipSize / 2 &&
        targetOffset.dy <= y + Global.shipSize && targetOffset.dy >= y;
  }

  void move() {
    y += 1;
  }
  void shot(List<Ray> rayList) {
    rayList.add(EnemyRay(x, y));
  }

}