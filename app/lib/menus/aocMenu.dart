import 'package:app/components/button.dart';
import 'package:app/components/mcduPage.dart';
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
          // FIXME: make button to push on DDU
          actions: const [Icon(Icons.arrow_circle_up_sharp)],
          title: const Text(
            "ATSU DATALINK",
          ),
        ),
        body: Mcdupage(slkButtons: [
          Slk(
            leftKey: null,
            rightKey: mcduEntryBTN(
              callback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FltInit()),
                );
              },
              title: "FLT INIT",
              slk: 1,
              isRightSide: true,
            ),
          ),
        ]));
  }
}
