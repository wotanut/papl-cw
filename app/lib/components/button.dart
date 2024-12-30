import 'package:flutter/material.dart';

class mcduEntryBTN extends StatefulWidget {
  final int slk; // slk = Select Key
  final bool isRightSide;
  final String title;
  final VoidCallback callback;
  final bool isDisabled;
  // FIXME- Add link to page

  const mcduEntryBTN(
      {super.key,
      this.slk = 1,
      this.isRightSide = false,
      this.title = "Test",
      this.isDisabled = false,
      required this.callback});

  @override
  State<mcduEntryBTN> createState() => _mcduEntryBTNState();
}

class _mcduEntryBTNState extends State<mcduEntryBTN> {
  @override
  Widget build(BuildContext context) {
    var actualTitle = widget.title;
    if (widget.isRightSide) {
      actualTitle = "${widget.title} >";
    } else {
      actualTitle = "< ${widget.title}";
    }

    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.cyan)),
        child: TextButton(
          onPressed: widget.callback,
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (widget.isDisabled) {
                  return Colors.grey.shade700;
                }
                return Colors.grey.shade100;
              },
            ),
          ),
          child: Text(actualTitle),
        ));
  }
}
