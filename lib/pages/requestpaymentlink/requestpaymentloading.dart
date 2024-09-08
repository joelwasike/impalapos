import 'dart:convert';
import 'package:banktest/model/color.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:quickalert/quickalert.dart';

class Requestpaymentloading extends StatefulWidget {
  final Map response;
  const Requestpaymentloading({super.key, required this.response});

  @override
  State<Requestpaymentloading> createState() => _RequestpaymentloadingState();
}

class _RequestpaymentloadingState extends State<Requestpaymentloading> {
  bool isloading = false;
  Future fetchBen() async {
    print(widget.response);
    print(
      widget.response["paycode"],
    );
    print(
      widget.response["amount"],
    );
    setState(() {
      isloading = true;
    });
    try {
      var box = Hive.box('myBox');
      var phone = box.get("phone");

      Map<String, dynamic> body = {
        "payCode": widget.response["paycode"],
        "amount": widget.response["amount"],
        "phone": phone
      };
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer NWNlYjJmNTEzYzMyZTcxMGZmYmIxZDEyNTYxNjc5MTY="
      };
      final url = Uri.parse(
          'https://www.sandbox.impalapay.com/api/rs/transaction/at/pay_via_qr_store_pay_code');
      final response =
          await http.post(url, headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData["error"] == true) {
          QuickAlert.show(
            backgroundColor: const Color(0xFFFDF8EE),
            confirmBtnColor: LightColor.black,
            context: context,
            type: QuickAlertType.error,
            text: jsonData["message"],
          );
        } else {
          QuickAlert.show(
            backgroundColor: const Color(0xFFFDF8EE),
            confirmBtnColor: LightColor.black,
            context: context,
            type: QuickAlertType.success,
            text: "Payment Successful",
          );
        }
      } else {
        throw "";
      }
    } catch (e) {
      print(e);
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
    return Scaffold(
      body: isloading
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
    );
  }
}
