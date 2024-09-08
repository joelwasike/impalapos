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

class Beneficiary {
  final int? id;
  final int? userId;
  final String? beneficiaryName;
  final String? beneficiaryPhone;
  final String? beneficiaryCountry;
  final String? beneficiaryRelationship;
  final int? dateAdded;

  Beneficiary({
    required this.id,
    required this.userId,
    required this.beneficiaryName,
    required this.beneficiaryPhone,
    required this.beneficiaryCountry,
    required this.beneficiaryRelationship,
    required this.dateAdded,
  });

  factory Beneficiary.fromJson(Map<String, dynamic> json) {
    return Beneficiary(
      id: json['id'],
      userId: json['userId'],
      beneficiaryName: json['beneficiaryName'],
      beneficiaryPhone: json['beneficiaryPhone'],
      beneficiaryCountry: json['beneficiaryCountry'],
      beneficiaryRelationship: json['beneficiaryRelationship'],
      dateAdded: json['dateAdded'],
    );
  }
}

class Airtime extends StatefulWidget {
  const Airtime({super.key});

  @override
  State<Airtime> createState() => _DepositState();
}

class _DepositState extends State<Airtime> {
  TextEditingController phone1 = TextEditingController();
  TextEditingController pin = TextEditingController();
  bool isloading = false;
  String? dropdownValue;
  TextEditingController payerPhone = TextEditingController();
  TextEditingController inputamountcard = TextEditingController();
  String? valueChose;
  late int result;
  String? valueChos;
  int? sourceOfFunds = 0;
  String message = "";
  String? valueText;
  var jsonurl;
  bool isLoading1 = false;

  bool isLoading = false;
  List<Beneficiary> beneficiaries = [];

  Future fetchBen() async {
    try {
      var box = Hive.box('myBox');
      var phone = box.get("phone");

      Map<String, dynamic> body = {
        "phone": phone,
      };
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer NWNlYjJmNTEzYzMyZTcxMGZmYmIxZDEyNTYxNjc5MTY="
      };
      final url = Uri.parse(
          'https://www.sandbox.impalapay.com/api/?resource=beneficiary&action=read');
      final response =
          await http.post(url, headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'];

        setState(() {
          beneficiaries =
              data.map((json) => Beneficiary.fromJson(json)).toList();
        });
      } else {
        throw "";
      }
    } catch (e) {
      print(e);
    } finally {}
  }

  Future<void> _displayTextInputDialogwallet(
      BuildContext context, String phone, String amount) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFFDF8EE),
            title: Text(
              'Confirm buying $amount kes airtime to $phone ',
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
        buyairtime();
      } else {
        QuickAlert.show(
          backgroundColor: const Color(0xFFFDF8EE),
          confirmBtnColor: LightColor.black,
          context: context,
          type: QuickAlertType.error,
          text: "Pin Error",
        );
        setState(() {
          isloading = false;
        });
      }

      return responseData;
    } catch (e) {
      QuickAlert.show(
        backgroundColor: const Color(0xFFFDF8EE),
        confirmBtnColor: LightColor.black,
        context: context,
        type: QuickAlertType.error,
        text: "An error occured. PLease try again later",
      );
      setState(() {
        isloading = false;
      });
      throw (e);
    }
  }

  Future<Map<String, dynamic>> buyairtime() async {
    try {
      var box = Hive.box('myBox');
      var phone = box.get("phone");
      if (dropdownValue == "Safaricom") {
        setState(() {
          result = 4;
        });
      } else if (dropdownValue == "Airtel") {
        setState(() {
          result = 1;
        });
      } else if (dropdownValue == "Telkom") {
        setState(() {
          result = 2;
        });
      }
      if (valueChos == "Card") {
        setState(() {
          sourceOfFunds = 1;
        });
      } else if (valueChos == "Mpesa") {
        sourceOfFunds = 2;
      } else if (valueChos == "Wallet") {
        sourceOfFunds = 3;
      }

      final data = {
        "phone": phone,
        "recipientPhone": phone1.text,
        "amount": inputamountcard.text,
        "network": result,
        "sourceOfFunds": sourceOfFunds,
        "payerPhone": payerPhone.text
      };
      // Encode the JSON data
      final jsonPayload = json.encode(data);
      final url = Uri.parse(
          'https://www.sandbox.impalapay.com/api/?resource=utilities&action=sendAirtime');
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
      if (sourceOfFunds == 3) {
        setState(() {
          message = responseData["messsage"];
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
          message = "Enter m-pesa pin on the pop-up";
        });
        QuickAlert.show(
          backgroundColor: const Color(0xFFFDF8EE),
          confirmBtnColor: LightColor.black,
          context: context,
          type: QuickAlertType.info,
          text: message,
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
          text: message,
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
      QuickAlert.show(
        backgroundColor: const Color(0xFFFDF8EE),
        confirmBtnColor: LightColor.black,
        context: context,
        type: QuickAlertType.error,
        text: "An error occured",
      );

      throw (e);
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBen();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(),
          title: const Text(
            "Buy Airtime from..",
          ),
          bottom: const TabBar(
            indicator: BoxDecoration(),
            unselectedLabelStyle: TextStyle(fontSize: 15),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            dividerColor: Color(0xFFe29f1d),
            labelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            indicatorPadding: EdgeInsets.only(bottom: 6),
            tabs: [
              Tab(text: 'Wallet'),
              Tab(
                text: 'Mobile Money\n  (eg. M-pesa)',
              ),
              Tab(text: 'Card'),
            ],
          ),
        ),
        body: TabBarView(
          children: [_wallet(), _mpesa(), _card()],
        ),
      ),
    );
  }

  Widget _wallet() {
    return Stack(children: [
      ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 8),
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
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 13),
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
                          EdgeInsets.symmetric(horizontal: 6, vertical: 16),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        hint: Text(
                          'Select Network',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        dropdownColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        value: dropdownValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>["Safaricom", "Airtel", "Telkom"]
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
                            controller: phone1,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.phone,
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                labelText: "Recepient phone no.(254..)",
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
                            controller: inputamountcard,
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
                          ),
                        )),
                    const SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          valueChos = "Wallet";
                        });
                        _displayTextInputDialogwallet(
                            context, phone1.text, inputamountcard.text);
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 1,
                        decoration: const BoxDecoration(
                            color: const Color(0xFFD9B504),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: isloading
                            ? const Center(
                                child: SpinKitThreeBounce(
                                  color: Color(0xFF2D2D2D),
                                  size: 25,
                                ),
                              )
                            : const Center(
                                child: Text(
                                  "Buy airtime",
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
      ),
      isloading
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: const Color(0xFFFDF8EE).withOpacity(.5),
              child: const Center(
                child: SpinKitThreeBounce(
                  color: Color(0xFF2D2D2D),
                  size: 35,
                ),
              ),
            )
          : Container(),
    ]);
  }

  Widget _mpesa() {
    return Stack(children: [
      ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 8),
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
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 13),
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
                          EdgeInsets.symmetric(horizontal: 6, vertical: 16),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        hint: Text(
                          'Select Network',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        dropdownColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        value: dropdownValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>["Safaricom", "Airtel", "Telkom"]
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
                            controller: phone1,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.phone,
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                labelText: "Recepient phone no. (254..)",
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
                            controller: inputamountcard,
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
                            controller: payerPhone,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.phone,
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                labelText: "Source phone no. (254..)",
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
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          valueChos = "Mpesa";
                        });
                        _displayTextInputDialogwallet(
                            context, phone1.text, inputamountcard.text);
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 1,
                        decoration: const BoxDecoration(
                            color: const Color(0xFFD9B504),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: isloading
                            ? const Center(
                                child: SpinKitThreeBounce(
                                  color: Color(0xFF2D2D2D),
                                  size: 25,
                                ),
                              )
                            : const Center(
                                child: Text(
                                  "Buy airtime",
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
      ),
      isloading
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: const Color(0xFFFDF8EE).withOpacity(.5),
              child: const Center(
                child: SpinKitThreeBounce(
                  color: Color(0xFF2D2D2D),
                  size: 35,
                ),
              ),
            )
          : Container(),
    ]);
  }

  Widget _card() {
    return Stack(children: [
      ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 8),
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
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 13),
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
                          EdgeInsets.symmetric(horizontal: 6, vertical: 16),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        hint: Text(
                          'Select Network',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        dropdownColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        value: dropdownValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>["Safaricom", "Airtel", "Telkom"]
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
                            controller: phone1,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.phone,
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                labelText: "Recepient phone no. (254..)",
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
                            controller: inputamountcard,
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
                              )),
                            ),
                          ),
                        )),
                    const SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          valueChos = "Card";
                        });
                        _displayTextInputDialogwallet(
                            context, phone1.text, inputamountcard.text);
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 1,
                        decoration: const BoxDecoration(
                            color: const Color(0xFFD9B504),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: isloading
                            ? const Center(
                                child: SpinKitThreeBounce(
                                  color: Color(0xFF2D2D2D),
                                  size: 25,
                                ),
                              )
                            : const Center(
                                child: Text(
                                  "Buy airtime",
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
      ),
      isloading
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: const Color(0xFFFDF8EE).withOpacity(.5),
              child: const Center(
                child: SpinKitThreeBounce(
                  color: Color(0xFF2D2D2D),
                  size: 35,
                ),
              ),
            )
          : Container(),
    ]);
  }
}
