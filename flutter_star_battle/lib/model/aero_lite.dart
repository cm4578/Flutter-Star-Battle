import 'dart:ui';

import 'package:flutter_star_battle/app/global.dart';

class AeroLite {
  double x;
  double y;
  double rotate = 0;

  AeroLite(this.x, this.y);

  var durable = 2;

  move() {
    y += 1.5;
    rotate += .02;
  }

  bool isCollision(Offset targetOffset, double targetWidth, double targetHeight) {

    return targetOffset.dx + targetWidth >= x - Global.aeroLiteSize / 2 &&
        targetOffset.dx <= x + Global.aeroLiteSize / 2 &&
        targetOffset.dy <= y + Global.aeroLiteSize && targetOffset.dy >= y;
  }
}
