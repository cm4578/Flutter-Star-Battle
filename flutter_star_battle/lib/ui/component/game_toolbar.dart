import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_star_battle/app/global.dart';

class GameToolBar extends StatefulWidget {
  const GameToolBar({super.key});

  @override
  State<GameToolBar> createState() => _GameToolBarState();
}

class _GameToolBarState extends State<GameToolBar> {
  var isChange = true;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      isChange = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Align(alignment: Alignment.bottomCenter,child: _buildGamePod(),),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Spacer(),
              _buildCircleWidget(Text(
                '${(Global.player.time ~/ 60).toString().padLeft(2,'0')}:${(Global.player.time % 60).toString().padLeft(2,'0')}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              )),
              _buildCircleWidget(Text(
                Global.player.score.toString(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              )),
              _buildCircleWidget(IconButton(
                  onPressed: () {
                    Global.isPause.value = !Global.isPause.value;
                    setState(() {});
                  },
                  icon: Icon(
                    Global.isPause.value
                        ? Icons.play_arrow_rounded
                        : Icons.pause_rounded,
                    color: Colors.white,
                  ))),

              _buildCircleWidget(Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: LayoutBuilder(builder: (context, con) {
                      return AnimatedContainer(
                        onEnd: () {
                          isChange = !isChange;
                          setState(() {});
                        },
                        duration: const Duration(milliseconds: 600),
                        color: isChange
                            ? Colors.red
                            : Colors.black.withOpacity(0.3),
                        alignment: Alignment.center,
                        height: con.maxHeight * (Global.player.fuel / 30),
                        width: double.infinity,
                      );
                    }),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/fuel.png',
                        width: 30,
                        fit: BoxFit.fill,
                      ),
                      Text(
                        '${Global.player.fuel}',
                        style:
                        const TextStyle(color: Colors.white, fontSize: 16),
                      )
                    ],
                  )
                ],
              )),

            ],
          ),
        ],
      ),
    ));
  }

  GlobalKey controlPodKey = GlobalKey();

  Widget _buildGamePod() {
    return GestureDetector(
      onPanUpdate: (details) {
        var margin = 30;
        double centerX = margin + 110 / 2;
        double centerY = 110 / 2;
        double radius = 110 / 2;

        var distance = Offset(details.localPosition.dx - centerX, details.localPosition.dy - centerY);

        if (radius < sqrt(pow(distance.dx, 2) + pow(distance.dy, 2))) {
          Global.player.setSpeed(0, 0);
          return;
        }
        Global.player.controlX = details.localPosition.dx;
        Global.player.controlY = details.localPosition.dy;
        Global.player.setSpeed(distance.dy / 10, distance.dx / 10);
        setState(() {});
      },
      child: Container(
        key: controlPodKey,
        margin: const EdgeInsets.only(left: 30),
        decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.5),
            borderRadius: BorderRadius.circular(999)),
        height: 110,
        width: 110,
        child: Stack(
          children: [
            Positioned(
                top: 2,
                left: 0,
                right: 0,
                child: Transform.rotate(
                  angle: pi * 0.5,
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.green,
                  ),
                )),
            Positioned(
                left: 0,
                right: 0,
                bottom: 2,
                child: Transform.rotate(
                  angle: pi * 1.5,
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.green,
                  ),
                )),
            Positioned(
                left: 2,
                top: 0,
                bottom: 0,
                child: Transform.rotate(
                  angle: pi * 2,
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.green,
                  ),
                )),
            Positioned(
                right: 2,
                top: 0,
                bottom: 0,
                child: Transform.rotate(
                  angle: pi * 1,
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.green,
                  ),
                )),
            Transform.translate(
              offset: Offset(Global.player.controlX - 20 * 2, Global.player.controlY - 20 / 2),
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: Colors.greenAccent
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleWidget(Widget child) {
    return SizedBox(
      height: 75,
      width: 75,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Colors.green.withOpacity(0.6),
        shape: RoundedRectangleBorder(
            side: const BorderSide(width: 2, color: Colors.greenAccent),
            borderRadius: BorderRadius.circular(999)),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
