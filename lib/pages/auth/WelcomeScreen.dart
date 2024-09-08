import 'package:banktest/model/color.dart';
import 'package:banktest/pages/auth/regScreen.dart';
import 'package:flutter/material.dart';

import 'loginScreen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          const Color(0xFFFDF8EE),
          const Color(0xFFFDF8EE),
        ])),
        child: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
          ),
          const SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            child: Container(
              height: 53,
              width: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: LightColor.navyBlue2),
              ),
              child: const Center(
                child: Text(
                  'SIGN IN',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: LightColor.navyBlue2,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterPage()));
            },
            child: Container(
              height: 53,
              width: 320,
              decoration: BoxDecoration(
                color: LightColor.navyBlue2,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: LightColor.navyBlue2,
                ),
              ),
              child: const Center(
                child: Text(
                  'SIGN UP',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFDF8EE),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
