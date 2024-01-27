import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_star_battle/app/global.dart';
import 'package:flutter_star_battle/model/Enemy.dart';
import 'package:flutter_star_battle/model/aero_lite.dart';
import 'package:flutter_star_battle/model/explode.dart';
import 'package:flutter_star_battle/ui/end_dialog.dart';
import 'package:flutter_star_battle/ui/planet_background.dart';
import 'package:flutter_star_battle/ui/start_play_dialog.dart';
import 'package:flutter_star_battle/utils/audio_utils.dart';
import '../model/fuel.dart';
import '../model/ray.dart';
import 'component/game_toolbar.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  late AnimationController controller;


  List<Ray> rays = [];
  List<Explode> explodeList = [];
  List<Enemy> enemyList = [];
  List<AeroLite> aeroLites = [];
  List<Fuel> fuelList = [];
  Timer? timer;
  bool isGameOver = false;
  Widget? maskWidget;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    Global.isGameOver.addListener(() {
      if (Global.isGameOver.value) {
        showDialog(context: context,barrierDismissible: false, builder: (context) => const EndDialog());
        _stopGame();
      } else {
        _startGame();
      }
    });

    Global.isPause.addListener(() {
      if (Global.isPause.value) {
        maskWidget = Global.getMaskWidget(Colors.white.withOpacity(0.2));
        _stopGame();
      } else {
        _reStartGame();
      }

      setState(() {});
    });

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) async {
      await showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.white.withOpacity(0.1),
          builder: (context) {
            return const StarPlayDialog();
          });
      _init();
    });
  }
  void _startGame() {
    final size = MediaQuery.of(context).size;
    enemyList.clear();
    rays.clear();
    aeroLites.clear();
    fuelList.clear();
    Global.player.setXY(size.width / 2 - Global.playerShipSize / 2, size.height - Global.playerShipSize - 30);
    maskWidget = null;
    AudioUtils.playBackground();
    _initTimer(size);
    controller.repeat();
  }
  void _reStartGame() {
    final size = MediaQuery.of(context).size;
    maskWidget = null;
    AudioUtils.playBackground();
    _initTimer(size);
    controller.repeat();
  }
  void _stopGame() {
    AudioUtils.stopBackgroundAudio();
    timer?.cancel();
    controller.stop();
  }

  void _init() {
    AudioUtils.playBackground();
    final size = MediaQuery.of(context).size;
    controller.repeat();

    controller.addListener(() {
      var playerRays = rays.where((e) => e is! EnemyRay).toList();
      var enemyRays = rays.whereType<EnemyRay>().toList();

      for (var i = 0; i < playerRays.length; i++) {
        if (aeroLites.any((aeroLite) => aeroLite.isCollision(
            Offset(playerRays[i].x, playerRays[i].y),
            Global.rayWidth,
            Global.rayHeight))) {
          var aeroLite = aeroLites.firstWhere((aeroLite) => aeroLite.isCollision(Offset(playerRays[i].x, playerRays[i].y), Global.rayWidth, Global.rayHeight));
          aeroLite.durable -= 1;
          if (aeroLite.durable == 0) {
            Global.player.score += 10;
            AudioUtils.playDestroy();
            aeroLites.remove(aeroLite);
            explodeList.add(Explode(aeroLite.x, aeroLite.y));
          }
          rays.remove(playerRays[i]);
        }

        for (var j = 0; j < enemyRays.length; j++) {
          if (playerRays[i].isCollision(Offset(enemyRays[j].x, enemyRays[j].y))) {
            AudioUtils.playDestroy();
            rays.remove(enemyRays[j]);
            rays.remove(playerRays[i]);
          }
        }
      }
      for (var i = 0; i < rays.length; ++i) {
        rays[i].move(size.height);
        if (rays[i].y < 0 || rays[i].y > size.height) {
          rays.remove(rays[i]);
        }
      }

      for (var aeroLite in aeroLites) {
        aeroLite.move();
      }

      for (var i = 0; i < enemyList.length; i++) {
        enemyList[i].move();
        if (enemyList[i].y > size.height) {
          enemyList.removeAt(i);
        }
        if (playerRays.any((ray) => enemyList[i].isCollision(Offset(ray.x, ray.y), Global.rayWidth, Global.rayHeight))) {
          AudioUtils.playDestroy();
          Global.player.score += 1;
          explodeList.add(Explode(enemyList[i].x, enemyList[i].y));
          rays.remove(playerRays.firstWhere((ray) => enemyList[i].isCollision(Offset(ray.x, ray.y), Global.rayWidth, Global.rayHeight)));

          enemyList.removeAt(i);
        }
      }

      for (var i = 0; i < explodeList.length; i++) {
        explodeList[i].changeScale();
        if (explodeList[i].scale >= 1) {
          explodeList.remove(explodeList[i]);
        }
      }
      for (var i = 0; i < fuelList.length; ++i) {
        if (Global.player.isCollision(Offset(fuelList[i].x, fuelList[i].y), Global.fuelSize, Global.fuelSize)) {
          Global.player.fuel = 30;
          fuelList.removeAt(i);
          continue;
        }

        if (fuelList[i].y > size.height) {
          fuelList.removeAt(i);
          continue;
        }
        fuelList[i].update();
      }

      var isCollisionEnemy = enemyList.any((e) => Global.player
          .isCollision(Offset(e.x, e.y), Global.shipSize, Global.shipSize));
      var isCollisionAeroLite = aeroLites.any((e) => Global.player.isCollision(
          Offset(e.x, e.y), Global.aeroLiteSize, Global.aeroLiteSize));
      var isCollisionEnemyRay = enemyRays.any((e) => Global.player
          .isCollision(Offset(e.x, e.y), Global.rayWidth, Global.rayHeight));

      if (isCollisionEnemy || isCollisionAeroLite || isCollisionEnemyRay) {
        AudioUtils.playDestroy();
        AudioUtils.stopBackgroundAudio();
        Global.isGameOver.value = true;
        timer?.cancel();
        controller.stop();
      }
      Global.player.move(size.width, size.height);

      setState(() {});
    });
    Global.player.setXY(size.width / 2 - Global.playerShipSize / 2, size.height - Global.playerShipSize - 30);
    _initTimer(size);
  }

  void _initTimer(Size size) {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (Global.player.fuel == 0) {
        AudioUtils.playDestroy();
        Global.isGameOver.value = true;
        timer.cancel();
        return;
      }
      for (var i = 0; i < enemyList.length; ++i) {
        enemyList[i].changeImageX();
        if (timer.tick % 5 == 0) enemyList[i].shot(rays);
      }

      if (fuelList.isEmpty) {
        fuelList.add(Fuel(size.width, size.height));
      }

      if (timer.tick % 10 == 0) {
        aeroLites.add(AeroLite(
            Random()
                .nextInt(size.width.toInt() - Global.shipSize.toInt())
                .toDouble(),
            0));
      }
      if (timer.tick % 5 == 0) {
        enemyList.add(Enemy(
            Random()
                .nextInt(size.width.toInt() - Global.shipSize.toInt())
                .toDouble(),
            0));
      }
      Global.player.fuel -= 1;
      // rays.add(Ray(shopPosition.dx + shopSize / 2 - Global.rayWidth / 2, shopPosition.dy - 20));
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (Global.isGameOver.value) return;
          AudioUtils.playShot();
          rays.add(Ray(Global.player.x + Global.playerShipSize / 2 - Global.rayWidth / 2,
              Global.player.y - 18));
        },
        child: Stack(
          children: [
            const PlantBackGround(),
            Transform.translate(
                offset: Offset(Global.player.x, Global.player.y),
                child: Transform.rotate(angle: Global.player.angle,child: Image.asset(
                  'assets/shop.png',
                  height: Global.playerShipSize,
                  width: Global.playerShipSize,
                  fit: BoxFit.fill,
                ),)),
            Stack(
              children: List.generate(rays.length, (index) {
                var ray = rays[index];
                return Transform.translate(
                    offset: Offset(ray.x, ray.y),
                    child: Container(
                      color: ray is EnemyRay ? Colors.red : Colors.blue,
                      width: 5,
                      height: Global.rayHeight,
                    ));
              }),
            ),
            Stack(
              children: List.generate(enemyList.length, (index) {
                return Transform.translate(
                    offset: Offset(enemyList[index].x - Global.shipSize / 2,
                        enemyList[index].y),
                    child: Image.asset(
                      'assets/ship_1.png',
                      width: Global.shipSize,
                      height: Global.shipSize,
                      fit: BoxFit.cover,
                      alignment: Alignment(enemyList[index].imageX, 0),
                    ));
              }),
            ),
            Stack(
              children: List.generate(aeroLites.length, (index) {
                var aeroLite = aeroLites[index];
                return Transform.translate(
                    offset: Offset(
                        aeroLite.x - Global.aeroLiteSize / 2, aeroLite.y),
                    child: Transform.rotate(
                      angle: aeroLite.rotate,
                      child: Image.asset(
                        aeroLite.durable == 2
                            ? 'assets/aestroid_brown.png'
                            : 'assets/asteroid_broken.png',
                        width: Global.aeroLiteSize,
                        height: Global.aeroLiteSize,
                        fit: BoxFit.fill,
                      ),
                    ));
              }),
            ),
            Stack(
              children: List.generate(fuelList.length, (index) {
                var fuel = fuelList[index];
                return Transform.translate(
                  offset: Offset(fuel.x, fuel.y),
                  child: Transform.rotate(
                    angle: pi * fuel.angle,
                    child: Image.asset('assets/fuel.png',width: Global.fuelSize,height: Global.fuelSize,),
                  ),
                );
              }),
            ),
            Stack(
              children: List.generate(explodeList.length, (index) {
                var explode = explodeList[index];
                return Transform.translate(
                    offset:
                        Offset(explode.x - Global.aeroLiteSize / 2, explode.y),
                    child: Transform.scale(
                      scale: explode.scale,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: Colors.red,
                        ),
                        height: Global.aeroLiteSize,
                        width: Global.aeroLiteSize,
                      ),
                    ));
              }),
            ),
            maskWidget ?? const SizedBox(),
            const Positioned(right: 15, bottom: 5, child: GameToolBar()),
          ],
        ),
      ),
    );
  }
}
