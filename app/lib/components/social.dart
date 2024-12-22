import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Uri url;
  final String svg;

  const SocialCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.url,
    required this.svg,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: SvgPicture.asset(
          svg,
          height: double.parse("40"),
          width: double.parse("40"),
          semanticsLabel: "$title-icon",
        ),
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
