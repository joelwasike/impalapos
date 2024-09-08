import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Verification extends StatefulWidget {
  final String data;
  const Verification({super.key, required this.data});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  var idnumber = TextEditingController();
  void kycwebpage(link) async {
    await launchUrl(Uri.parse(link));
  }

  Future postkyc() async {
    var box = Hive.box('myBox');
    var phone = box.get("phone");
    //check kyc
    var kyclink =
        "https://rates-exchange.nanesoft-lab.com/chek/kyc-status/?id_number=${idnumber.text}&phone=$phone";
    var jsonResponse = await http.get(Uri.parse(kyclink));
    var kycbody = jsonDecode(jsonResponse.body);
    var actions = kycbody['Actions'];
    print(kycbody);
    print(actions);
    print(phone);
    print(idnumber.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Please complete your Verification..  ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: idnumber,
                    decoration: InputDecoration(
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () async {
                  await postkyc();
                  await launchUrl(Uri.parse(widget.data));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height / 18,
                  width: MediaQuery.of(context).size.height / 2,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Verify",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        )
                      ],
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
