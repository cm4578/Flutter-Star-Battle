import 'package:flutter/material.dart';
import 'package:flutter_star_battle/app/global.dart';

import '../app/color_ext.dart';

class EndDialog extends StatefulWidget {
  const EndDialog({super.key});

  @override
  State<EndDialog> createState() => _EndDialogState();
}

class _EndDialogState extends State<EndDialog> {

  var nameController = TextEditingController();

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
                  'You Dead !',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Score: ${Global.player.score}',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                // const Text(
                //   'Input Your Name',
                //   style: TextStyle(
                //       color: Colors.black,
                //       fontSize: 24,
                //       fontWeight: FontWeight.bold),
                // ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  height: 2,
                  thickness: 2,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                      onPressed: () {
                        Global.isGameOver.value = false;
                        Global.player.reset();
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: ColorExt.secondColor),
                      child: const Text(
                        'ReStart Game',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                // TextField(
                //   controller: nameController,
                //   decoration: const InputDecoration(
                //     border: OutlineInputBorder(borderSide: BorderSide(width: 2,color: Colors.black)),
                //     focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 2,color: Colors.black)),
                //   ),
                // ),
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
}
