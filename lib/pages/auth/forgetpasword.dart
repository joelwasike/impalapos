import 'package:banktest/model/color.dart';
import 'package:banktest/pages/auth/loginScreen.dart';
import 'package:banktest/pages/settings/profiles/help.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Changepassst extends StatefulWidget {
  const Changepassst({super.key});

  @override
  State<Changepassst> createState() => _ChangepasssState();
}

class _ChangepasssState extends State<Changepassst> {
  bool isLoading = false;
  String? message = "";
  TextEditingController phone = TextEditingController();

  Future<void> chnagepass() async {
    final body = {
      "userId": "+${phone.text}",
    };

    try {
      setState(() {
        isLoading = true;
      });

      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer NWNlYjJmNTEzYzMyZTcxMGZmYmIxZDEyNTYxNjc5MTY="
      };

      final Uri url = Uri.parse(
          'https://www.sandbox.impalapay.com/api/?resource=password&action=forgot');

      final response =
          await http.post(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final Map data = jsonDecode(response.body);
        print("This is the data $data");
        var messeger = data["error"];
        if (messeger == false) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "Password changed successfully. Check your text message for password.")),
          );
          //go to login
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const LoginPage();
          }));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("An error occured")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("An error occured.")),
        );
      }
    } catch (error) {
      print(error);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<Map<String, dynamic>> chnagepas() async {
    try {
      setState(() {
        isLoading = true;
      });

      final data = {
        "userId": "+${phone.text}",
      };
      // Encode the JSON data
      final jsonPayload = json.encode(data);
      final url = Uri.parse(
          'https://www.sandbox.impalapay.com/api/?resource=password&action=forgot');
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
      var messeger = responseData["error"];
      if (messeger == false) {
        setState(() {
          message =
              "Password changed successfully. Check your text message for password";
        });
        var snackBar = const SnackBar(
          content:
              Text("Log in and go to your Profle Page to change the password"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        setState(() {
          var messeger = responseData["true"];
          message = messeger;
        });
      }

      return responseData;
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      setState(() {
        isLoading = false;
      });
      var snackBar = SnackBar(
        content: Text(message!),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          padding: EdgeInsets.all(10.0),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              'Password Recovery',
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
              'Enter your phone number',
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
                  controller: phone,
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.phone),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    labelText: "Phone number 254....",
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
                chnagepass();
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
                          'Get Password',
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
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Back to ',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return const LoginPage();
                })),
                child: const Text(
                  'Login page',
                  style: TextStyle(
                      color: LightColor.navyBlue2,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
