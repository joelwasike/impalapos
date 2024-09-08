import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class CreateDollar extends StatefulWidget {
  const CreateDollar({super.key});

  @override
  State<CreateDollar> createState() => _FundcardState();
}

class _FundcardState extends State<CreateDollar> {
  double finalamount = 0.0;
  double fxrate = 0.0;
  double cost = 0.0;
  double rate = 0.0;
  var message = "";
  final String _selectedCurrency = 'kes';
  bool isvisble = false;

  TextEditingController amount = TextEditingController();
  TextEditingController pin = TextEditingController();

  bool isloading = false;

  //rates and costs
  Future<void> ratee() async {
    var box = Hive.box('Box');
    var token = box.get("token");
    try {
      var url = Uri.parse("https://neobank.nanesoft-lab.com/read-charges/");
      var data = {
        "from_currency_code": "Usd",
        "to_currency_code": "kes",
        "amount": amount.text
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

  Future<void> createcurrency() async {
    setState(() {
      isloading = true;
    });
    var box = Hive.box('Box');
    var token = box.get("token");
    try {
      var url = Uri.parse(
          "https://neobank.nanesoft-lab.com/create/currency-account/");
      var data = {"amount": amount.text, "name_code": "usd", "pin": pin.text};
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
      print(res);
      var message = res["message"];
      if (message == "successful") {
        var url = Uri.parse(res["link"]);
        launchUrl(url);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("An error occured")));
      }

      print(message);
    } catch (e) {
      print(e);
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
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "Create Dollar Account",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
      body: _buildbody(),
    );
  }

  Widget _buildbody() {
    return Column(
      children: [
        ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(15.0),
          children: <Widget>[
            Center(
              child: FadeInUp(
                child: Container(
                  padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
                  child: Column(
                    children: <Widget>[
                      const Text(
                        "Fund the dollar account to create it",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            decoration: TextDecoration.underline),
                      ),
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
                                  Icons.money,
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                labelText: "Amount in USD.",
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
                              obscureText: isvisble
                                  ? false
                                  : true, // Set obscureText to true to hide the password
                              controller: pin,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isvisble = !isvisble;
                                    });
                                  },
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                labelText: "Your account pin.",
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
                              createcurrency();
                            },
                            child: isloading
                                ? const SpinKitThreeBounce(
                                    color: Colors.white,
                                    size: 25,
                                  )
                                : const Text(
                                    "Fund Dollar account",
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
        ),
      ],
    );
  }
}
