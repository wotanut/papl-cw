import 'package:app/button.dart';
import 'package:app/mcduPage.dart';
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
      title: 'Flutter Demo', //TODO: Name the app
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0x000228d5),
            surface: const Color(
                0x000228d5)), // Background colour (background was depricated)
        useMaterial3: true,
        textTheme: const TextTheme().copyWith(
          bodySmall: const TextStyle(color: Colors.white),
          bodyMedium: const TextStyle(color: Colors.white),
          bodyLarge: const TextStyle(color: Colors.white),
          labelSmall: const TextStyle(color: Colors.white),
          labelMedium: const TextStyle(color: Colors.white),
          labelLarge: const TextStyle(color: Colors.white),
          displaySmall: const TextStyle(color: Colors.white),
          displayMedium: const TextStyle(color: Colors.white),
          displayLarge: const TextStyle(color: Colors.white),
          titleLarge: const TextStyle(color: Colors.white),
          titleMedium: const TextStyle(color: Colors.white),
          titleSmall: const TextStyle(color: Colors.white),
        ),
      ),
      home: const MyHomePage(title: 'MCDU MENU'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _counter = 0;

  void _incrementCounter() {
    setState(() {});
  }

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
          "MCDU MENU",
        ),
      ),
      body: const Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Mcdupage(slkButtons: [
        mcduEntryBTN(
          isRightSide: true,
          title: "FMGC",
        ),
        mcduEntryBTN(),
        mcduEntryBTN(
          isRightSide: true,
          title: "ATSU",
        ),
        mcduEntryBTN(
          title: "OPTS",
        ),
        mcduEntryBTN(
          title: "ABOUT",
        ),
        mcduEntryBTN(),
        mcduEntryBTN(),
        mcduEntryBTN(),
        mcduEntryBTN(),
        mcduEntryBTN(),
        mcduEntryBTN(),
        mcduEntryBTN()
      ])),
    );
  }
}
