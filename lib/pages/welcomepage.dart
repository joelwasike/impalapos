import 'package:banktest/pages/auth/pin.dart';
import 'package:banktest/pages/intro/intro.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => const Intro()));
      try {
        await Hive.openBox('myBox');
        var box = Hive.box('myBox');

        if (box.isNotEmpty) {
          print(box.get('phone'));
          print(box.get('email'));
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const FilledRoundedPinPut()));
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Intro()));
        }
      } catch (error) {
        print('Error opening Hive box: $error');
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

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
          height: MediaQuery.of(context).size.height / 4.7,
        ),
        FadeInUp(
          duration: const Duration(milliseconds: 1000),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage('images/impala-removebg-preview.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
        FadeInUp(
          child: const Center(
              child: Text("Impalapay",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
        ),
        const Spacer(),
        FadeInUp(
          child: const Center(
              child: Text("Powered by Mamlaka Hub and spoke",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic))),
        ),
      ]),
    ));
  }
}
