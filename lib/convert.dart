import 'package:banktest/model/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive_flutter/adapters.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Conversion extends StatefulWidget {
  const Conversion({super.key});

  @override
  State<Conversion> createState() => _ConversionState();
}

class _ConversionState extends State<Conversion> {
  bool isLoading = false;
  List itemss = ["USD", "GBP", "EUR", "KES", "UGX", "TZS"];
  String? from;
  String? to;
  var message;
  var inputamount = TextEditingController();
  var rate;
  double impalarate = 1.0;
  double? total = 0.0;

  Future buyOrSale() async {
    try {
      setState(() {
        isLoading = true;
      });
      var box = Hive.box('myBox');
      var phone = box.get("phone");

      final data = {
        "phone": phone,
        "sourceCurrencyCode": from,
        "destinationCurrencyCode": to,
        "amount": inputamount.text
      };
      // Encode the JSON data
      final jsonPayload = json.encode(data);
      final url = Uri.parse(
          'https://www.sandbox.impalapay.com/api/?resource=balance&action=convert');
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
      print(from);
      print(to);
      var error = responseData["error"];
      setState(() {
        rate = responseData["rate"];
      });
      print(rate);

      if (error == false) {
        message = "Conversion successful";
      } else {
        var response = responseData["message"];
        message = response;
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

  Future forex() async {
    try {
      final data = {
        "sourceCurrencyCode": from,
        "destinationCurrencyCode": to,
      };
      // Encode the JSON data
      final jsonPayload = json.encode(data);
      final url = Uri.parse(
          'https://www.sandbox.impalapay.com/api/?resource=transaction&action=forex');
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
      print(from);
      print(to);
      var error = responseData["error"];
      if (error == false && mounted) {
        setState(() {
          var tot = double.tryParse(inputamount.text);
          if (tot == null) {
            total = 1.0;
          } else {
            total = double.tryParse(inputamount.text);
          }

          var imprate = responseData["data"][0]["impalaRate"];
          if (imprate == null || imprate == 1) {
            impalarate = 1.0;
          } else {
            impalarate = double.parse(imprate.toStringAsFixed(2));
          }
        });
      }

      return responseData;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    forex();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conversion page"),
      ),
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
                      "Convert currencies",
                      style: TextStyle(
                          color: LightColor.navyBlue2,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          decoration: TextDecoration.underline),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                          'From:',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFDF8EE),
                            ),
                            child: DropdownButton<String>(
                              underline: Container(),
                              hint: const Text(
                                'choose currency',
                                style: TextStyle(
                                    color: LightColor.navyBlue2,
                                    fontWeight: FontWeight.w500),
                              ),
                              value: from,
                              onChanged: (newValue) {
                                setState(() {
                                  from = newValue;
                                });
                              },
                              items: itemss.map((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                          'To:',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 38),
                        SizedBox(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFDF8EE),
                            ),
                            child: DropdownButton<String>(
                              underline: Container(),
                              hint: const Text(
                                'choose currency',
                                style: TextStyle(
                                    color: LightColor.navyBlue2,
                                    fontWeight: FontWeight.w500),
                              ),
                              value: to,
                              onChanged: (newValue) {
                                setState(() {
                                  to = newValue;
                                });
                              },
                              items: itemss.map((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Amount:',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: to != null ? '$to amount' : 'amount',
                              border: const OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                inputamount.text = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Container(
                            height: 58,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4))),
                            child: Column(
                              children: [
                                const Text(
                                  "after conversion",
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Center(
                                    child: Text(
                                  (total! / impalarate).toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                )),
                                Text(
                                  from ?? "",
                                  style: const TextStyle(fontSize: 10),
                                )
                              ],
                            ),
                          ),
                        ),
                        // const SizedBox(width: 100),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        const Text(
                          'impalapay\n rate:',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4))),
                            child: Center(child: Text(impalarate.toString())),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        buyOrSale();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 90, right: 2, bottom: 10, top: 20),
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 1,
                          decoration: const BoxDecoration(
                              color: const Color(0xFFCDA73B),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: isLoading
                              ? const Center(
                                  child: SpinKitThreeBounce(
                                    color: Color(0xFF2D2D2D),
                                    size: 25,
                                  ),
                                )
                              : const Center(
                                  child: Text(
                                    "Convert",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
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
