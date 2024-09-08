import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Changepass extends StatefulWidget {
  const Changepass({super.key});

  @override
  State<Changepass> createState() => _ChangepassState();
}

class _ChangepassState extends State<Changepass> {
  var otp = TextEditingController();
  bool isLoading = false;
  var currentpass = TextEditingController();
  var newpass = TextEditingController();
  var newpass1 = TextEditingController();
  var message = "";
  bool obscureText = false;

  Future<Map<String, dynamic>> chnagepass() async {
    try {
      setState(() {
        isLoading = true;
      });
      var box = Hive.box('myBox');
      var phone = box.get("phone");

      final data = {
        "userId": phone,
        "inputPasswordCurrent": currentpass.text,
        "inputPassword": newpass.text,
        "inputPasswordConfirm": newpass1.text,
      };
      // Encode the JSON data
      final jsonPayload = json.encode(data);
      final url = Uri.parse(
          'https://www.sandbox.impalapay.com/api/?resource=password&action=change');
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
      if (messeger == "Success") {
        message = "Password changed successfully. Please log in";
        // Navigator.push(context, route);
      } else {
        message = messeger;
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
        title: const Text("Change Password"),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(15.0),
          children: <Widget>[
            FadeInLeft(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: TextField(
                            controller: currentpass,
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
                              prefixIcon: const Icon(
                                Icons.lock,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              labelText: "Current password.",
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
                    SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: TextField(
                            controller: newpass,
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
                              labelText: "New password.",
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
                            controller: newpass1,
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
                              labelText: "Confirm new password.",
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
                    MaterialButton(
                      onPressed: chnagepass,
                      height: 40.0,
                      color: Color(0xFF020087),
                      child: isLoading
                          ? const SpinKitThreeBounce(
                              color: Colors.white,
                              size: 25,
                            )
                          : const Text(
                              "Change password",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Color(0xFFFDF8EE),
                              ),
                            ),
                    )
                  ],
                ),
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
