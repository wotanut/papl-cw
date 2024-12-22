import 'package:app/components/Social.dart';
import 'package:flutter/material.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  final borderRadius = BorderRadius.circular(200); // Image border

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          centerTitle: true, // For anroid, defualt on iOS
          // FIXME: make button to push on DDU
          actions: const [Icon(Icons.arrow_circle_up_sharp)],
          title: const Text(
            "About",
          ),
        ),
        body: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8), // Border width
                  decoration: BoxDecoration(
                      color: Colors.red, borderRadius: borderRadius),
                  child: ClipRRect(
                    borderRadius: borderRadius,
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(100), // Image radius
                      child: Image.asset(
                        'assets/images/me.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const Flexible(
                    child: Text(
                        "Hi, i'm Sam, a second year Computer Science student at the University of Portsmouth.")),
              ],
            ),
            const Divider(),
            // const Text(
            //     "I decided to make this project as a challenge to myself for a few reasons:"),
            // Expanded(
            //     child: ListView(
            //   children: const [
            //     Text("- To test my understanding of the A320 MCDU"),
            //     Text(
            //         "- To learn more about the TELEX protocol and why it is used over CPDLC"),
            //     Text("- I found the original coursework too easy"),
            //   ],
            // )),
            // const Divider(),
            Card(
                child: SocialCard(
              svg: 'assets/images/PajamasGithub.svg',
              title: 'GitHub',
              subtitle: "@wotanut",
              url: Uri.https("sambot.dev", '/github'),
            )),
            Card(
                child: SocialCard(
              svg: 'assets/images/LogosLinkedinIcon.svg',
              title: 'GitHub',
              subtitle: "@wotanut",
              url: Uri.https("sambot.dev", '/github'),
            )),
          ],
        ));
  }
}
