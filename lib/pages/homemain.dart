import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:banktest/balances.dart';
import 'package:banktest/model/card.dart';
import 'package:banktest/pages/auth/loginScreen.dart';
import 'package:banktest/pages/buyairtime.dart';
import 'package:banktest/pages/notifications.dart';
import 'package:banktest/pages/requestpaymentlink/qrscanner.dart';
import 'package:banktest/pages/requestpaymentlink/request.dart';
import 'package:banktest/pages/settings/screens/account_screen.dart';
import 'package:banktest/pages/transactions.dart';
import 'package:banktest/pages/sendmoney/transfer.dart';
import 'package:banktest/pages/widget_cards.dart';
import 'package:banktest/pages/withdraw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:upgrader/upgrader.dart';

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

class Transaction {
  final int? userId;
  final String? transactionStatus;
  final String? transactionReport;
  final String? sendingCurrency;
  final String? amount;
  final String? netAmount;
  final String? recipientPhone;
  final String? recipientName;
  final String? secureId;
  final String? sourceOfFunds;
  final String? dateAdded;

  Transaction({
    required this.userId,
    required this.transactionStatus,
    required this.transactionReport,
    required this.sendingCurrency,
    required this.amount,
    required this.netAmount,
    required this.recipientPhone,
    required this.recipientName,
    required this.secureId,
    required this.sourceOfFunds,
    required this.dateAdded,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      userId: json['userId'],
      transactionStatus: json['transactionStatus'],
      transactionReport: json['transactionReport'],
      sendingCurrency: json['sendingCurrency'],
      amount: json['amount'],
      netAmount: json['netAmount'],
      recipientPhone: json['recipientPhone'],
      recipientName: json['recipientName'],
      secureId: json['secureId'],
      sourceOfFunds: json['sourceOfFunds'],
      dateAdded: json['transactionDate'],
    );
  }
}

class Homemain extends StatefulWidget {
  const Homemain({super.key});

  @override
  State<Homemain> createState() => _HomemainState();
}

class _HomemainState extends State<Homemain> {
  List<Beneficiary> beneficiaries = [];
  final PageController _controllerPage = PageController();
  AnimationController? _controller;
  late Animation<double> _rotection;
  AnimationController? _controllerprogress;
  Animation<double>? _prograsser;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isloading = false;
  bool isOpen = true;
  var name = "";
  var email = "";
  var phone = "";
  var balance = 0;
  var dolabalance = 0;
  var realbalance = 0;
  bool isvisible = false;
  String? currencyAccount = "";
  String? currencyCode = "";
  String balanceoncard = "Balance: ";
  List<Cardd> cards = [
    const Cardd(
        logo: "images/kenya.png",
        number: "Balance: ",
        title: "KENYA",
        plan: "Currency: KSH",
        color: [Color(0xFF7017FF), Color(0xFF8138FF)],
        currency: 'KSH ACCOUNT',
        currencycode: 'KSH'),
  ];
  List<Transaction> transactions = [];
  bool hasdollar = true;
  bool isLoading = false;
  bool isLoading1 = false;
  var balancer = 0.00;
  var currencer = "";
  final TextEditingController pin = TextEditingController();
  String? codeDialog;
  String? valueText;
  bool isBalanceVisible = true;
  String? paymentlinks;
  int? paycode;

  Future paymentlink() async {
    try {
      var box = Hive.box('myBox');
      var phone = box.get("phone");

      setState(() {
        isLoading = true;
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
        final List<dynamic> data = jsonData['data'];

        if (data.isNotEmpty) {
          setState(() {
            paymentlinks = data[0]["link"];
            paycode = data[0]["payCode"];
          });
        } else {
          setState(() {
            paymentlinks =
                "http://d.impala.hosted.pay/qr_pay/Z9Rc0Rrm3gO60C0clYj_iL6GVd0Pj5vhjoOulm19-U8_VvfYQcxrlHhsNDe6HtSTkCjuqBcng-EOMhroTGYoyu6USEAnHHNyxZhisn59RKrws7ZA_-fkkXjVDJdwYf5eYSbTFr5I0Zh6efuYHDkQFw";
          });
        }
      } else {
        throw "";
      }
    } catch (e) {
      throw e;
    }
  }

  Future fetchBen() async {
    try {
      var box = Hive.box('myBox');
      var phone = box.get("phone");

      setState(() {
        isLoading = true;
      });
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
    }
  }

  // Future<void> _displayTextInputDialog(BuildContext context) async {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: const Text('Enter your pin'),
  //           content: TextField(
  //             obscureText: true,
  //             onChanged: (value) {
  //               setState(() {
  //                 valueText = value;
  //               });
  //             },
  //             controller: pin,
  //             decoration: const InputDecoration(hintText: "Your Impalapay pin"),
  //           ),
  //           actions: <Widget>[
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 MaterialButton(
  //                   color: Colors.red,
  //                   textColor: const Color(0xFFFDF8EE),
  //                   child: const Text('CANCEL'),
  //                   onPressed: () {
  //                     setState(() {
  //                       Navigator.pop(context);
  //                     });
  //                   },
  //                 ),
  //                 MaterialButton(
  //                   color: LightColor.navyBlue2,
  //                   textColor: const Color(0xFFFDF8EE),
  //                   child: const Text('Confirm'),
  //                   onPressed: () {
  //                     checkPin();
  //                     Navigator.pop(context);
  //                   },
  //                 ),
  //               ],
  //             )
  //           ],
  //         );
  //       });
  // }

  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length >= 12) {
      final start = phoneNumber.substring(0, 3); // Include country code
      const middle = '******';
      final end = phoneNumber.substring(9); // Include last 3 digits
      return '$start$middle$end';
    } else if (phoneNumber.length >= 10) {
      final start = phoneNumber.substring(0, 2); // Exclude country code
      const middle = '******';
      final end = phoneNumber.substring(8); // Include last 2 digits
      return '$start$middle$end';
    }
    return phoneNumber; // Return as is if less than 10 digits
  }

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
        fetchBalance();
        setState(() {
          isBalanceVisible = false;
        });
      } else {
        var message = "Pin error";
        var snackBar = SnackBar(
          content: Text(message),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      return responseData;
    } catch (e) {
      print(e);
      var message = "Check your internet connection";
      var snackBar = SnackBar(
        content: Text(message),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      rethrow;
    } finally {
      setState(() {
        isLoading1 = false;
      });
    }
  }

  Future<void> fetchBalance() async {
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
          'https://www.sandbox.impalapay.com/api/?resource=balance&action=read');
      final response =
          await http.post(url, headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final data = jsonData['data'];

        // Extract the balance from the response and update the state
        var newBalance = data[0]["totalBalance"];

        var currency = data[0]["baseCurrency"];
        if (mounted) {
          setState(() {
            balancer = newBalance.toDouble();

            currencer = currency;
          });
        }
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });
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
          'https://www.sandbox.impalapay.com/api/?resource=transaction&action=read');
      final response =
          await http.post(url, headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List data = jsonData['data'];

        setState(() {
          transactions =
              data.map((json) => Transaction.fromJson(json)).toList();
        });
      } else {
        throw "";
      }
    } catch (e) {
      print(e);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Log Out',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              onPressed: () async {
                //await box.close();
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
                Navigator;
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    paymentlink();
    const duration = Duration(seconds: 10);
    Timer.periodic(duration, (timer) {
      fetchBalance();
      fetchBen();
      fetchData();
    });
    fetchBalance();
    fetchBen();
    fetchData();
    // TODO: implement initState
    super.initState();
    setState(() {
      var box = Hive.box("myBox");
      name = box.get("names");
      email = box.get("email");
      phone = box.get("phone");
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerPage.dispose();
    _controller!.dispose();
    _controllerprogress!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return UpgradeAlert(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
              backgroundColor: const Color(0xFFFDF8EE),
              surfaceTintColor: const Color(0xFFFDF8EE),
              automaticallyImplyLeading: false,
              elevation: 0,
              title: FadeIn(
                delay: const Duration(seconds: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: we * 0.01,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const AccountScreen();
                        }));
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            maxRadius: 25,
                            backgroundColor:
                                const Color.fromARGB(255, 248, 238, 190),
                            child: Text(
                              name.substring(0, 2).toUpperCase(),
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ),
                          SizedBox(
                            width: we * 0.02,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Welcome,",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey)),
                              Text(
                                name.toUpperCase(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return Scanqr();
                        }));
                      },
                      icon: SvgPicture.asset(
                        'assets/qr-scan-svgrepo-com.svg',
                        width: we / 8, // Adjust the width as needed
                        height: he / 25, // Adjust the height as needed
                        color: Color.fromARGB(255, 216, 183, 73),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const Notifications();
                        }));
                      },
                      icon: SvgPicture.asset(
                        'assets/bell.svg',
                        width: we / 8, // Adjust the width as needed
                        height: he / 25, // Adjust the height as needed
                      ),
                    ),
                  ],
                ),
              )),
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .21,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B1B1B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "My Wallet",
                              style: TextStyle(
                                color: Color.fromARGB(255, 179, 178, 178),
                                fontSize: 17,
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 19,
                              width: MediaQuery.of(context).size.width / 7,
                              decoration: const BoxDecoration(
                                color: Color(0xFF1B1B1B),
                                image: DecorationImage(
                                  image: AssetImage(
                                      "images/impalapay-removebg-preview.png"),
                                ),
                              ),
                            )
                          ],
                        ),
                        const Text(
                          "Balance:",
                          style: TextStyle(color: Color(0xFFD9D9D9)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              isBalanceVisible ? '' : "$currencer. ",
                              style: GoogleFonts.poppins(
                                textStyle:
                                    Theme.of(context).textTheme.headlineMedium,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFFCDA73B),
                              ),
                            ),
                            Text(
                              isBalanceVisible ? '*****' : balancer.toString(),
                              style: GoogleFonts.poppins(
                                textStyle:
                                    Theme.of(context).textTheme.headlineMedium,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFFCDA73B),
                              ),
                            ),
                            IconButton(
                              icon: isBalanceVisible
                                  ? SvgPicture.asset(
                                      'assets/eye-slash-visibility-visible-hide-hidden-show-watch-svgrepo-com 1.svg',
                                      width:
                                          MediaQuery.of(context).size.width / 7,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              39,
                                    )
                                  : SvgPicture.asset(
                                      'assets/eye-visibility-visible-hide-hidden-show-watch-svgrepo-com 1.svg',
                                      width:
                                          MediaQuery.of(context).size.width / 7,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              39,
                                    ),
                              onPressed: () {
                                setState(() {
                                  isBalanceVisible = !isBalanceVisible;
                                });
                              },
                            ),
                          ],
                        ),
                     
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                           //Balances()
                            
                             Transfer(
                              currency: currencyCode,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          height: he / 12,
                          width: we / 2.2,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDF8EE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/sendMoney.svg',
                                  width: we / 10, // Adjust the width as needed
                                  height:
                                      he / 20, // Adjust the height as needed
                                ),
                                SizedBox(
                                  width: we * 0.01,
                                ),
                                const Text("Send\nMoney")
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Request(
                              links: paymentlinks!,
                              paycode: paycode!,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          height: he / 12,
                          width: we / 2.2,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDF8EE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/requestCash.svg',
                                  width: we / 10, // Adjust the width as needed
                                  height:
                                      he / 20, // Adjust the height as needed
                                ),
                                SizedBox(
                                  width: we * 0.01,
                                ),
                                const Text("Request\nPayment")
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                   
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Airtime(),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          height: he / 12,
                          width: we / 2.2,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDF8EE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/buyAirtime.svg',
                                  width: we / 10, // Adjust the width as needed
                                  height:
                                      he / 20, // Adjust the height as needed
                                ),
                                SizedBox(
                                  width: we * 0.01,
                                ),
                                const Text("Buy\nAirtime")
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Withdraw(),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          height: he / 12,
                          width: we / 2.2,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDF8EE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/withdraw.svg',
                                  width: we / 10, // Adjust the width as needed
                                  height:
                                      he / 20, // Adjust the height as needed
                                ),
                                SizedBox(
                                  width: we * 0.01,
                                ),
                                const Text("Withdraw\nCash")
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
           
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF8EE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Impalapay Statements",
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const Transactions(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "View all",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xFF2D2D2D),
                                    decorationThickness: 2,
                                    color: Color(0xFF2D2D2D),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FadeIn(
                          delay: Duration.zero,
                          child: SizedBox(
                            width: we * 1,
                            height: he / 2,
                            child: transactions.isEmpty
                                ? const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Make a transaction to view statements..",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: transactions.length >= 4
                                        ? 4
                                        : transactions
                                            .length, // Ensure itemCount is limited to the smaller of 2 or the length of transactions
                                    itemBuilder: (context, index) {
                                      if (index < 4) {
                                        // Check if index is less than 2
                                        final transaction = transactions[index];
                                        return Widget_Card(
                                          date: transaction.dateAdded!,
                                          kind: transaction.recipientName!,
                                          icon: FontAwesomeIcons
                                              .person, // Change this to the appropriate icon based on transaction kind
                                          amount: !isvisible
                                              ? "- ${"${transaction.amount} ${transaction.sendingCurrency!}"}"
                                              : "*****",
                                          time: transaction
                                              .transactionStatus!, // You can use a formatted date-time here
                                          phone: formatPhoneNumber(transaction
                                                  .recipientPhone!) ??
                                              "",
                                          status:
                                              transaction.transactionStatus!,
                                        );
                                      } else {
                                        return const SizedBox(); // Return an empty SizedBox for elements beyond the first two
                                      }
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
