import 'package:flutter/material.dart';

class Failed extends StatefulWidget {
  const Failed({super.key});

  @override
  State<Failed> createState() => _SuccardState();
}

class _SuccardState extends State<Failed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(image: AssetImage("images/fail.jpg")),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Failed. Please check your balance or Card ",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
