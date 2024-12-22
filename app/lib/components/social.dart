import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Uri url;

  const SocialCard(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.url});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: const Icon(Icons.abc_outlined),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: () async {
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          } else {
            throw 'Could not launch $url'; //  #FIXME - alert dialog
          }
        });
  }
}
