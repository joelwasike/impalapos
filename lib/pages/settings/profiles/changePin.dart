import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Changeemail extends StatefulWidget {
  const Changeemail({super.key});

  @override
  State<Changeemail> createState() => _ChangeemailState();
}

class _ChangeemailState extends State<Changeemail> {
  var otp = TextEditingController();
  var newpinconfirm = TextEditingController();
  bool isLoading = false;
  var message = "";
  String? valueText;
  final TextEditingController pin = TextEditingController();
  bool obscureText = false;

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter your pin'),
            content: TextField(
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: pin,
              decoration: const InputDecoration(hintText: "Your Impalapay pin"),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    color: Colors.red,
                    textColor: Colors.white,
                    child: const Text('CANCEL'),
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                  ),
                  MaterialButton(
                    color: const Color(0xFF020087),
                    textColor: Colors.white,
                    child: const Text('Confirm'),
                    onPressed: () {
                      checkPin();
                      Navigator.pop(context);
                    },
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
        isLoading = true;
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
      if (responseData["error"] == false) {
        chnagepass();
      } else {
        var message = "Pin error";
        var snackBar = SnackBar(
          content: Text(message),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  Future<Map<String, dynamic>> chnagepass() async {
    try {
      var box = Hive.box('myBox');
      var phone = box.get("phone");

      final data = {
        "phone": phone,
        "pin": otp.text,
      };
      // Encode the JSON data
      final jsonPayload = json.encode(data);
      final url = Uri.parse(
          'https://www.sandbox.impalapay.com/api/?resource=user&action=update');
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
      var messeger = responseData["message"];
      if (messeger == "success") {
        message = "Pin changed successfully";
      } else {
        message = "An error occured";
      }

      return responseData;
    } catch (e) {
      print(e);
      throw "$e";
    } finally {
      setState(() {
        isLoading = false;
        var snackBar = SnackBar(
          content: Text(message),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Impalapay pin"),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(15.0),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: TextField(
                          controller: otp,
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
                            prefixIcon: const Icon(
                              Icons.lock,
                            ),
                            labelText: "new pin.",
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
                  SizedBox(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: TextField(
                          controller: newpinconfirm,
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
                            prefixIcon: const Icon(
                              Icons.lock,
                            ),
                            labelText: "confirm new pin.",
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
                    height: 15.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      _displayTextInputDialog(context);
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 1,
                      decoration: const BoxDecoration(
                          color: const Color(0xFFD9B504),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: isLoading
                          ? const SpinKitThreeBounce(
                              color: Colors.white,
                              size: 25,
                            )
                          : const Center(
                              child: Text(
                                "Change pin",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Color(0xFFFDF8EE),
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 70.0,
            ),
          ],
        ),
      ),
    );
  }
}
