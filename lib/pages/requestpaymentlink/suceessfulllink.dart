import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class SuccessfulLink extends StatefulWidget {
  final String link;
  const SuccessfulLink({Key? key, required this.link}) : super(key: key);

  @override
  State<SuccessfulLink> createState() => _SuccessfulLinkState();
}

class _SuccessfulLinkState extends State<SuccessfulLink> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Share Payment link"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 60,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)),
              child: QrImageView(
                padding: EdgeInsets.all(12),
                embeddedImage: AssetImage("images/impala-removebg-preview.png"),
                data: widget.link,
                version: QrVersions.auto,
                size: 300.0,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Others can scan to pay you.",
                style: TextStyle(fontSize: 15),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "OR",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await Share.share(widget.link);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 1,
                  decoration: const BoxDecoration(
                      color: const Color(0xFFD9B504),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: const Center(
                    child: Text(
                      "Share Payment Link",
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
