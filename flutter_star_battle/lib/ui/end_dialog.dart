import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_star_battle/app/global.dart';
import 'package:flutter_star_battle/app/sql_helper.dart';

import '../app/color_ext.dart';
import '../model/player.dart';

class EndDialog extends StatefulWidget {
  const EndDialog({super.key});

  @override
  State<EndDialog> createState() => _EndDialogState();
}

class _EndDialogState extends State<EndDialog> {
  var nameController = TextEditingController();
  var isContinue = false;
  var isAllRank = false;
  List<Player> rankList = [];
  SqlHelper sqlHelper = SqlHelper();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) async {

      rankList = await sqlHelper.getAllRankData();
      setState(() {});
    });
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
                _buildTitle(),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  height: 2,
                  thickness: 2,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 10,
                ),
                if (isContinue) _buildRankList(),
                if (!isContinue) _buildInputNameWidget(),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                      onPressed: () async {
                        if (isContinue) {
                          nameController.text = '';
                          Global.isGameOver.value = false;
                          Global.player.reset();
                          Navigator.pop(context);
                          return;
                        }
                        await sqlHelper.addRankData(Player(nameController.text, Global.player.score, Global.player.time));
                        rankList = await sqlHelper.getAllRankData();
                        isContinue = true;
                        setState(() {});
                      },
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: ColorExt.secondColor),
                      child: Text(
                        isContinue ? 'Start Game' : 'Continue',
                        style: const TextStyle(color: Colors.white),
                      )),
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

  Text _buildTitle() {
    if (isContinue) {
      return Text(
        isAllRank ? 'All Ranking Table' : 'Ranking Table',
        style: const TextStyle(
            color: Colors.black, fontSize: 19, fontWeight: FontWeight.bold),
      );
    }
    return const Text(
      'Input Your Name',
      style: TextStyle(
          color: Colors.black, fontSize: 19, fontWeight: FontWeight.bold),
    );
  }

  Column _buildInputNameWidget() {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: 'input...',
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(width: 2, color: Colors.black)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(width: 2, color: Colors.black)),
          ),
        ),
      ],
    );
  }

  Column _buildRankList() {
    return Column(
      children: [
        Container(
          color: ColorExt.deepYellowColor,
          child: const Row(
            children: [
              Expanded(
                  child: Text(
                'Position',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )),
              Expanded(
                  child: Text(
                'Name',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )),
              Expanded(
                  child: Text(
                'Score',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )),
              Expanded(
                  child: Text(
                'Time',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var dataSet = rankList[index];
            return Container(
              color: dataSet.name == nameController.text ? Colors.yellow :  index % 2 == 0
                  ? ColorExt.littleYellowColor
                  : ColorExt.yellowColor,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    (index + 1).toString(),
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    dataSet.name,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    dataSet.score.toString(),
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    dataSet.time.toString(),
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )),
                ],
              ),
            );
          },
          itemCount: rankList.length,
        ),
      ],
    );
  }
}
