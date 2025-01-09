import 'dart:async';

import 'package:app/components/button.dart';
import 'package:app/components/mcduPage.dart';
import 'package:app/components/slk.dart';
import 'package:app/controllers/flight.dart';
import 'package:app/models/Flight.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FltInit extends StatefulWidget {
  const FltInit({super.key});

  @override
  State<FltInit> createState() => _FltInitState();
}

class _FltInitState extends State<FltInit> {
  String scratchpad = "";
  String callsign = "", departure = "", dest = "", altn = "", ete = "";
  DateTime time = DateTime.now();
  Future<Flight>? _futureFlight;

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
        body: FutureBuilder(
            future: _futureFlight,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return AlertDialog.adaptive(
                  icon: const Icon(Icons.warning),
                  iconColor: Colors.red,
                  shadowColor: Colors.amberAccent,
                  title: const Text(
                      'An error occured whilst initialising the flight'),
                  content: Text('${snapshot.error}'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Ok'),
                      child: const Text('Ok'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Uri url =
                            Uri.https("https://discord.gg", '/2w5KSXjhGe');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url'; //  #FIXME - alert dialog
                        }
                        Navigator.pop(context, 'Report');
                      },
                      child: const Text('Report'),
                    ),
                  ],
                );
              }

              return Stack(children: [
                Mcdupage(
                  slkButtons: [
                    Slk(
                        slk: 1,
                        leftKey: GestureDetector(
                          onTap: () {
                            callsign = scratchpad;
                            setState(() {}); //NOTE - Needed to update the UI
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text("FLT NO"),
                              Text(callsign.isNotEmpty
                                  ? callsign
                                  : (snapshot.data?.callsign ?? ""))
                            ],
                          ),
                        ),
                        rightKey: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("UTC"),
                            Text(time.hour.toString() +
                                time.minute
                                    .toString()) // FIXME - Make update every minute
                          ],
                        )),
                    Slk(
                        slk: 2,
                        leftKey: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("DEP"),
                            Text(departure.isNotEmpty
                                ? departure
                                : (snapshot.data?.dep ?? ""))
                          ],
                        ),
                        rightKey: null),
                    Slk(
                        slk: 3,
                        leftKey: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("DEST"),
                            Text(dest.isNotEmpty
                                ? dest
                                : (snapshot.data?.dest ?? ""))
                          ],
                        ),
                        rightKey: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("DATE"),
                            Text("${time.day}/${time.month}/${time.year}")
                          ],
                        )),
                    Slk(
                        slk: 4,
                        leftKey: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("ALTN"),
                            Text(altn.isNotEmpty
                                ? altn
                                : (snapshot.data?.altn ?? ""))
                          ],
                        ),
                        rightKey: null),
                    Slk(
                        slk: 5,
                        leftKey: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("ETE"),
                            Text(ete.isNotEmpty
                                ? ete
                                : (snapshot.data?.ete ?? ""))
                          ],
                        ),
                        rightKey: null),
                    Slk(
                      slk: 6,
                      leftKey: mcduEntryBTN(
                          title: "AOC MENU",
                          callback: () {
                            Navigator.pop(context);
                          }),
                      rightKey:
                          snapshot.connectionState == ConnectionState.waiting
                              ? const CircularProgressIndicator.adaptive()
                              : TextButton(
                                  child: const Text("INIT DATA REQ *"),
                                  onPressed: () {
                                    setState(() {
                                      _futureFlight = createFlight(
                                          callsign, dest, departure, altn, ete);
                                    });
                                  }),
                    )
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
              ]);
            }));
  }

  FutureBuilder<Flight> buildFutureBuilder() {
    return FutureBuilder<Flight>(
        future: _futureFlight,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.dest);
          } else if (snapshot.hasError) {
            Future(() {
              // showDialog(context: context, builder: (context) => ErrorWidget());
            });
            return const CircularProgressIndicator();
          }
          return Container();
        });
  }
}
