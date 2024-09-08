import 'package:animate_do/animate_do.dart';
import 'package:banktest/model/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'dart:convert';

import 'package:quickalert/widgets/quickalert_dialog.dart';

class Withdraw extends StatefulWidget {
  const Withdraw({super.key});

  @override
  State<Withdraw> createState() => _TransferState();
}

class _TransferState extends State<Withdraw> {
  TextEditingController accountemail = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController mpesaphone = TextEditingController();
  TextEditingController mpesaamount = TextEditingController();
  bool isloading = false;
  final TextEditingController pin = TextEditingController();
  String? dropdownValue;
  String? valueText;
  var message = "";

  Future<void> _displayTextInputDialogwallet(
      BuildContext context, String amount) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFFDF8EE),
            title: Text(
              'Confirm withdrawing $dropdownValue $amount ',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            content: TextField(
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: pin,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                labelText: "Your Impalapay pin.",
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
                  ),
                ),
              ),
              keyboardType: TextInputType.numberWithOptions(),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height / 25,
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: Colors.red), // Add red border
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cancel,
                              color: Colors.red, // Set icon color to red
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.red, // Set text color to red
                                fontSize: 13,
                              ),
                            )
                          ],
                        ),
                      )),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      await checkPin();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height / 25,
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xFFF0B90A),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check,
                            color: Color(0xFF2D2D2D),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Confirm",
                            style: TextStyle(
                                color: Color(0xFF2D2D2D), fontSize: 13),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  Future<Map<String, dynamic>> checkPin() async {
    try {
      setState(() {
        isloading = true;
      });
      var box = Hive.box('myBox');
      var phone = box.get("phone");
      final data = {"phone": phone, "pin": pin.text};
      // Encode the JSON data
      final jsonPayload = json.encode(data);
      final url = Uri.parse(
          'https://www.sandbox.impalapay.com/api/?resource=user&action=verifyPin');
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
      pin.clear();
      if (responseData["error"] == false) {
        withdraw();
      } else {
        var message = "Pin error";
        var snackBar = SnackBar(
          content: Text(message),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          isloading = false;
        });
      }

      return responseData;
    } catch (e) {
      print(e);
      var message = "$e";
      var snackBar = SnackBar(
        content: Text(message),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> withdraw() async {
    try {
      var box = Hive.box('myBox');
      var phone = box.get("phone");

      final data = {
        "phone": phone,
        "amount": amount.text,
        "currencyCode": dropdownValue
      };
      // Encode the JSON data
      final jsonPayload = json.encode(data);
      final url = Uri.parse(
          'https://www.sandbox.impalapay.com/api/?resource=transaction&action=withdraw');
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
      var commandStatus = responseData["error"];
      if (commandStatus == false) {
        message = "Withdrawal successful";
        QuickAlert.show(
          backgroundColor: const Color(0xFFFDF8EE),
          confirmBtnColor: LightColor.black,
          context: context,
          type: QuickAlertType.success,
          text: "Withdrawal successful",
        );
      } else {
        message = responseData["message"];
        QuickAlert.show(
          backgroundColor: const Color(0xFFFDF8EE),
          confirmBtnColor: LightColor.black,
          context: context,
          type: QuickAlertType.error,
          text: message,
        );
      }

      return responseData;
    } catch (e) {
      print(e);
      message = "$e";
      throw "$e";
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(),
        title: const Text(
          "Withdraw To Mobile Money",
        ),
      ),
      body: _withdraw(),
    );
  }

  Widget _withdraw() {
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
          child: FadeInLeft(
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
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
                          controller: amount,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.money,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            labelText: "amount",
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
                    height: 5.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      _displayTextInputDialogwallet(context, amount.text);
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 1,
                      decoration: const BoxDecoration(
                          color: const Color(0xFFD9B504),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: isloading
                          ? const Center(
                              child: SpinKitThreeBounce(
                                color: Color(0xFF2D2D2D),
                                size: 25,
                              ),
                            )
                          : const Center(
                              child: Text(
                                "Withdraw",
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
