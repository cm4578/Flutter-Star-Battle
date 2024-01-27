import 'dart:ui';

import 'package:flutter_star_battle/app/global.dart';

class Ray {
  double x;
  double y;

  Ray(this.x, this.y);

  void move(double height, {bool isPlayer = false}) {
    y -= 8;
  }

  bool isCollision(Offset targetOffset) {
    return x + Global.rayWidth >= targetOffset.dx &&
        x <= targetOffset.dx + Global.rayWidth &&
        y <= targetOffset.dy + Global.rayHeight &&
        y >= targetOffset.dy;
  }
}

class EnemyRay extends Ray {
  EnemyRay(super.x, super.y);

  @override
  void move(double height, {bool isPlayer = false}) {
    y += 8;
  }
}
