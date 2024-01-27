import 'package:flutter/material.dart';
import 'package:flutter_star_battle/model/player.dart';

class Global {
  static String instructionTitle = 'How to Play Star Battle.';
  static String instructionSubTitle =
      'Battle in Space with Star\n\rBattle Championship...';
  static List<String> instructions = [
    '1. Move the spaceship using the sensible areas in the screen',
    '2. The timer present the time lapsed',
    '3. The fuel counter show the remain fuel',
    '4. During the flight, the spaceship needs to destroy the asteroids and enemy spaceships that are presented in the space',
    '5. You can shoot pressing Space Bar',
    '6. If the spaceship hits a asteroid or another spaceship, you lose 15 points of fuel',
    '7. Enemy spaceship needs 1 shot to be destroyed, you will get 5 points for each enemy destroyed',
    '8. Asteroid needs 2 shots to be destroyed, you will get 10 points for each asteroid destroyed',
    '9. If you destroy a friendly spaceship, you lose 10 points',
    '10.During the flight, the spaceship needs to collect fuel in the space',
    '11.You can pause the game clicking in a button pause, or pressing the letter',
    '12.Go beyond all limits',
  ];
  static const shipSize = 80.0;
  static const playerShipSize = 90.0;

  static const aeroLiteSize = 90.0;
  static ValueNotifier<bool> isGameOver = ValueNotifier(false);
  static ValueNotifier<bool> isPause = ValueNotifier(false);

  static var player = Player(-1000, -1000);

  static const fuelSize = 40.0;

  static const rayHeight = 30.0;
  static const rayWidth = 5.0;
  static const minPlanetSize = 60;
  static const maxPlanetSize = 180;

  static Widget getMaskWidget(Color maskColor) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: maskColor,
    );
  }
}
