import 'package:banktest/model/color.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChangeBaseCurrency extends StatefulWidget {
  const ChangeBaseCurrency({super.key});

  @override
  State<ChangeBaseCurrency> createState() => _ChangeBaseCurrencyState();
}

class _ChangeBaseCurrencyState extends State<ChangeBaseCurrency> {
  bool isLoading = false;
  List itemss = ["USD", "GBP", "EUR", "KES", "UGX", "TZS"];
  String? valueChose;
  var message;

  Future changeCurrency() async {
    try {
      setState(() {
        isLoading = true;
      });
      var box = Hive.box('myBox');
      var phone = box.get("phone");

      final data = {"phone": phone, "baseCurrency": valueChose};
      // Encode the JSON data
      final jsonPayload = json.encode(data);
      final url = Uri.parse(
          'https://www.sandbox.impalapay.com/api/?resource=balance&action=update');
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
      var error = responseData["error"];
      if (error == false) {
        message = "Changed successfully";
      } else {
        message = "Error changing currency";
      }
      return responseData;
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      setState(() {
        isLoading = false;
        var snackBar = SnackBar(
          content: Text(message.toString()),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "Change base currency",
      )),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(15.0),
          children: <Widget>[
            Center(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    const Text(
                      "Select your desired base currency",
                      style: TextStyle(
                          color: LightColor.navyBlue2,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          decoration: TextDecoration.underline),
                    ),
                    SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFDF8EE),
                        ),
                        child: DropdownButton(
                          underline: Container(),
                          isExpanded: true,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: LightColor.navyBlue2,
                          ),
                          iconSize: 36,
                          dropdownColor: LightColor.background,
                          hint: const Text(
                            'Currencies',
                            style: TextStyle(
                                color: LightColor.navyBlue2,
                                fontWeight: FontWeight.w500),
                          ),
                          value: valueChose,
                          onChanged: (value) {
                            setState(() {
                              valueChose = value.toString();
                            });
                          },
                          items: itemss.map(
                            (valueitem) {
                              return DropdownMenuItem(
                                value: valueitem,
                                child: Text(valueitem),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: MaterialButton(
                          color: LightColor.navyBlue2,
                          onPressed: changeCurrency,
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: LightColor.yellow2,
                                  backgroundColor: LightColor.navyBlue2,
                                  strokeWidth: 5,
                                )
                              : const Text(
                                  "Change currency",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: LightColor.background,
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
          ],
        ),
      ),
    );
  }
}
