import 'package:app/button.dart';
import 'package:app/controllers/flight.dart';
import 'package:app/models/Flight.dart';
import 'package:flutter/material.dart';

class FltInit extends StatefulWidget {
  const FltInit({super.key});

  @override
  State<FltInit> createState() => _FltInitState();
}

class _FltInitState extends State<FltInit> {
  String scratchpad = "";
  String callsign = "", departure = "", dest = "", altn = "", ete = "";
  DateTime time = DateTime.now();

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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("UTC"),
                          Text(time.hour.toString() +
                              time.minute
                                  .toString()) // FIXME - Make update every minute
                        ],
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("DATE"),
                          Text("${time.day}/${time.month}/${time.year}")
                        ],
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
                            Future<Flight?> flt = createFlight(
                                callsign, dest, departure, altn, ete);

                            if (flt == null) {
                              print("null");
                            }
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
