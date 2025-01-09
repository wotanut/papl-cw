import 'package:app/components/slk.dart';
import 'package:flutter/material.dart';

// NOTE - This is used as a template for 99% of pages, not all of them though. Such as the about page, pages with text input or pages that don't conform to the standard page

class Mcdupage extends StatefulWidget {
  final List<Slk> slkButtons;

  const Mcdupage({super.key, required this.slkButtons});

  @override
  State<Mcdupage> createState() => _McdupageState();
}

class _McdupageState extends State<Mcdupage> {
  late List<Slk> sortedSLK;

  @override
  void initState() {
    super.initState();
    sortedSLK = List<Slk>.from(widget
        .slkButtons); // Creates an exact copy so that the whole page can be const
    // Step 1 Sort the select keys
    sortedSLK.sort((a, b) => a.slk.compareTo(b.slk));
    _fill();
  }

  void _fill() {
    // Step 2, loop through each slk, check its value and compare it to the loop. It should be equal. If it isn't insert an empty slk
    for (var i = 1; i < 6; i++) {
      if (sortedSLK.length < i) {
        // Do nothing, there's no point rendering a select key when there would be nothing below it
      } else if (sortedSLK[i - 1].slk != i) {
        sortedSLK.insert(i - 1,
            const Slk(leftKey: null, rightKey: null)); // Insert an empty slk
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [...widget.slkButtons],
      ),
    );
  }
}
