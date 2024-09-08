import 'package:banktest/pages/pos/printer.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:banktest/pages/success.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Widget_Card extends StatefulWidget {
  final IconData icon;
  final String phone;
  final String kind;
  final String amount;
  final String time;
  final String status;
  final String date;

  const Widget_Card({
    Key? key,
    required this.icon,
    required this.phone,
    required this.kind,
    required this.amount,
    required this.time,
    required this.status,
    required this.date,
  }) : super(key: key);

  @override
  State<Widget_Card> createState() => _Widget_CardState();
}

class _Widget_CardState extends State<Widget_Card> {
 // final PrintService _printService = PrintService();

  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ThankYouPage(
            title: widget.phone,
            status: widget.status,
            amount: widget.amount,
            recepient: widget.phone,
          );
        }));
      },
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          height: MediaQuery.of(context).size.height / 6,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText(
                      style: TextStyle(fontFamily: "joel2", fontSize: 12),
                      widget.phone,
                      minFontSize: 12,
                      maxFontSize: 20,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AutoSizeText(
                      style: TextStyle(fontFamily: "joel2", fontSize: 12),
                      widget.amount,
                      minFontSize: 12,
                      maxFontSize: 20,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                AutoSizeText(
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  widget.date,
                  minFontSize: 12,
                  maxFontSize: 20,
                  overflow: TextOverflow.ellipsis,
                ),
                AutoSizeText(
                  style:
                      widget.time == "COMPLETED" || widget.time == "successful"
                          ? const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.normal,
                              fontSize: 12)
                          : widget.time == "PENDING"
                              ? const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12)
                              : const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12),
                  "${widget.kind.toUpperCase()}  ${widget.time}",
                  minFontSize: 12,
                  maxFontSize: 20,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // _printService.printReceipt(
                        //   action: "${widget.kind.toUpperCase()} ${widget.time}",
                        //   amount: widget.amount,
                        //   time: widget.date,
                        //   phone: widget.phone,
                        // );
                      },
                      child: Container(
                        height: he / 20,
                        width: we / 3,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B1B1B),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Print Receipt",
                            style: TextStyle(
                              color: const Color(0xFFCDA73B),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}