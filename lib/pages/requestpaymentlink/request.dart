import 'package:auto_size_text/auto_size_text.dart';
import 'package:banktest/pages/deposit.dart';
import 'package:banktest/pages/requestpaymentlink/qrscanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class Request extends StatefulWidget {
  final String links;
  final int paycode;
  const Request({super.key, required this.links, required this.paycode});

  @override
  State<Request> createState() => _MyqrpageState();
}

class _MyqrpageState extends State<Request> {
  late var box = Hive.box('myBox');
  late var email = box.get("email");
  bool isloading = false;
  late String paymentlinks = widget.links;
  late int payCode = widget.paycode;

  Future paymentlinkcheck() async {
    try {
      var box = Hive.box('myBox');
      var phone = box.get("phone");

      setState(() {
        isloading = true;
      });
      Map<String, dynamic> body = {
        "id": "",
        "userId": "",
        "phone": phone,
        "uniqueId": "",
        "payCode": "",
        "type": "mobile"
      };
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer NWNlYjJmNTEzYzMyZTcxMGZmYmIxZDEyNTYxNjc5MTY="
      };
      final url = Uri.parse(
          'https://www.sandbox.impalapay.com/api/rs/transaction/at/read_qr_pay_link');
      final response =
          await http.post(url, headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final String link = jsonData['data'][0]["link"];
        final int paycode = jsonData['data'][0]["payCode"];
        setState(() {
          paymentlinks = link;
          payCode = paycode;
        });
      } else {
        throw "";
      }
    } catch (e) {
      throw e;
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  Future createlink() async {
    try {
      var box = Hive.box('myBox');
      var phone = box.get("phone");

      setState(() {
        isloading = true;
      });
      Map<String, dynamic> body = {"phone": phone, "currency": "KES"};
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer NWNlYjJmNTEzYzMyZTcxMGZmYmIxZDEyNTYxNjc5MTY="
      };
      final url = Uri.parse(
          'https://www.sandbox.impalapay.com/api/rs/transaction/at/create_qr_pay_link');
      final response =
          await http.post(url, headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final String meso = jsonData['message'];

        if (meso == "Success") {
          await paymentlinkcheck();
        }
      } else {
        throw "";
      }
    } catch (e) {
      throw e;
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
    if (widget.links ==
        "http://d.impala.hosted.pay/qr_pay/Z9Rc0Rrm3gO60C0clYj_iL6GVd0Pj5vhjoOulm19-U8_VvfYQcxrlHhsNDe6HtSTkCjuqBcng-EOMhroTGYoyu6USEAnHHNyxZhisn59RKrws7ZA_-fkkXjVDJdwYf5eYSbTFr5I0Zh6efuYHDkQFw") {
      createlink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Receive Payment"),
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
              Tab(text: 'Mobile money'),
              Tab(
                text: 'Impalapay user',
              ),
            ],
          ),
        ),
        body: Builder(builder: (BuildContext context) {
          return TabBarView(
            children: [Deposit(currency: "",), towallet()],
          );
        }),
      ),
    );
  }

  Widget paymentlink() {
    return Stack(children: [
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 60,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)),
              child: QrImageView(
                padding: const EdgeInsets.all(12),
                embeddedImage:
                    const AssetImage("images/impala-removebg-preview.png"),
                // backgroundColor: const Color.fromARGB(255, 235, 235, 232),
                data: paymentlinks,
                version: QrVersions.auto,
                size: 300.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "My impalapay account number: $payCode",
                style: TextStyle(fontSize: 12),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Others can scan to pay you, Or copy the payment link below.",
                style: TextStyle(fontSize: 12),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await Share.share(paymentlinks);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 1,
                  decoration: const BoxDecoration(
                      color: const Color(0xFFD9B504),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.copy,
                            color: Colors.black,
                          ),
                          Text("  "),
                          AutoSizeText(
                            style: TextStyle(fontFamily: "joel2", fontSize: 12),
                            "${paymentlinks.substring(0, 40)}...",
                            minFontSize: 13,
                            maxFontSize: 20,
                            overflow: TextOverflow.clip,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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

  Widget towallet() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 60,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10)),
            child: QrImageView(
              padding: const EdgeInsets.all(12),
              embeddedImage:
                  const AssetImage("images/impala-removebg-preview.png"),
              // backgroundColor: const Color.fromARGB(255, 235, 235, 232),
              data: email,
              version: QrVersions.auto,
              size: 300.0,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Others can scan with Impalapay app to pay you.",
              style: TextStyle(fontSize: 12),
            ),
          ),
          GestureDetector(
            onTap: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Scanqr();
              }));
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 2,
                decoration: const BoxDecoration(
                    color: const Color(0xFFD9B504),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SvgPicture.asset(
                        'assets/qr-scan-2-svgrepo-com.svg',
                        width: MediaQuery.of(context).size.width /
                            10, // Adjust the width as needed
                        height: MediaQuery.of(context).size.height /
                            30, // Adjust the height as needed
                      ),
                      const Text(
                        "Scan to pay",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
