import 'package:banktest/model/color.dart';
import 'package:banktest/pages/auth/loginScreen.dart';
import 'package:banktest/pages/intro/intro1.dart';
import 'package:banktest/pages/intro/intro2.dart';
import 'package:banktest/pages/intro/intro3.dart';
import 'package:banktest/pages/settings/widgets/introbuttons.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  PageController controller = PageController();
  bool onlastpage = false;
  @override
  Widget build(BuildContext context) {
    var he = MediaQuery.of(context).size.height;
    var we = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                onlastpage = (index == 2);
              });
            },
            children: [const Intro1(), const Intro2(), const Intro3()],
          ),
          Container(
              alignment: const Alignment(0, 0.15),
              child: SmoothPageIndicator(
                  controller: controller,
                  count: 3,
                  axisDirection: Axis.horizontal,
                  effect: const ExpandingDotsEffect(
                      dotColor: const Color(0xFFF0B90A),
                      activeDotColor: LightColor.navyBlue2,
                      dotHeight: 7,
                      dotWidth: 11,
                      radius: 20.0))),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              onlastpage
                  ? Center(
                      child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.bottomToTop,
                                child: const LoginPage()));
                      },
                      child: const Introbuttons(
                        text: "Done",
                      ),
                    ))
                  : Center(
                      child: GestureDetector(
                      onTap: () {
                        controller.nextPage(
                            duration: const Duration(microseconds: 500),
                            curve: Curves.linear);
                      },
                      child: const Introbuttons(
                        text: "Next",
                      ),
                    )),
              SizedBox(
                height: he / 16,
              )
            ],
          )
        ],
      ),
    );
  }
}
