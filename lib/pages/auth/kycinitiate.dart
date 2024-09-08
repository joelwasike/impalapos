import 'package:banktest/pages/auth/regScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class KycInitiate extends StatefulWidget {
  const KycInitiate({Key? key}) : super(key: key);

  @override
  State<KycInitiate> createState() => _KycInitiateState();
}

class _KycInitiateState extends State<KycInitiate> {
  bool isloading1 = false;
  TextEditingController email = TextEditingController();

  Future login() async {
    setState(() {
      isloading1 = true;
    });
    var box = Hive.box("Box");
    var token = box.get("token");
    try {
      var url = Uri.parse("https://neobank.nanesoft-lab.com/initiate-kyc/");
      var data = {"id_number": email.text};
      String jsonData = json.encode(data);
      var headers = {
        "Content-Type": "application/json",
        'Authorization': 'Token $token',
      };

      // Send the POST request
      var response = await http.post(
        url,
        headers: headers,
        body: jsonData,
      );
      Map res = jsonDecode(response.body);

      // Check the response
      if (res["error"] == false) {
        var url = res["kyc_link"];
        var kycurl = Uri.parse(url);
        launchUrl(kycurl);
        print(res);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Please try again")));
        print("Request failed with status code: ${response.statusCode}");
        print(response.body); // Error message or response content
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isloading1 = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: SweepGradient(colors: [
                Color(0xFFe29f1d),
                Color(0xFF020087),
              ]),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Complete verification!',
                style: TextStyle(
                    fontSize: 30,
                    color: Color.fromARGB(255, 215, 208, 228),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0, left: 30, right: 30),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                color: Color.fromARGB(255, 215, 208, 228),
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: ListView(
                  children: [
                    TextField(
                      controller: email,
                      decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.check,
                            color: Colors.grey,
                          ),
                          label: Text(
                            'Enter your ID number',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF301077),
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    GestureDetector(
                      onTap: () {
                        login();
                      },
                      child: Container(
                        height: 55,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(colors: [
                            Color(0xFF020087),
                            Color(0xFF020087),
                          ]),
                        ),
                        child: isloading1
                            ? const SpinKitThreeBounce(
                                color: Colors.white,
                                size: 25,
                              )
                            : const Center(
                                child: Text(
                                  'Complete KYC Verification',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 150,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()));
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Don't have account?",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            Text(
                              "Sign up",
                              style: TextStyle(

                                  ///done login page
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  fontSize: 17,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
