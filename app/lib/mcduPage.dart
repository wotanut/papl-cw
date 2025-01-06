import 'package:app/components/button.dart';
import 'package:flutter/material.dart';

// NOTE - This is used as a template for 99% of pages, not all of them though. Such as the about page, pages with text input or pages that don't conform to the standard page

class Mcdupage extends StatefulWidget {
  final List<mcduEntryBTN> slkButtons;

  const Mcdupage({super.key, required this.slkButtons});

  @override
  State<Mcdupage> createState() => _McdupageState();
}

class _McdupageState extends State<Mcdupage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];

    // first iteration - Generate all of the explicitly defined select keys
    for (int i = 0; i < 6; i++) {
      if (widget.slkButtons[i].slk == i) {}
    }
    return Container(
      color: Colors.amber,
      child: Expanded(child: Column(children: rows)),
    );

    // return Container(
    //   child: Column(
    //     children: [
    //       for (int i = 0; i < widget.slkButtons.length; i += 2)
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             widget.slkButtons[i],
    //             const Spacer(),
    //             widget.slkButtons[i + 1],
    //           ],
    //         )
    //     ],
    //   ),
    //   // TODO - Add Text Entry Box / Error Box here
    // );
  }
}
