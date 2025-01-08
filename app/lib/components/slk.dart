// This component to be used as one select key. There should be 6 of these per page.
import 'package:flutter/material.dart';

class Slk extends StatefulWidget {
  final Widget? leftKey;
  final Widget? rightKey;
  final int slk;

  const Slk(
      {super.key, this.slk = 1, required this.leftKey, required this.rightKey});

  @override
  State<Slk> createState() => _SlkState();
}

class _SlkState extends State<Slk> {
  @override
  Widget build(BuildContext context) {
    // If Both
    if (widget.leftKey != null && widget.rightKey != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.leftKey ?? const SizedBox.shrink(),
          widget.rightKey ?? const SizedBox.shrink(),
        ],
      );
    }

    // If Left
    if (widget.leftKey != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: widget.leftKey,
          ),
        ],
      );
    }

    // If Right
    if (widget.rightKey != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            child: widget.rightKey,
          ),
        ],
      );
    }
    return const Text("Failed to load select key");
  }
}
