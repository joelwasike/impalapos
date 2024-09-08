import 'package:banktest/model/color.dart';
import 'package:flutter/material.dart';

class Introbuttons extends StatefulWidget {
  final String? text;
  const Introbuttons({super.key, this.text});

  @override
  State<Introbuttons> createState() => _IntrobuttonsState();
}

class _IntrobuttonsState extends State<Introbuttons> {
  @override
  Widget build(BuildContext context) {
    var he = MediaQuery.of(context).size.height;
    var we = MediaQuery.of(context).size.width;

    return Container(
      height: he / 15,
      width: we / 1.1,
      decoration: BoxDecoration(
        color: LightColor.navyBlue2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          widget.text!,
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
