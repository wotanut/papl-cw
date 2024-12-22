import 'package:app/button.dart';
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
    // NOTE - Can't use for each because need to jump up by two each time
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (widget.slkButtons.length < 2)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.slkButtons[0],
              ],
            )
          else
            for (int i = 0; i < widget.slkButtons.length; i += 2)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.slkButtons[i],
                  widget.slkButtons[i + 1],
                ],
              )
        ],
      ),
    );
  }
}
