import 'package:flutter/material.dart';

class Succard extends StatefulWidget {
  final String amount;
  final String currency;

  const Succard({super.key, required this.amount, required this.currency});

  @override
  State<Succard> createState() => _SuccardState();
}

class _SuccardState extends State<Succard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(image: AssetImage("images/tick.png")),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Amount: ${widget.amount} ${widget.currency} ",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
