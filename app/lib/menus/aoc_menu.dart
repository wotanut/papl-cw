import 'package:app/components/button.dart';
import 'package:app/components/mcdu_page.dart';
import 'package:app/components/slk.dart';
import 'package:app/pages/init.dart';
import 'package:flutter/material.dart';

class AocMenu extends StatefulWidget {
  const AocMenu({super.key});

  @override
  State<AocMenu> createState() => _AocMenuState();
}

class _AocMenuState extends State<AocMenu> {
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
          "ATSU DATALINK",
        ),
      ),
      body: const Mcdupage(slkButtons: [
        Slk(
          slk: 1,
          rightKey: MCDUEntryBTN(
            title: "WX",
            isRightSide: true,
          ),
          leftKey: MCDUEntryBTN(
            nextPage: FltInit(),
            title: "FLT INIT",
          ),
        ),
        Slk(
          slk: 2,
          leftKey: MCDUEntryBTN(title: "ATC REQ"),
          rightKey: MCDUEntryBTN(
            title: "ATIS",
            isRightSide: true,
          ),
        ),
        Slk(
          slk: 3,
          leftKey: null,
          rightKey: MCDUEntryBTN(
            title: "DIVERSION",
            isRightSide: true,
          ),
        ),
        Slk(
          slk: 4,
          rightKey: MCDUEntryBTN(
            title: "ADC DELAY",
            isRightSide: true,
          ),
          leftKey: MCDUEntryBTN(title: "FREE TEXT"),
        ),
        Slk(
          slk: 5,
          leftKey: MCDUEntryBTN(title: "ARR MSG"),
          rightKey: MCDUEntryBTN(
            title: "RCVD MSGS",
            isRightSide: true,
          ),
        )
      ]),
    );
  }
}
