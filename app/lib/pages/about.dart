import 'package:app/components/Social.dart';
import 'package:flutter/material.dart';

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
          // FIXME: make button to push on DDU
          actions: const [Icon(Icons.arrow_circle_up_sharp)],
          title: const Text(
            "About",
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(5), // Border width
                      decoration: BoxDecoration(
                          color: Colors.blueAccent, borderRadius: borderRadius),
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
              // const Text(
              //     "I decided to make this project as a challenge to myself for a few reasons:"),
              // const ListTile(
              //     title: Text("To test my understanding of the A320 MCDU")),
              // const Text(
              //     "- To learn more about the TELEX protocol and why it is used over CPDLC"),
              // const Text("- I found the original coursework too easy"),
              // const Divider(),
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
                svg: 'assets/images/svg/web.svg',
                title: 'Website',
                subtitle: "sambot.dev",
                url: Uri.https("sambot.dev", '/'),
              )),
            ],
          ),
        ));
  }
}
