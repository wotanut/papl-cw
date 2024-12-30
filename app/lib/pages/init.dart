import 'package:app/button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FltInit extends StatefulWidget {
  const FltInit({super.key});

  @override
  State<FltInit> createState() => _FltInitState();
}

class _FltInitState extends State<FltInit> {
  String scratchpad = "";

  void _changeSPADEntry() {
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
            "AOC FLT INIT",
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [const Text("FLT NO"), Text(scratchpad)],
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [Text("UTC"), Text("1123")],
                      )
                    ],
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [Text("DEP"), Text("LSZH")],
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [Text("DEST"), Text("EGLL")],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [Text("DATE"), Text("12/22/2024")],
                      )
                    ],
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [Text("ALTN"), Text("EKCH")],
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [Text("ETE"), Text("0054")],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      mcduEntryBTN(
                          title: "AOC MENU",
                          callback: () {
                            Navigator.pop(context);
                          }),
                      TextButton(
                          child: const Text("INIT DATA REQ *"),
                          onPressed: () {
                            http.get(Uri.parse(
                                'https://jsonplaceholder.typicode.com/albums/1'));
                          }),
                    ],
                  ),
                ],
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: TextField(
                  onSubmitted: (value) {
                    scratchpad = value;
                    _changeSPADEntry();
                  },
                ),
              )
            ],
          ),
        ));
  }
}
