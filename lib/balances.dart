import 'package:banktest/convert.dart';
import 'package:banktest/model/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive_flutter/adapters.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Balances extends StatefulWidget {
  const Balances({super.key});

  @override
  State<Balances> createState() => _BalancesState();
}

class _BalancesState extends State<Balances> {
  //individual currency variables
  double? KES = 0.00;
  double? USD = 0.00;
  double? GBP = 0.00;
  double? EUR = 0.00;
  double? UGX = 0.00;
  double? TZS = 0.00;
  bool isloading = false;
  //load balances
  Future<void> checkBalances() async {
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
        var balanceData = data[0]["otherBalance"];
        for (var balance in balanceData) {
          if (balance['currencyCode'] == 'USD') {
            if (mounted) {
              setState(() {
                var bal = balance['balance'];
                USD = double.parse(bal.toString());
              });
            }
          }
          if (balance['currencyCode'] == 'GBP') {
            if (mounted) {
              setState(() {
                var bal = balance['balance'];
                GBP = double.parse(bal.toString());
              });
            }
          }
          if (balance['currencyCode'] == 'EUR') {
            if (mounted) {
              setState(() {
                var bal = balance['balance'];
                EUR = double.parse(bal.toString());
              });
            }
          }
          if (balance['currencyCode'] == 'KES') {
            if (mounted) {
              setState(() {
                var bal = balance['balance'];
                KES = double.parse(bal.toString());
              });
            }
          }
          if (balance['currencyCode'] == 'TZS') {
            if (mounted) {
              setState(() {
                var bal = balance['balance'];
                TZS = double.parse(bal.toString());
              });
            }
          }
          if (balance['currencyCode'] == 'UGX') {
            if (mounted) {
              setState(() {
                var bal = balance['balance'];
                UGX = double.parse(bal.toString());
              });
            }
          }
        }
      }
    } catch (e) {
      print(e);
    } finally {}
  }

  @override
  void initState() {
    setState(() {
      isloading = true;
    });
    checkBalances();
    setState(() {
      isloading = false;
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkBalances();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Currency Account Balances"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Card(
              shadowColor: Colors.grey,
              margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              color: const Color(0xFFFDF8EE),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Text("KES:"),
                title: Text(
                  KES.toString(),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: LightColor.navyBlue2),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              shadowColor: Colors.grey,
              margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              color: const Color(0xFFFDF8EE),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Text("USD:"),
                title: Text(
                  USD.toString(),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: LightColor.navyBlue2),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              shadowColor: Colors.grey,
              margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              color: const Color(0xFFFDF8EE),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Text("GBP:"),
                title: Text(
                  GBP.toString(),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: LightColor.navyBlue2),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              shadowColor: Colors.grey,
              margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              color: const Color(0xFFFDF8EE),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Text("EUR:"),
                title: Text(
                  EUR.toString(),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: LightColor.navyBlue2),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              shadowColor: Colors.grey,
              margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              color: const Color(0xFFFDF8EE),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Text("UGX:"),
                title: Text(
                  UGX.toString(),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: LightColor.navyBlue2),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              shadowColor: Colors.grey,
              margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              color: const Color(0xFFFDF8EE),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Text("TZS:"),
                title: Text(
                  TZS.toString(),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: LightColor.navyBlue2),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return Conversion();
                }));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 1,
                  decoration: const BoxDecoration(
                      color: const Color(0xFFCDA73B),
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
                            "Do Conversion",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
