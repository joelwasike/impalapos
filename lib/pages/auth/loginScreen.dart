import 'dart:async';

import 'package:banktest/model/color.dart';
import 'package:banktest/pages/auth/forgetpasword.dart';
import 'package:banktest/pages/auth/regScreen.dart';
import 'package:banktest/pages/homemain.dart';
import 'package:banktest/pages/settings/profiles/help.dart';
import 'package:banktest/pages/verification/verificationpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive_flutter/adapters.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  bool isLoading = false;
  var message;
  var kycmessage;
  bool obscureText = true;
  var token = "";

  _launchURLApp(link) async {
    var url = Uri.parse(link);
    if (await canLaunchUrl(url)) {
      // ignore: deprecated_member_use
      await launch(url.toString(), forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  void kycwebpage(link) async {
    await launchUrl(Uri.parse(link));
  }

  Future getkeys(String phone) async {
    Map<String, dynamic> body = {
      "phone": phone,
    };
    Map<String, String> head = {
      "Content-Type": "application/json",
    };
    var url = Uri.parse('https://anchor.nanesoft-lab.com/anchor/getkeys/');
    var responsee = await http.post(url, headers: head, body: jsonEncode(body));
    if (responsee.statusCode == 200) {
      Map data = jsonDecode(responsee.body);
      print(data);
      var publickey = data["Wallet Address"];
      var seckey = data["Wallet Signer"];
      var box = await Hive.box('myBox');
      box.put('publickey', publickey);
      box.put('secretkey', seckey);
    } else {
      var box = await Hive.box('myBox');
      box.put('publickey', "null");
      box.put('secretkey', "null");
    }
  }

  Future signIn() async {
    Map<String, dynamic> body = {
      "email": emailcontroller.text,
      "password": passwordcontroller.text,
    };

    try {
      setState(() {
        isLoading = true;
      });
      Map<String, String> head = {
        "Content-Type": "application/json",
        "Authorization": "Bearer NWNlYjJmNTEzYzMyZTcxMGZmYmIxZDEyNTYxNjc5MTY="
      };

      var url = Uri.parse(
          'https://www.sandbox.impalapay.com/api/?resource=user&action=login');
      var responsee =
          await http.post(url, headers: head, body: jsonEncode(body));
      Map data = jsonDecode(responsee.body);
      setState(() {
        message = data["message"];
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));

      if (data["error"] == false) {
        var phone = data["data"]["phone"];
        var referral = data["data"]["referralCodeMine"];
        var names = data["data"]["name"];
        var useremail = data["data"]["email"];
        var body2 = {"phone": phone};
        var phoneno = data["data"]["phone"];
        print(phoneno);
        if (phoneno.startsWith('+')) {
          setState(() {
            phoneno = phoneno.substring(1);
          });
        }
        print(phoneno);
        print(referral);

        print(data["data"]["phone"]);
        //check stellar account
        await getkeys(phone);
        //navigate to next page
        var box = await Hive.box('myBox');
        box.put('phone', phone);
        box.put('names', names);
        box.put('email', useremail);
        box.put('referral', referral);

        print(phone);
        print('Response status: ${responsee.statusCode}');
        print('Response body: ${responsee.body}');
        //check kyc
        var kyclink =
            "https://rates-exchange.nanesoft-lab.com/chek/kyc-status/?phone=$phone";
        var jsonResponse = await http.get(Uri.parse(kyclink));
        var kycbody = jsonDecode(jsonResponse.body);
        var actions = kycbody['Actions'];
        print(kycbody);
        print(actions);
        if (actions == null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const Verification(
                data:
                    "https://links.usesmileid.com/6482/1667ecc2-02d9-422b-b7a3-a833709e8e22");
            // return Verification(data: data["url"]);
          }));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const Homemain();
          }));
          // ignore: use_build_context_synchronously
        }
      }
    } catch (e) {
      print(e);
      setState(() {
        message = "Check your internet connection";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        floatingActionButton: TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const Help();
            }));
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(LightColor.navyBlue1),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.headset_mic,
                  color: Color(0xFFFDF8EE),
                ),
                SizedBox(width: 8),
                Text(
                  'Customer Support',
                  style: TextStyle(
                    color: Color(0xFFFDF8EE),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                ),
                //Hello again
                const Center(
                  child: Text(
                    'Hello Again!',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: LightColor.navyBlue2),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Center(
                  child: Text(
                    'Welcome back, You\'ve been missed!',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        color: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextField(
                        controller: emailcontroller,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.email,
                            color: Colors.grey,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          labelText: "Enter Email.",
                          labelStyle: Theme.of(context).textTheme.displaySmall,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Colors.grey
                                    .withOpacity(0.4)), //<-- SEE HERE
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
                  height: 10,
                ),
                SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextField(
                        obscureText: obscureText,
                        controller: passwordcontroller,
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            child: Icon(
                              obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          labelText: "Enter password.",
                          labelStyle: Theme.of(context).textTheme.displaySmall,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Colors.grey
                                    .withOpacity(0.4)), //<-- SEE HERE
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
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const Changepassst();
                        })),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: LightColor.navyBlue2,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: GestureDetector(
                    onTap: () {
                      signIn();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height / 18,
                      width: MediaQuery.of(context).size.height / 2,
                      decoration: BoxDecoration(
                        color: LightColor.navyBlue2,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: isLoading
                          ? const SpinKitThreeBounce(
                              color: Colors.white,
                              size: 25,
                            )
                          : const Center(
                              child: Text(
                                'Log In',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),

                GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return const RegisterPage();
                  })),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Not a member? ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      GestureDetector(
                        child: const Text(
                          'Register now',
                          style: TextStyle(
                              color: LightColor.navyBlue2,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
