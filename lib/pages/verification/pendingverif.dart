import 'package:flutter/material.dart';

class PVerification extends StatefulWidget {
  const PVerification({super.key});

  @override
  State<PVerification> createState() => _PVerificationState();
}

class _PVerificationState extends State<PVerification> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timer,
              color: Colors.blue,
              size: 60,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Your verification is on progress ... ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
