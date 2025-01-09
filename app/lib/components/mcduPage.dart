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
  @override
  Widget build(BuildContext context) {
    // Step 1 Sort the select keys
    widget.slkButtons.sort((a, b) => a.slk.compareTo(b.slk));
    // Step 2, loop through each slk, check its value and compare it to the loop. It should be equal. If it isn't insert an empty slk
    for (var i = 1; i < 6; i++) {
      if (widget.slkButtons.length < i) {
        // Do nothing, there's no point rendering a select key when there would be nothing below it
      } else if (widget.slkButtons[i - 1].slk != i) {
        widget.slkButtons.insert(i - 1,
            const Slk(leftKey: null, rightKey: null)); // Insert an empty slk
      }
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [...widget.slkButtons],
      ),
    );
  }
}
