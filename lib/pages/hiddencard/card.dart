import 'package:banktest/pages/hiddencard/failed.dart';
import 'package:banktest/pages/hiddencard/successcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CardDetailsForm extends StatefulWidget {
  @override
  _CardDetailsFormState createState() => _CardDetailsFormState();
}

class _CardDetailsFormState extends State<CardDetailsForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController cardNumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController ccvController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController expiryYearController = TextEditingController();
  bool isloading = false;
  String? dropdownValue;

  Future<Map<String, dynamic>> deposit() async {
    try {
      setState(() {
        isloading = true;
      });
      var box = Hive.box('myBox');
      var phone = box.get("phone");

      // Create FormData object
      var formData = http.MultipartRequest(
          'POST', Uri.parse('https://hostedpg2.mhsafrika.com/?A2D=123456'));

      // Add fields to FormData
      formData.fields.addAll({
        "a": amountController.text,
        "c": dropdownValue!,
        "n": cardNumberController.text,
        "s": ccvController.text,
        "m": expiryDateController.text,
        "y": expiryYearController.text,
      });

      // Send the HTTP request
      final response = await formData.send();

      // Get response body
      final responseData = await response.stream.bytesToString();

      // Decode the response JSON
      final decodedResponse = json.decode(responseData);
      print(decodedResponse);
      if (decodedResponse["result"] == "SUCCESS") {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Succard(
            amount: amountController.text,
            currency: dropdownValue!,
          );
        }));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Failed();
        }));
      }

      return decodedResponse;
    } catch (e) {
      print(e);
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
        title: const Text('Card Details Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                      controller: cardNumberController,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.numbers,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          labelText: "Card number.",
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
                            ),
                          )),
                    ),
                  )),
              SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextField(
                      controller: amountController,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.money,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          labelText: "Amount.",
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
                            ),
                          )),
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: TextField(
                            controller: expiryDateController,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.calendar_month,
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                labelText: "Expiry month.",
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
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: TextField(
                            controller: expiryYearController,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.calendar_month,
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                labelText: " year.",
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
                  ),
                ],
              ),
              SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextField(
                      controller: ccvController,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.pin,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          labelText: "CVV.",
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
                            ),
                          )),
                    ),
                  )),
              const SizedBox(height: 16.0),
              SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: MaterialButton(
                    color: const Color(0xFF020087),
                    onPressed: () async {
                      deposit();
                    },
                    child: isloading
                        ? const SpinKitThreeBounce(
                            color: const Color(0xFFFDF8EE),
                            size: 25,
                          )
                        : const Text(
                            "Deposit",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    amountController.dispose();
    ccvController.dispose();
    expiryDateController.dispose();
    expiryYearController.dispose();
    super.dispose();
  }
}
