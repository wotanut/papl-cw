import 'package:app/components/button.dart';
import 'package:app/components/social.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';

import '../globals.dart' as globals;

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  final borderRadius = BorderRadius.circular(40); // Image border
  final int age = DateTime.now().year - 2005;

  @override
  void initState() {
    super.initState();
  }

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
        actions: const [Icon(Icons.arrow_circle_up_sharp)],
        title: const Text(
          "About",
        ),
        automaticallyImplyLeading: false, // REMOVES THE BACK BAR
        // did this for consistency with the rest of the mcdu
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(5), // Border width
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: borderRadius),
                        child: ClipRRect(
                          borderRadius: borderRadius,
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(50), // Image radius
                            child: Image.asset(
                              'assets/images/me.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                        child: Text.rich(TextSpan(children: [
                      TextSpan(
                          text:
                              "Hi, i'm Sam, a $age year old, second year Computer Science student at the "),
                      const TextSpan(
                          text: "University of Portsmouth",
                          style: TextStyle(
                              backgroundColor: Color.fromARGB(255, 60, 2, 60))),
                      const TextSpan(text: ".") // This is annoying
                    ]))),
                  ],
                ),
                const Divider(),
                const Text(
                  "Notes",
                  style: TextStyle(fontSize: 25),
                ),
                const Text.rich(TextSpan(children: [
                  TextSpan(
                      text:
                          "This app does NOT hold your hand. You are expected to understand how to use the MCDU on the A320. There is a scratchpad at the bottom of all pages that required text inputs. You should click this first, enter your data, press submit, and then tap the area you want to insert your data to, as if you had select keys (slk) on the side of your device. "),
                ])),
                const Divider(),
                const Text(
                  "Socials",
                  style: TextStyle(fontSize: 25),
                ),
                Card(
                    child: SocialCard(
                  svg: 'assets/images/svg/GitHub.svg',
                  title: 'GitHub',
                  subtitle: "@wotanut",
                  url: Uri.https("sambot.dev", '/github'),
                )),
                Card(
                    child: SocialCard(
                  svg: 'assets/images/svg/LinkedIn.svg',
                  title: 'LinkedIn',
                  subtitle: "Sam Blewitt",
                  url: Uri.https("linkedin.com", '/in/sam-blewitt'),
                )),
                Card(
                    child: SocialCard(
                  whiteIcon: true,
                  svg: 'assets/images/svg/web.svg',
                  title: 'Website',
                  subtitle: "sambot.dev",
                  url: Uri.https("sambot.dev", '/'),
                )),
                // const Flexible(
                //   // alignment: Alignment.bottomLeft,
                //   child: Padding(
                //     padding: EdgeInsets.all(8.0),
                //     // child: MCDUEntryBTN(
                //     //   title: "Back",
                //     //   previousPage: MyApp(),
                //     // ),
                //   ),
                // ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MCDUEntryBTN(
                      title: "Back",
                      previousPage: MyApp(),
                    ),
                  ],
                ),
                Text(globals.appVersion),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
