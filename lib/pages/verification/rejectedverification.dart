import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RVerification extends StatefulWidget {
  final String data;
  const RVerification({super.key, required this.data});

  @override
  State<RVerification> createState() => _RVerificationState();
}

class _RVerificationState extends State<RVerification> {
  var idnumber = TextEditingController();
  void kycwebpage() async {
    String kycpageurl = 'https://kyc.flyance.co.ke/?data=${widget.data}';

    await launchUrl(Uri.parse(kycpageurl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Verification rejected. Please try again ",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: TextField(
                    controller: idnumber,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.phone),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      labelText: "Enter your id number",
                      labelStyle: Theme.of(context).textTheme.displaySmall,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: Colors.grey.withOpacity(0.4)), //<-- SEE HERE
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                        width: 1,
                        color: Colors.grey,
                      )),
                    ),
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: GestureDetector(
                onTap: () {
                  kycwebpage();
                },
                child: Container(
                  height: MediaQuery.of(context).size.height / 18,
                  width: MediaQuery.of(context).size.height / 2,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Verify',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
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
