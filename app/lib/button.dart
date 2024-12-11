import 'package:flutter/material.dart';

class mcduEntryBTN extends StatefulWidget {
  final int slk; // slk = Select Key
  final bool isRightSide;
  final String title;
  // FIXME- Add link to page

  const mcduEntryBTN(
      {super.key, this.slk = 1, this.isRightSide = false, this.title = "Test"});

  @override
  State<mcduEntryBTN> createState() => _mcduEntryBTNState();
}

class _mcduEntryBTNState extends State<mcduEntryBTN> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.cyan)),
        child: TextButton(
            child: Text(widget.title),
            onPressed: () {
              print("Clicked");
            }));
  }
}
