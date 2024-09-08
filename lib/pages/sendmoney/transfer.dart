import 'package:animate_do/animate_do.dart';
import 'package:banktest/pages/sendmoney/countries.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Transfer extends StatefulWidget {
  final String? currency;

  const Transfer({super.key, required this.currency});

  @override
  State<Transfer> createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  bool ismpesa = false;
  bool isLoading1 = false;
  bool isloading = false;
  TextEditingController email = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController mpesaphone = TextEditingController();
  TextEditingController mpesaamount = TextEditingController();
  String? valueText;
  final TextEditingController pin = TextEditingController();
  String message = "";
  double finalamount = 0.0;
  double fxrate = 0.0;
  double cost = 0.0;
  double rate = 0.0;
  String? dropdownValue;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  var inputamountcard = TextEditingController();
  var payerPhone = TextEditingController();

//rates and costs
  Future<void> ratee() async {
    var box = Hive.box('Box');
    var token = box.get("token");
    try {
      var url = Uri.parse("https://neobank.nanesoft-lab.com/read-charges/");
      var data = {
        "from_currency_code": "Usd",
        "to_currency_code": "kes",
        "amount": mpesaamount.text
      };
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
      var res = jsonDecode(response.body);
      var finala = res['final_amount'];
      print(finala);
      // print(res['final_amount']);
      print(res);
      setState(() {
        finalamount = finala;
        fxrate = res['forex_rate'];
        cost = res['cost'];
      });

      print(finalamount);
    } catch (e) {
      print(e);
      message = 'An error occurred';
    }
  }

  Future<void> transfertomobile() async {
    setState(() {
      isloading = true;
    });
    var box = Hive.box('Box');
    var token = box.get("token");
    String message = '';
    try {
      var url = Uri.parse("https://neobank.nanesoft-lab.com/transfer/");
      var data = {
        "amount": mpesaamount.text,
        "phone": mpesaphone.text,
        "pin": pin.text
      };
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
      var res = jsonDecode(response.body);
      message = jsonDecode(res['message'])['msg'];
      print(message);
    } catch (e) {
      print(e);
      message = 'An error occurred';
    } finally {
      setState(() {
        isloading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  //check pin
  Future<Map<String, dynamic>> checkPin() async {
    try {
      setState(() {
        isLoading1 = true;
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
        wallettowallet();
      } else {
        var messag = "Pin error";
        var snackBar = SnackBar(
          content: Text(messag),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          isLoading1 = false;
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

  Future<void> _displayTextInputDialogwallet(BuildContext context) async {
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
                    textColor: const Color(0xFFFDF8EE),
                    child: const Text('CANCEL'),
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                  ),
                  MaterialButton(
                    color: const Color(0xFF020087),
                    textColor: const Color(0xFFFDF8EE),
                    child: const Text('Confirm'),
                    onPressed: () {
                      Navigator.pop(context);
                      checkPin();
                    },
                  ),
                ],
              )
            ],
          );
        });
  }

  Future<void> _displayTextInputDialogmobile(BuildContext context) async {
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
                    textColor: const Color(0xFFFDF8EE),
                    child: const Text('CANCEL'),
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                  ),
                  MaterialButton(
                    color: const Color(0xFF020087),
                    textColor: const Color(0xFFFDF8EE),
                    child: const Text('Confirm'),
                    onPressed: () {
                      Navigator.pop(context);
                      transfertomobile();
                    },
                  ),
                ],
              )
            ],
          );
        });
  }

  Future<Map<String, dynamic>> wallettowallet() async {
    try {
      var box = Hive.box('myBox');
      var phone = box.get("phone");

      final data = {
        "phone": phone,
        "amount": inputamountcard.text,
        "recipientEmail": email.text,
        "currencyCode": dropdownValue,
      };
      // Encode the JSON data
      final jsonPayload = json.encode(data);
      final url = Uri.parse(
          'https://www.sandbox.impalapay.com/api/?resource=transaction&action=wallet2wallet');
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
      message = responseData["message"];

      return responseData;
    } catch (e) {
      print(e);
      throw "$e";
    } finally {
      setState(() {
        isLoading1 = false;
        var snackBar = SnackBar(
          content: Text(message),
          action: SnackBarAction(
            label: 'OK', // Customize the label as needed

            onPressed: () {
              // Perform navigation back to the previous screen
              Navigator.of(context).pop();
            },
          ),
          duration: Duration(minutes: 1),
        );
        scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(),
        title: const Text(
          "Send Money to..",
        ),
      ),
      body: _buildMpesaTransaction(),
    );
  }

  Widget _buildInAppTransaction() {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(15.0),
      children: <Widget>[
        Center(
          child: FadeInLeft(
            child: Container(
              padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
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
                          controller: email,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.email,
                              ),
                              labelText: "Account email.",
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
                  SizedBox(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: TextField(
                          controller: amount,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                FontAwesomeIcons.moneyBill,
                                color: Colors.grey,
                              ),
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
                              )),
                        ),
                      )),
                  const SizedBox(
                    height: 5.0,
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: MaterialButton(
                        color: const Color(0xFF020087),
                        onPressed: () async {
                          _displayTextInputDialogwallet(context);
                        },
                        child: isLoading1
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                                backgroundColor: Colors.white,
                                strokeWidth: 5,
                              )
                            : const Text(
                                "Send",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
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

  Widget _buildMpesaTransaction() {
    return Countries();
  }
}
