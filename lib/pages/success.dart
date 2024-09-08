import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ThankYouPage extends StatefulWidget {
  const ThankYouPage(
      {Key? key,
      required this.title,
      required this.status,
      required this.recepient,
      required this.amount})
      : super(key: key);

  final String title;
  final String status;
  final String recepient;
  final String amount;

  @override
  State<ThankYouPage> createState() => _ThankYouPageState();
}

class _ThankYouPageState extends State<ThankYouPage> {
  double screenWidth = 600;
  double screenHeight = 400;
  Color textColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
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
                      "Your Transaction is protected.",
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
            child: Card(
              elevation: 10,
              child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFFDF8EE),
                    borderRadius: BorderRadius.circular(10)),
                height: MediaQuery.of(context).size.height / 1.8,
                width: MediaQuery.of(context).size.width / 1.2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      widget.status == "COMPLETED"
                          ? SvgPicture.asset(
                              'assets/money-tick-svgrepo-com 1.svg',
                            )
                          : widget.status == "PENDING"
                              ? SvgPicture.asset(
                                  'assets/money-time-svgrepo-com 1.svg',
                                )
                              : SvgPicture.asset(
                                  'assets/money-remove-svgrepo-com 1.svg',
                                ),
                      SizedBox(height: screenHeight * 0.01),
                      widget.status == "COMPLETED"
                          ? const Text(
                              "Your transaction is successful.",
                              style: TextStyle(color: Colors.green),
                            )
                          : widget.status == "PENDING"
                              ? const Text(
                                  "Your transaction is processing.",
                                  style: TextStyle(
                                    color: Color(0xFF2D2D2D),
                                  ),
                                )
                              : const Text(
                                  "Sorry your transaction failed. Please try again.",
                                  style: TextStyle(color: Colors.red),
                                ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Transaction Status :  ",
                          ),
                          Text(widget.status)
                        ],
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Amount :  ",
                          ),
                          Text(widget.amount,
                              style: TextStyle(
                                  color: widget.status == "COMPLETED"
                                      ? Colors.green
                                      : widget.status == "PENDING"
                                          ? const Color(0xFFCDA73B)
                                          : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                        ],
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Recepient :  ",
                          ),
                          Text(widget.recepient)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 1,
                decoration: const BoxDecoration(
                    color: const Color(0xFFCDA73B),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: const Center(
                  child: Text(
                    "Done",
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
    );
  }
}
