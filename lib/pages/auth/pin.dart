import 'package:banktest/model/color.dart';
import 'package:banktest/pages/auth/loginScreen.dart';
import 'package:banktest/pages/homemain.dart';
import 'package:banktest/pages/verification/verificationpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pinput/pinput.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class FilledRoundedPinPut extends StatefulWidget {
  const FilledRoundedPinPut({Key? key}) : super(key: key);

  @override
  _FilledRoundedPinPutState createState() => _FilledRoundedPinPutState();

  @override
  String toStringShort() => 'Rounded Filled';
}

class _FilledRoundedPinPutState extends State<FilledRoundedPinPut> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  bool showError = false;
  bool isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const length = 4;
    const borderColor = Color.fromRGBO(114, 178, 238, 1);
    const errorColor = Color.fromRGBO(255, 234, 238, 1);
    const fillColor = Color.fromRGBO(222, 231, 240, .57);
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: GoogleFonts.poppins(
        fontSize: 22,
        color: const Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            " Enter pin to log in",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 7,
              ),
              SizedBox(
                height: 68,
                child: isloading
                    ? const Padding(
                        padding: EdgeInsets.only(left: 120, right: 150),
                        child: SpinKitThreeBounce(
                          color: LightColor.navyBlue1,
                          size: 35,
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 14),
                        child: Pinput(
                          length: length,
                          controller: controller,
                          focusNode: focusNode,
                          defaultPinTheme: defaultPinTheme,
                          onCompleted: (pin) async {
                            Future<Map<String, dynamic>> checkPin() async {
                              setState(() {
                                isloading = true;
                              });
                              try {
                                var box = Hive.box('myBox');
                                var phone = box.get("phone");
                                final data = {"phone": phone, "pin": pin};

                                // Encode the JSON data
                                final jsonPayload = json.encode(data);
                                final url = Uri.parse(
                                    'https://www.sandbox.impalapay.com/api/?resource=user&action=verifyPin');
                                // Define the HTTP request headers
                                final headers = {
                                  "Content-Type": "application/json",
                                  "Authorization":
                                      "Bearer NWNlYjJmNTEzYzMyZTcxMGZmYmIxZDEyNTYxNjc5MTY="
                                };
                                // Send the HTTP POST request with the JSON payload
                                final response = await http.post(url,
                                    headers: headers, body: jsonPayload);
                                // Decode the response JSON
                                final responseData = json.decode(response.body);
                                print(responseData);
                                if (responseData["error"] == false) {
                                  var kyclink =
                                      "https://rates-exchange.nanesoft-lab.com/chek/kyc-status/?phone=$phone";
                                  var jsonResponse =
                                      await http.get(Uri.parse(kyclink));
                                  var kycbody = jsonDecode(jsonResponse.body);
                                  var actions = kycbody['Actions'];
                                  print(kycbody);
                                  print(actions);
                                  if (actions == null) {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const Verification(
                                          data:
                                              "https://links.usesmileid.com/6482/1667ecc2-02d9-422b-b7a3-a833709e8e22");
                                      // return Verification(data: data["url"]);
                                    }));
                                  } else {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const Homemain();
                                    }));
                                    // ignore: use_build_context_synchronously
                                  }
                                } else {
                                  QuickAlert.show(
                                    backgroundColor: const Color(0xFFFDF8EE),
                                    confirmBtnColor: LightColor.black,
                                    context: context,
                                    type: QuickAlertType.error,
                                    text: 'Check your pin and try again!',
                                  );
                                  // var message = "Pin error";
                                  // var snackBar = SnackBar(
                                  //   content: Text(message),
                                  // );
                                  // ScaffoldMessenger.of(context)
                                  //     .showSnackBar(snackBar);
                                  // Navigator.push(context,
                                  //     MaterialPageRoute(builder: (context) {
                                  //   return const FilledRoundedPinPut();
                                  // }));
                                }

                                return responseData;
                              } catch (e) {
                                print(e);
                                var message = "Check your internet connection";
                                var snackBar = SnackBar(
                                  content: Text(message),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                rethrow;
                              } finally {
                                setState(() {
                                  isloading = false;
                                });
                              }
                            }

                            await checkPin();

                            // print(pin);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => Loadpage(
                            //               pin: pin,
                            //             )));
                          },
                          focusedPinTheme: defaultPinTheme.copyWith(
                            height: 68,
                            width: 64,
                            decoration: defaultPinTheme.decoration!.copyWith(
                              border: Border.all(color: borderColor),
                            ),
                          ),
                          errorPinTheme: defaultPinTheme.copyWith(
                            decoration: BoxDecoration(
                              color: errorColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const LoginPage();
            })),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Go to login page? ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                GestureDetector(
                  child: const Text(
                    'Log in now',
                    style: TextStyle(
                        color: LightColor.navyBlue2,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
