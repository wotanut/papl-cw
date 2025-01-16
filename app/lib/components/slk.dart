// This component to be used as one select key. There should be 6 of these per page.
import 'package:flutter/material.dart';

class Slk extends StatelessWidget {
  final Widget? leftKey;
  final Widget? rightKey;
  final int slk;

  const Slk(
      {super.key, this.slk = 1, required this.leftKey, required this.rightKey});

  @override
  Widget build(BuildContext context) {
    // If Both
    if (leftKey != null && rightKey != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height / 8,
            child: leftKey ?? const SizedBox.shrink(),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height / 8,
            child: rightKey ?? const SizedBox.shrink(),
          ),
        ],
      );
    }

    // If Left
    if (leftKey != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height /
                8, // While only 6 select keys, it's a division by 8 to take into account for thins like the title, the scratchpad, the safe area etc..
            child: leftKey,
          ),
        ],
      );
    }

    // If Right
    if (rightKey != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height / 8,
            child: rightKey,
          ),
        ],
      );
    }

    // If Neither
    return Row(
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height / 8,
        ),
      ],
    );
  }
}
