import 'package:flutter/material.dart';

class Intro3 extends StatefulWidget {
  const Intro3({super.key});

  @override
  State<Intro3> createState() => _Intro3State();
}

class _Intro3State extends State<Intro3> {
  @override
  Widget build(BuildContext context) {
    var he = MediaQuery.of(context).size.height;
    var we = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "images/WhatsApp Image 2024-07-03 at 09.37.04.jpeg",
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black.withOpacity(.5)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.5, 1.0],
            ),
          ),
        ),
        Container(
          width: we,
          color: const Color(0xFFFDF8EE).withOpacity(0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: he / 10,
              ),
              Container(
                height: he / 2.4,
                width: we / 1.3,
                // Remove the image decoration from here
              ),
              SizedBox(
                height: he / 10,
              ),
              Center(
                child: Container(
                  height: he / 3,
                  width: we / 1.3,
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "Payment For Everything",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        Text(
                          "Easy and Secure",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: he / 25,
                        ),
                        Text(
                          "Make every payment smooth and\nSecure with our advanced technology",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
    // return Container(
    //   color: const Color(0xFFFDF8EE),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       SizedBox(
    //         height: he / 10,
    //       ),
    //       Container(height: he / 2.4, width: we / 1.3, child: Container()),
    //       SizedBox(
    //         height: he / 10,
    //       ),
    //       Container(
    //           height: he / 3,
    //           width: we / 1.3,
    //           child: Column(
    //             children: [
    //               Text(
    //                 "Paying for Everything is",
    //                 style: Theme.of(context).textTheme.bodyLarge,
    //               ),
    //               Text(
    //                 "Easy and Convenient",
    //                 style: Theme.of(context).textTheme.bodyLarge,
    //               ),
    //               SizedBox(
    //                 height: he / 25,
    //               ),
    //               Text(
    //                 "Make every payment smooth and",
    //                 style: Theme.of(context).textTheme.bodyMedium,
    //               ),
    //               Text(
    //                 "Secure with our advanced technology",
    //                 style: Theme.of(context).textTheme.bodyMedium,
    //               ),
    //             ],
    //           ))
    //     ],
    //   ),
    // );
  }
}
