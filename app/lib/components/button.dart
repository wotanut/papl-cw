import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MCDUEntryBTN extends StatefulWidget {
  final bool isRightSide;
  final String title;
  final Widget? nextPage;
  final Widget? previousPage;
  final bool unTimed; // Used for buttons like save and exit in opts

  const MCDUEntryBTN(
      {super.key,
      this.unTimed = false,
      this.isRightSide = false,
      required this.title,
      this.nextPage,
      this.previousPage});

  @override
  State<MCDUEntryBTN> createState() => _MCDUEntryBTNState();
}

class _MCDUEntryBTNState extends State<MCDUEntryBTN> {
  bool realsiticTimings = false;
  late SharedPreferences? prefs;
  late var actualTitle = widget.title;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      if (widget.unTimed) {
        realsiticTimings = false;
      } else {
        realsiticTimings = prefs!.getBool('timings') ?? false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDisabled = false;
    VoidCallback callback = () {};

    if (widget.isRightSide) {
      actualTitle = "${widget.title} >";
    } else if (!widget.isRightSide && actualTitle != "< ATSU (SEL)") {
      actualTitle = "< ${widget.title}";
    }

    if (widget.nextPage == null && widget.previousPage == null) {
      isDisabled = true;
    } else if (widget.nextPage != null) {
      callback = () => {
            if (realsiticTimings)
              {
                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => widget.nextPage!),
                  );
                })
              }
            else
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => widget.nextPage!),
                )
              }
          };
    } else if (widget.previousPage != null) {
      callback = () => {
            Navigator.pop(
              context,
            )
          };
    }

    return TextButton(
      onPressed: () {
        if (widget.title == "ATSU") {
          setState(() {
            actualTitle = "< ATSU (SEL)";
            callback();
          });
        }
      },
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
