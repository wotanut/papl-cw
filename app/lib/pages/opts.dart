import 'package:app/components/button.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';

class Opts extends StatefulWidget {
  const Opts({super.key});

  @override
  State<Opts> createState() => _OptsState();
}

class _OptsState extends State<Opts> {
  final db = Localstore.getInstance();
  bool timings = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // For anroid, defualt on iOS
        actions: const [Icon(Icons.arrow_circle_up_sharp)],
        title: const Text(
          "Options",
        ),
        automaticallyImplyLeading: false, // REMOVES THE BACK BAR
        // did this for consistency with the rest of the mcdu
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Realistic Timings"),
                Switch.adaptive(
                  value: timings,
                  onChanged: (bool newValue) {
                    setState(() {
                      timings = newValue;
                    });
                    // final id = db.collection('settings').doc().id;
                    // db.collection('settings').doc(id).set({'timings': true});
                  },
                ),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MCDUEntryBTN(
                  title: "SAVE AND EXIT",
                  previousPage: MyHomePage(title: "MCDU MENU"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
