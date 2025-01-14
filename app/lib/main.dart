import 'package:app/components/button.dart';
import 'package:app/components/mcdu_page.dart';
import 'package:app/components/slk.dart';
import 'package:app/menus/dlk_menu.dart';
import 'package:app/pages/about.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyMCDU',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(1, 20, 21, 37),
          brightness: Brightness.dark,
        ),
      ),
      home: const MyHomePage(title: 'MCDU MENU'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
            "MCDU MENU",
          ),
        ),
        body: const Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Mcdupage(
            slkButtons: [
              Slk(
                slk: 1,
                rightKey: null,
                leftKey: MCDUEntryBTN(
                  title: "FMGC",
                ),
              ),
              Slk(
                slk: 2,
                rightKey: null,
                leftKey: MCDUEntryBTN(
                  nextPage: DlkPage(),
                  title: "ATSU",
                ),
              ),
              Slk(
                slk: 5,
                leftKey: null,
                rightKey: MCDUEntryBTN(
                  title: "OPTS",
                  isRightSide: true,
                ),
              ),
              Slk(
                slk: 6,
                leftKey: null,
                rightKey: MCDUEntryBTN(
                  nextPage: About(),
                  title: "ABOUT",
                  isRightSide: true,
                ),
              )
            ],
          ),
        ));
  }
}
