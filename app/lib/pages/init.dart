import 'dart:convert';
import 'dart:math';

import 'package:app/button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../globals.dart' as globals;

class FltInit extends StatefulWidget {
  const FltInit({super.key});

  @override
  State<FltInit> createState() => _FltInitState();
}

class _FltInitState extends State<FltInit> {
  String scratchpad = "";
  String callsign = "", departure = "", dest = "", altn = "", ete = "";

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
                      GestureDetector(
                        onTap: () {
                          callsign = scratchpad;
                          setState(() {}); //NOTE - Needed to update the UI
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [const Text("FLT NO"), Text(callsign)],
                        ),
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [Text("UTC"), Text("1123")],
                      )
                    ],
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [const Text("DEP"), Text(departure)],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [const Text("DEST"), Text(dest)],
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [Text("DATE"), Text("12/22/2024")],
                      )
                    ],
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [const Text("ALTN"), Text(altn)],
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [const Text("ETE"), Text(ete)],
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
                            http.post(
                                Uri.parse('${globals.apiURL}/init/request'),
                                body: jsonEncode(<String, String>{
                                  "id": callsign,
                                  "dest": dest,
                                  "dep": departure,
                                  "altn": altn,
                                  "ete": "ete",
                                  "ADCReq": Random().nextBool().toString()
                                }));
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
                    print("updated scratchpad value");
                    _changeSPADEntry();
                  },
                ),
              )
            ],
          ),
        ));
  }
}
