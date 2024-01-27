import 'dart:math';

class Explode {
  double x;
  double y;
  double scale = 0.0;

  Explode(this.x, this.y);


  changeScale() {
    scale += 0.05;
    scale = min(scale, 1);
  }

}