
import 'package:banktest/pages/welcomepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('myBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImpalaPOS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFFFDF8EE),
          textTheme: TextTheme(
            titleMedium: const TextStyle(
                fontFamily: "joel2", color: Color(0xFF2D2D2D), fontSize: 12),
            bodyLarge: const TextStyle(
              fontFamily: "joel2",
              color: Color(0xFF2D2D2D),
            ),

            titleLarge: GoogleFonts.actor(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF020087),
            ),
            bodyMedium: const TextStyle(
                fontFamily: "joel2", color: Color(0xFF2D2D2D), fontSize: 13),

            // GoogleFonts.poppins(
            //   color: Color(0xFF2D2D2D),
            //   fontSize: 15,
            //   fontWeight: FontWeight.w600,
            //   // color: Color(0x2D2D2D),
            // ),
            displaySmall: const TextStyle(
                fontFamily: "joel2",
                color: Color.fromARGB(255, 109, 108, 108),
                fontSize: 12),
            // bodySmall: GoogleFonts.merriweather(fontSize: 16),
          ),
          iconTheme: const IconThemeData(
            color: const Color(0xFFF0B90A),
          ), // Icon color
          appBarTheme: const AppBarTheme(color: Color(0xFFFDF8EE))),
      home: const IntroPage(),
    );
  }
}
