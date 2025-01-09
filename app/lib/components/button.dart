import 'package:flutter/material.dart';

class mcduEntryBTN extends StatefulWidget {
  final bool isRightSide;
  final String title;
  final Widget? nextPage;
  final Widget? previousPage;

  const mcduEntryBTN(
      {super.key,
      this.isRightSide = false,
      required this.title,
      this.nextPage,
      this.previousPage});

  @override
  State<mcduEntryBTN> createState() => _mcduEntryBTNState();
}

class _mcduEntryBTNState extends State<mcduEntryBTN> {
  @override
  Widget build(BuildContext context) {
    bool isDisabled = false;
    VoidCallback callback = () {};
    var actualTitle = widget.title;

    if (widget.isRightSide) {
      actualTitle = "${widget.title} >";
    } else {
      actualTitle = "< ${widget.title}";
    }

    if (widget.nextPage == null && widget.previousPage == null) {
      isDisabled = true;
    } else if (widget.nextPage != null) {
      callback = () => {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => widget.nextPage!))
          };
    } else if (widget.previousPage != null) {
      callback = () => {
            Navigator.pop(
              context,
            )
          };
    }

    return TextButton(
      onPressed: callback,
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (isDisabled) {
              return Colors.grey.shade700;
            }
            return Colors.grey.shade100;
          },
        ),
      ),
      child: Text(actualTitle),
    );
  }
}
