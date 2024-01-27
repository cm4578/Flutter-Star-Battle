import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_star_battle/app/color_ext.dart';
import 'package:flutter_star_battle/app/global.dart';

import 'component/animate_instruct_text.dart';

class StarPlayDialog extends StatefulWidget {
  const StarPlayDialog({super.key});

  @override
  State<StarPlayDialog> createState() => _StarPlayDialogState();
}

class _StarPlayDialogState extends State<StarPlayDialog>
    with SingleTickerProviderStateMixin {
  ValueNotifier<bool> isShowHowToPlayBox = ValueNotifier(false);
  ValueNotifier<bool> isShowHowToPlayText = ValueNotifier(false);
  
  late AnimationController controller;
  late Animation<double> instructTitleAnimationValue;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    instructTitleAnimationValue = Tween(begin: 0.0,end: 1.0).animate(CurvedAnimation(parent: controller, curve: Curves.bounceInOut));


    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isShowHowToPlayText.value = true;
        setState(() {});
      }
    });

    controller.addListener(() {
      setState(() {});
    });
  }
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Dialog(
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: ColorExt.secondColor),
              borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Image.asset(
                  'assets/logo-02.png',
                  height: 80,
                  fit: BoxFit.fill,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Star Battle',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  height: 2,
                  thickness: 2,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildHowToPlayWidget(),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                          onPressed: () {
                            isShowHowToPlayBox.value = true;
                            setState(() {});
                          },
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: ColorExt.secondColor),
                          child: const Text(
                            'How to Play',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 2,
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: ColorExt.secondColor),
                          child: const Text(
                            'Start Game',
                            style: TextStyle(color: Colors.white),
                          )),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AnimatedContainer _buildHowToPlayWidget() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      onEnd: () {
        controller.forward();
      },
      width: double.infinity,
      height: isShowHowToPlayBox.value ? 150 : 0,
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.black),
          borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.only(bottom: isShowHowToPlayBox.value ? 20 : 0),
      child: isShowHowToPlayBox.value
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Transform.scale(
                      scale: instructTitleAnimationValue.value,
                      child: Opacity(
                        opacity: instructTitleAnimationValue.value,
                        child: Text(
                          Global.instructionTitle,
                          style: TextStyle(
                              color: ColorExt.secondColor, fontSize: 20),
                        ),
                      ),
                    ),
                    if (isShowHowToPlayText.value)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(Global.instructions.length + 1,
                            (index) {
                          if (index == (Global.instructions.length + 1) - 1) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: AnimateInstructText(
                                  text: Global.instructionSubTitle,
                                  style: TextStyle(
                                      color: ColorExt.secondColor, fontSize: 20),
                                  index: index),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: AnimateInstructText(
                                text: Global.instructions[index], index: index),
                          );
                        }),
                      )
                  ],
                ),
              ),
            )
          : null,
    );
  }
}


