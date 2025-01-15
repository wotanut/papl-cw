import 'package:app/components/button.dart';
import 'package:app/components/mcdu_page.dart';
import 'package:app/components/slk.dart';
import 'package:app/menus/aoc_menu.dart';
import 'package:flutter/material.dart';

class AtcMenu extends StatefulWidget {
  const AtcMenu({super.key});

  @override
  State<AtcMenu> createState() => _AtcMenuState();
}

class _AtcMenuState extends State<AtcMenu> {
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
          "ATC MENU",
        ),
      ),
      body: const Mcdupage(slkButtons: [
        Slk(
          slk: 1,
          rightKey: null,
          leftKey: MCDUEntryBTN(
            title: "REQUEST",
          ),
        ),
        Slk(
          slk: 4,
          rightKey: MCDUEntryBTN(
            title: "REPORTS",
            isRightSide: true,
          ),
          leftKey: MCDUEntryBTN(title: "MSG RECORD"),
        ),
        Slk(slk: 5, leftKey: MCDUEntryBTN(title: "CONNECTION"), rightKey: null),
        Slk(
          slk: 6,
          leftKey: MCDUEntryBTN(
            title: "ATSU RETURN",
            previousPage: AocMenu(),
          ),
          rightKey: null,
        )
      ]),
    );
  }
}
