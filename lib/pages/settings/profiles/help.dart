import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  final Uri urlwebsite = Uri.parse('https://impalapay.network/');
  var urlfacebook = Uri.parse('https://web.facebook.com/impalapay.kenya/');

  void sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'info@impalapay.com',
      queryParameters: {
        'subject': '',
        'body': '',
      },
    );

    await launchUrl(Uri.parse(emailUri.toString()));
  }

  void _launchEmail() async {
    const String email = 'info@impalapay.com';
    const String subject = 'Impala help';
    const String body = '';

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    if (Platform.isAndroid) {
      await launchUrl(Uri.parse(emailLaunchUri.toString()));
    } else if (Platform.isIOS) {
      // Use iOS-specific method to launch the email app
      // For iOS, you can use the same url_launcher package but with a different scheme
      final Uri emailLaunchUriIOS = Uri(
        scheme: 'message',
        path: email,
        queryParameters: {
          'subject': subject,
          'body': body,
        },
      );

      await launchUrl(Uri.parse(emailLaunchUriIOS.toString()));
    } else {
      // Platform not supported (e.g., running on web or another platform)
      throw 'Platform not supported';
    }
  }

  void visitFacebookPage() async {
    const String facebookPageUrl = 'https://www.facebook.com/impalapay.kenya';

    await launchUrl(Uri.parse(facebookPageUrl));
  }

  Future openwhatsapp() async {
    var whatsappUrl = "whatsapp://send?phone=+254103102336&text=impalapay";
    var whatsappUrlIos =
        Uri.parse("https://wa.me/+254103102336?text=impalapay");
    if (Platform.isIOS) {
      launchUrl(whatsappUrlIos);
    } else {
      launchUrl(Uri.parse(whatsappUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
      ),
      body: Column(
        children: [
          Container(
            child: Expanded(
                child: ListView(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Card(
                  shadowColor: Colors.grey,
                  margin:
                      const EdgeInsets.only(left: 35, right: 35, bottom: 10),
                  color: const Color(0xFFFDF8EE),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    onTap: () {
                      _launchEmail();
                    },
                    leading: const Icon(
                      Icons.email,
                      color: Color(0xFF020087),
                    ),
                    title: const Text(
                      'Email the support team',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Color(0xFF020087),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  shadowColor: Colors.grey,
                  margin:
                      const EdgeInsets.only(left: 35, right: 35, bottom: 10),
                  color: const Color(0xFFFDF8EE),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    onTap: () {
                      openwhatsapp();
                    },
                    leading: const Icon(
                      Icons.chat,
                      color: Color(0xFF020087),
                    ),
                    title: const Text(
                      'Chat on Whatsapp',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Color(0xFF020087),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  shadowColor: Colors.grey,
                  margin:
                      const EdgeInsets.only(left: 35, right: 35, bottom: 10),
                  color: const Color(0xFFFDF8EE),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    onTap: () => visitFacebookPage(),
                    leading: const Icon(
                      Icons.facebook,
                      color: Color(0xFF020087),
                    ),
                    title: const Text(
                      'Visit our Facebook Page',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Color(0xFF020087),
                    ),
                  ),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
