import 'package:app/components/button.dart';
import 'package:app/components/mcdu_page.dart';
import 'package:app/components/slk.dart';
import 'package:flutter/material.dart';

class CommPage extends StatefulWidget {
  const CommPage({super.key});

  @override
  State<CommPage> createState() => _CommPageState();
}

class _CommPageState extends State<CommPage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // For anroid, defualt on iOS
        actions: const [Icon(Icons.arrow_circle_up_sharp)],
        title: const Text(
          "COMM MENU",
        ),
      ),
      body: const Mcdupage(slkButtons: [
        Slk(
          slk: 1,
          leftKey: MCDUEntryBTN(
            title: "REQUEST",
          ),
          rightKey: null,
        ),
        Slk(
          slk: 4,
          leftKey: null,
          rightKey: MCDUEntryBTN(
            title: "AOC MENU",
            isRightSide: true,
          ),
        ),
        Slk(
          slk: 5,
          leftKey: null,
          rightKey: MCDUEntryBTN(
            title: "DATALKINK STATUS",
            isRightSide: true,
          ),
        ),
        Slk(
            slk: 6,
            leftKey: null,
            rightKey: MCDUEntryBTN(
              title: "COMM MENU",
              isRightSide: true,
            ))
      ]),
    );
  }
}
