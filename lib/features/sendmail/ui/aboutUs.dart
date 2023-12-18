import 'package:flutter/material.dart';
import 'package:mail_sender/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  // Replace these URLs with your actual social media profile links
  final Map<String, String> socialMediaLinks = {
    'Facebook': 'https://www.facebook.com/adzoneweb20',
    // 'Twitter': 'https://www.twitter.com/your_page',
    'Instagram': 'https://www.instagram.com/adzoneweb',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        backgroundColor: kPrimaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Our App!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'We are Fastest Growing Digital Marketing Company',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            Text(
              'Follow us on social media:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: socialMediaLinks.entries
                  .map((entry) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: SocialMediaLinkButton(
                          title: entry.key,
                          link: entry.value,
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class SocialMediaLinkButton extends StatelessWidget {
  final String title;
  final String link;

  SocialMediaLinkButton({required this.title, required this.link});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
      onPressed: () async {
        if (await canLaunch(link)) {
          await launchUrl(Uri.parse(link),
              mode: LaunchMode.externalApplication);
        } else {
          // Handle if the link cannot be launched
        }
      },
      child: Text(title),
    );
  }
}
