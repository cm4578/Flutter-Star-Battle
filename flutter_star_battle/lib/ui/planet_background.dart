import 'package:flutter/material.dart';
import 'package:flutter_star_battle/app/global.dart';

import '../model/planet.dart';

class PlantBackGround extends StatefulWidget {
  const PlantBackGround({super.key});

  @override
  State<PlantBackGround> createState() => _PlantBackGroundState();
}

class _PlantBackGroundState extends State<PlantBackGround> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  List<String> planetImageList = [
    'planet-001.png',
    'planet-002.png',
    'planet-003_s.png',
    'planet-004_s.png',
    'planet-005_s.png',
    'planet-006.png',
  ];
  List<Planet> planetList = [];

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      final size = MediaQuery.of(context).size;
      init(size);
      controller = AnimationController(vsync: this, duration: const Duration(seconds: 3));
      controller.repeat();

      controller.addListener(() {
        for (var i = 0; i < planetList.length; ++i) {
          planetList[i].move();
        }
        setState(() {});
      });

      setState(() {});
    });
  }

  void init(Size size) {
    planetList = List.generate(planetImageList.length, (index) {
      return Planet(size.width, size.height, planetImageList[index]);
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/background-1.jpg',
          fit: BoxFit.cover,
          height: double.infinity,
        ),
        Stack(
          children: List.generate(planetList.length, (index) {
            return Transform.translate(
              offset: Offset(planetList[index].x, planetList[index].y),
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'assets/${planetList[index].imagePath}',
                  height: planetList[index].getPlantSize(),
                  fit: BoxFit.fill,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
