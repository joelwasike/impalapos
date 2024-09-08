import 'package:animate_do/animate_do.dart';
import 'package:banktest/pages/widget_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  List transactions = [];
  bool isLoading = false;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Color(0xFFFDF8EE),
        iconTheme: const IconThemeData(),
        elevation: 0,
        actions: [
          FadeIn(
            delay: const Duration(seconds: 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 10,
                ),
                const Text(
                  "Impalapay Statements",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
              ],
            ),
          )
        ],
      ),
      body: FadeIn(
        delay: Duration.zero,
        child: isLoading
            ? const SpinKitThreeBounce(
                color: Color(0xFF020087),
                size: 25,
              )
            : ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return Widget_Card(
                    date: transaction.dateAdded!,
                    kind: transaction.recipientName!,
                    icon: FontAwesomeIcons
                        .person, // Change this to the appropriate icon based on transaction kind
                    amount:
                        "- ${"${transaction.amount} ${transaction.sendingCurrency!}"}",
                    time: transaction
                        .transactionStatus!, // You can use a formatted date-time here
                    phone: transaction.recipientPhone ?? "",
                    status: transaction
                        .transactionStatus!, // Use an empty string if phone is null
                  );
                },
              ),
      ),
    );
  }
}
