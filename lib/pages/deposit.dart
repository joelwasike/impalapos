import 'package:animate_do/animate_do.dart';
import 'package:banktest/model/color.dart';
import 'package:banktest/pages/homemain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class Deposit extends StatefulWidget {
  final String? currency;
  const Deposit({super.key, required this.currency});

  @override
  State<Deposit> createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
  TextEditingController amount = TextEditingController();
  TextEditingController amount1 = TextEditingController();

  bool isloading = false;
  String? dropdownValue;
  var inputamount = TextEditingController();
  var payerPhone = TextEditingController();
  var inputamountcard = TextEditingController();

  var jsonurl;
  bool isLoading1 = false;

  bool isLoading = false;

  Future<Map<String, dynamic>> deposit() async {
    try {
      setState(() {
        isLoading = true;
      });
      var box = Hive.box('myBox');
      var phone = box.get("phone");

      final data = {
        "phone": phone,
        "amount": amount.text,
        "currency": "KES",
        "sourceOfFunds": "2",
        "payerPhone": payerPhone.text,
      };
      // Encode the JSON data
      final jsonPayload = json.encode(data);
      final url = Uri.parse(
          'https://www.sandbox.impalapay.com/api/?resource=transaction&action=deposit');
      // Define the HTTP request headers
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer NWNlYjJmNTEzYzMyZTcxMGZmYmIxZDEyNTYxNjc5MTY="
      };
      // Send the HTTP POST request with the JSON payload
      final response =
          await http.post(url, headers: headers, body: jsonPayload);
      // Decode the response JSON
      final responseData = json.decode(response.body);
      print(responseData);
      return responseData;
    } catch (e) {
      print(e);
      throw "$e";
    } finally {
      setState(() {
        isLoading = false;
        QuickAlert.show(
          onConfirmBtnTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Homemain();
            }));
          },
          backgroundColor: const Color(0xFFFDF8EE),
          confirmBtnColor: LightColor.black,
          context: context,
          type: QuickAlertType.info,
          text: 'Put your pin on the m-pesa pop-up. ',
        );
        amount.clear();
        payerPhone.clear();
      });
    }
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(jsonurl)) {
      throw Exception('Could not launch $jsonurl');
    }
  }

  Future<Map<String, dynamic>> depositfromcard() async {
    try {
      setState(() {
        isLoading1 = true;
      });
      var box = Hive.box('myBox');
      var phone = box.get("phone");

      final data = {
        "phone": phone,
        "amount": amount1.text,
        "currency": dropdownValue,
        "sourceOfFunds": "1",
      };
      // Encode the JSON data
      final jsonPayload = json.encode(data);
      final url = Uri.parse(
          'https://www.sandbox.impalapay.com/api/?resource=transaction&action=deposit');
      // Define the HTTP request headers
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer NWNlYjJmNTEzYzMyZTcxMGZmYmIxZDEyNTYxNjc5MTY="
      };
      // Send the HTTP POST request with the JSON payload
      final response =
          await http.post(url, headers: headers, body: jsonPayload);
      // Decode the response JSON
      final responseData = json.decode(response.body);
      var linkbody = responseData["message"];
      List<String> parts = linkbody.split(' ');
      String link = parts.last;
      final Uri jsourl = Uri.parse(link);
      launchUrl(jsourl);
      print(link);
      return responseData;
    } catch (e) {
      print(e);
      throw "$e";
    } finally {
      setState(() {
        isLoading1 = false;
        QuickAlert.show(
          backgroundColor: const Color(0xFFFDF8EE),
          confirmBtnColor: LightColor.black,
          context: context,
          type: QuickAlertType.info,
          text: 'Redirecting',
        );
        amount.clear();
      });
    }
  }

  @override
  void dispose() {
    inputamount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: _mpesa()
    );
  }

  Widget _mpesa() {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(15.0),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20)),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.lock,
                    color: Color(0xFFCDA73B),
                  ),
                  Text(
                    "  Your Transaction is protected.",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
                  ),
                  Text(
                    "  Learn more.",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                        decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
          ),
        ),
        Center(
          child: FadeInUp(
            child: Container(
              padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
              child: Column(
                children: <Widget>[
                  const Text(
                    "",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        decoration: TextDecoration.underline),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 6, vertical: 16),
                  //   child: DropdownButtonFormField<String>(
                  //     decoration: InputDecoration(
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //     ),
                  //     hint: Text(
                  //       'Select currency',
                  //       style: Theme.of(context).textTheme.displaySmall,
                  //     ),
                  //     dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                  //     value: dropdownValue,
                  //     onChanged: (String? newValue) {
                  //       setState(() {
                  //         dropdownValue = newValue!;
                  //       });
                  //     },
                  //     items: <String>["EUR", "GBP", "USD", "KES", "UGX", "TZS"]
                  //         .map<DropdownMenuItem<String>>((String value) {
                  //       return DropdownMenuItem<String>(
                  //         value: value,
                  //         child: Text(value),
                  //       );
                  //     }).toList(),
                  //   ),
                  // ),
                  SizedBox(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: TextField(
                          controller: amount,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.money,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            labelText: "Amount.",
                            labelStyle:
                                Theme.of(context).textTheme.displaySmall,
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
                              ),
                            ),
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 5.0,
                  ),
                  SizedBox(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: TextField(
                          controller: payerPhone,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.phone,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              labelText: "Source phone no.",
                              labelStyle:
                                  Theme.of(context).textTheme.displaySmall,
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
                                ),
                              )),
                        ),
                      )),
                  const SizedBox(
                    height: 5.0,
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (payerPhone.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a phone number'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        deposit();
                      }
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 1,
                      decoration: const BoxDecoration(
                        color: Color(0xFFCDA73B),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: isLoading
                          ? const Center(
                              child: SpinKitThreeBounce(
                                color: Colors.black,
                                size: 25,
                              ),
                            )
                          : const Center(
                              child: Text(
                                "Deposit",
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _card() {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(15.0),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20)),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.lock,
                    color: Color(0xFFCDA73B),
                  ),
                  Text(
                    "  Your Transaction is protected.",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
                  ),
                  Text(
                    "  Learn more.",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                        decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
          ),
        ),
        Center(
          child: FadeInUp(
            child: Container(
              padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
              child: Column(
                children: <Widget>[
                  const Text(
                    "",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        decoration: TextDecoration.underline),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 16),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      hint: Text(
                        'Select currency',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                      value: dropdownValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>["EUR", "GBP", "USD", "KES", "UGX", "TZS"]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: TextField(
                          controller: amount1,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.money,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            labelText: "Amount.",
                            labelStyle:
                                Theme.of(context).textTheme.displaySmall,
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
                    height: 5.0,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      depositfromcard();
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 1,
                      decoration: const BoxDecoration(
                          color: const Color(0xFFCDA73B),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: isLoading1
                          ? const Center(
                              child: SpinKitThreeBounce(
                                color: Colors.black,
                                size: 25,
                              ),
                            )
                          : const Center(
                              child: Text(
                                "Deposit",
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
