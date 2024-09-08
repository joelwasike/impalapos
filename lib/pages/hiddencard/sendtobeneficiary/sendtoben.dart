import 'package:animate_do/animate_do.dart';
import 'package:banktest/model/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class SendtoBeneficiary extends StatefulWidget {
  final String recepientphone;
  final String name;
  const SendtoBeneficiary(
      {super.key, required this.recepientphone, required this.name});

  @override
  State<SendtoBeneficiary> createState() => _DepositState();
}

class _DepositState extends State<SendtoBeneficiary> {
  TextEditingController amount = TextEditingController();
  TextEditingController amount1 = TextEditingController();
  TextEditingController wammount = TextEditingController();
  TextEditingController wname = TextEditingController();
  TextEditingController wphone = TextEditingController();
  TextEditingController phone1 = TextEditingController();
  TextEditingController wemail = TextEditingController();
  TextEditingController amountother = TextEditingController();
  TextEditingController pin = TextEditingController();

  TextEditingController name = TextEditingController();
  bool isLoading1 = false;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  String? valueText;

  bool isloading = false;
  String? dropdownValue;
  String? valueChosen;
  int? sourceOfFunds;
  String? message;
  bool _isLoadingContacts = false;
  var received = "0.00";

  //send money func
  Future<Map<String, dynamic>> deposited() async {
    try {
      if (valueChosen == "Card") {
        sourceOfFunds = 1;
      } else if (valueChosen == "Mpesa") {
        sourceOfFunds = 2;
      } else if (valueChosen == "Wallet") {
        sourceOfFunds = 3;
      }
      var box = Hive.box('myBox');
      var phone = box.get("phone");

      final data = {
        "phone": phone,
        "recipientPhone": widget.recepientphone,
        "amount": amount.text,
        "recipientName": widget.name,
        "sendingCurrency": dropdownValue,
        "sourceOfFunds": sourceOfFunds,
        "payerPhone": phone1.text
      };
      // Encode the JSON data
      final jsonPayload = json.encode(data);
      final url = Uri.parse(
          'https://www.sandbox.impalapay.com/api/?resource=transaction&action=create');
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
      if (sourceOfFunds == 3) {
        setState(() {
          message = responseData["message"];
        });
        if (responseData["error"] == true) {
          QuickAlert.show(
            backgroundColor: const Color(0xFFFDF8EE),
            confirmBtnColor: LightColor.black,
            context: context,
            type: QuickAlertType.error,
            text: message,
          );
        } else {
          QuickAlert.show(
            backgroundColor: const Color(0xFFFDF8EE),
            confirmBtnColor: LightColor.black,
            context: context,
            type: QuickAlertType.success,
            text: message,
          );
        }
      } else if (sourceOfFunds == 2) {
        setState(() {
          message = "Enter M-pesa pin on the pop-up";
        });
        QuickAlert.show(
          backgroundColor: const Color(0xFFFDF8EE),
          confirmBtnColor: LightColor.black,
          context: context,
          type: QuickAlertType.info,
          text: 'Enter M-pesa pin on the pop-up',
        );
      } else if (sourceOfFunds == 1) {
        setState(() {
          message = "redirecting..";
        });
        QuickAlert.show(
          backgroundColor: const Color(0xFFFDF8EE),
          confirmBtnColor: LightColor.black,
          context: context,
          type: QuickAlertType.info,
          text: 'redirecting..',
        );

        var linkbody = responseData["message"];
        List<String> parts = linkbody.split(' ');
        String link = parts.last;
        final Uri jsourl = Uri.parse(link);
        launchUrl(jsourl);
      }
      return responseData;
    } catch (e) {
      print(e);
      throw e;
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  Future<void> _displayTextInputDialogwallet(
      BuildContext context, String phone, String amount) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFFDF8EE),
            title: Text(
              'Confirm Sending $dropdownValue $amount to $phone ',
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
        deposited();
      } else {
        QuickAlert.show(
          backgroundColor: const Color(0xFFFDF8EE),
          confirmBtnColor: LightColor.black,
          context: context,
          type: QuickAlertType.error,
          text: 'Check your pin and try again!',
        );

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.recepientphone);
    print(widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: scaffoldMessengerKey,
        appBar: AppBar(
          iconTheme: const IconThemeData(),
          title: const Text(
            "Send from..",
          ),
          bottom: const TabBar(
            indicator: BoxDecoration(),
            unselectedLabelStyle: TextStyle(fontSize: 15),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            dividerColor: Color(0xFFe29f1d),
            labelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            indicatorPadding: EdgeInsets.only(bottom: 6),
            tabs: [
              Tab(text: 'Wallet'),
              Tab(
                text: 'M-Pesa',
              ),
              Tab(text: 'Card'),
            ],
          ),
        ),
        body: Builder(builder: (BuildContext context) {
          return TabBarView(
            children: [
              _wallet(),
              _mpesa(),
              _card(),
            ],
          );
        }),
      ),
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
        FadeInUp(
          child: Container(
            padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "  Sending to: ${widget.name}, ${widget.recepientphone} ",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 15,
                  ),
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
                const SizedBox(
                  height: 5.0,
                ),
                SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextField(
                        controller: phone1,
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
                SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextField(
                        onChanged: (text) {
                          if (text.isNotEmpty) {
                            double enteredValue = double.parse(text);
                            double newValue = enteredValue * 0.955;
                            setState(() {
                              received = newValue.toStringAsFixed(2);
                            });
                          }
                        },
                        controller: amount,
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
                          ),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                    )),
                SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ReceivedAmountDisplay(received: received),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      valueChosen = "Mpesa";
                    });
                    _displayTextInputDialogwallet(
                        context, widget.recepientphone, amount.text);
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
                              "Send",
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
      ],
    );
  }

  Widget _wallet() {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "  Sending to: ${widget.name}, ${widget.recepientphone} ",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 15,
                    ),
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
                          onChanged: (text) {
                            if (text.isNotEmpty) {
                              double enteredValue = double.parse(text);
                              double newValue = enteredValue * 0.955;
                              setState(() {
                                received = newValue.toStringAsFixed(2);
                              });
                            }
                          },
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
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                      )),
                  SizedBox(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ReceivedAmountDisplay(received: received),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        valueChosen = "Wallet";
                      });
                      _displayTextInputDialogwallet(
                          context, widget.recepientphone, amount.text);
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
                                "Send",
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "  Sending to: ${widget.name}, ${widget.recepientphone} ",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 15,
                    ),
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
                          onChanged: (text) {
                            if (text.isNotEmpty) {
                              double enteredValue = double.parse(text);
                              double newValue = enteredValue * 0.955;
                              setState(() {
                                received = newValue.toStringAsFixed(2);
                              });
                            }
                          },
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
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                      )),
                  SizedBox(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ReceivedAmountDisplay(received: received),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        valueChosen = "Card";
                      });
                      _displayTextInputDialogwallet(
                          context, widget.recepientphone, amount.text);
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 1,
                      decoration: const BoxDecoration(
                          color: Color(0xFFD9B504),
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
                                "Send",
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

class ReceivedAmountDisplay extends StatefulWidget {
  final String received;

  ReceivedAmountDisplay({required this.received});

  @override
  _ReceivedAmountDisplayState createState() => _ReceivedAmountDisplayState();
}

class _ReceivedAmountDisplayState extends State<ReceivedAmountDisplay> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.3,
      height: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
        child: Text(
          "Amount to be received: ${widget.received}",
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
