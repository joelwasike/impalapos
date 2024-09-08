import 'dart:convert';
import 'package:banktest/model/color.dart';
import 'package:banktest/pages/auth/loginScreen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final firstNameControllerR = TextEditingController();
  final lastNameControllerR = TextEditingController();
  final emailAddressControllerR = TextEditingController();
  final passwordControllerR = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final referral = TextEditingController();
  var gender = "male";
  bool isLoading = false;
  bool obscureText = false;
  bool obscureText1 = false;
  bool obscureText2 = false;
  var result;
  var message;
  String? dropdownValue;
  var pincontroller = TextEditingController();
  bool validatefn = false;
  bool validateln = false;
  bool validateemail = false;
  bool validatephone = false;
  bool validateps = false;
  bool validatepn = false;
  bool validatecp = false;
  bool _acceptTerms = false;

  void termsconditions() async {
    const String facebookPageUrl =
        'https://impalapay.network/html/terms_and_conditions.html?location=website';

    await launchUrl(Uri.parse(facebookPageUrl));
  }

  Future<void> signIn() async {
    final Map<String, dynamic> body = {
      "name":
          "${firstNameControllerR.value.text} ${lastNameControllerR.value.text}",
      "email": emailAddressControllerR.value.text,
      "phone": "+${phoneController.text}",
      "password": passwordControllerR.value.text,
      "occupation": "ICT",
      "confirm_password": passwordControllerR.value.text,
      "country": "Kenya",
      "gender": "2",
      "toc": "1",
      "baseCurrency": dropdownValue,
      "pin": pincontroller.text,
      "referral": referral.text
    };

    try {
      setState(() {
        isLoading = true;
      });

      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer NWNlYjJmNTEzYzMyZTcxMGZmYmIxZDEyNTYxNjc5MTY="
      };

      final Uri url = Uri.parse(
          'https://www.sandbox.impalapay.com/api/?resource=user&action=create');

      final response =
          await http.post(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final Map data = jsonDecode(response.body);
        print("This is the data $data");
        message = data["message"];
        result = data["error"];
        if (!result) {
          // Successful registration, navigate to the login page

          Map<String, String> header = {
            "Content-Type": "application/json",
            "Authorization":
                "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2FuY2hvci5uYW5lc29mdC1sYWIuY29tL2F1dGgiLCJzdWIiOiJHREVSNkJUUzU2SDRVVFJJVlBRWURGRUI0RVFHSE5TNUtQRlhaWkxJRFJRRktHNDdCV1ZDM0JDUSIsImlhdCI6MTY5MTQ5MzYzMiwiZXhwIjoxNjkxNTgwMDMyLCJqdGkiOiI3MzhhNGQwMTMwYjA0MmFjMTBhMDhiYWUwZDk2NDJlNGFhM2U0MWVlNjFmZDczNGU4MTg1NTIyYWJmZDRkMjIxIiwiY2xpZW50X2RvbWFpbiI6ImRlbW8td2FsbGV0LXNlcnZlci5zdGVsbGFyLm9yZyJ9.hT5dXcGfC4gt-qpcZHroYjN05wsHNU1ioXFAhKNQGDw"
          };

          //send kyc number
          Map<String, String> body0 = {"phone": phoneController.text};

          var urlinkk =
              Uri.parse('https://rates-exchange.nanesoft-lab.com/post-phone/');
          var responseee = await http.post(urlinkk,
              headers: header, body: jsonEncode(body0));
          var mesoo = jsonDecode(responseee.body);
          print(mesoo);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Registration Successful. Please Log in.")),
          );
          //go to login
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const LoginPage();
          }));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Registration failed. Please try again later.")),
        );
      }
    } catch (error) {
      // Handle other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $error")),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  bool passwordconfirm() {
    if (passwordControllerR.text.trim() == passwordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    firstNameControllerR.dispose();
    lastNameControllerR.dispose();
    phoneController.dispose();
    emailAddressControllerR.dispose();
    passwordControllerR.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 9,
              ),
              //Hello again
              const Center(
                child: Text(
                  'Hello There!',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: LightColor.navyBlue2),
                ),
              ),
              const SizedBox(
                height: 0,
              ),
              const Center(
                child: Text(
                  'Register to ImpalaPay Wallet',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                      color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextField(
                      controller: firstNameControllerR,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        labelText: "first name.",
                        labelStyle: Theme.of(context).textTheme.displaySmall,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color:
                                  Colors.grey.withOpacity(0.4)), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 1,
                          color: Colors.grey,
                        )),
                      ),
                    ),
                  )),

              SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextField(
                      controller: lastNameControllerR,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        labelText: "last name.",
                        labelStyle: Theme.of(context).textTheme.displaySmall,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color:
                                  Colors.grey.withOpacity(0.4)), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 1,
                          color: Colors.grey,
                        )),
                      ),
                    ),
                  )),
              SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextField(
                      controller: emailAddressControllerR,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        labelText: "email.",
                        labelStyle: Theme.of(context).textTheme.displaySmall,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color:
                                  Colors.grey.withOpacity(0.4)), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 1,
                          color: Colors.grey,
                        )),
                      ),
                    ),
                  )),

              SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        labelText: "phone number 254...",
                        labelStyle: Theme.of(context).textTheme.displaySmall,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color:
                                  Colors.grey.withOpacity(0.4)), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 1,
                          color: Colors.grey,
                        )),
                      ),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 16),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  hint: Text(
                    'Select currency',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                  value: dropdownValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>["EUR", "GBP", "USD", "KES", "UGX", "TZS"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextField(
                      obscureText: obscureText,
                      controller: passwordController,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          child: Icon(
                            obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        prefixIcon: const Icon(
                          Icons.lock,
                        ),
                        labelText: "password.",
                        labelStyle: Theme.of(context).textTheme.displaySmall,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color:
                                  Colors.grey.withOpacity(0.4)), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 1,
                          color: Colors.grey,
                        )),
                      ),
                    ),
                  )),
              SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextField(
                      obscureText: obscureText2,
                      controller: passwordControllerR,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              obscureText2 = !obscureText2;
                            });
                          },
                          child: Icon(
                            obscureText2
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        prefixIcon: const Icon(
                          Icons.lock,
                        ),
                        labelText: "Confirm  password.",
                        labelStyle: Theme.of(context).textTheme.displaySmall,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color:
                                  Colors.grey.withOpacity(0.4)), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 1,
                          color: Colors.grey,
                        )),
                      ),
                    ),
                  )),
              SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextField(
                      obscureText: obscureText1,
                      controller: pincontroller,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              obscureText1 = !obscureText1;
                            });
                          },
                          child: Icon(
                            obscureText1
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        prefixIcon: const Icon(
                          Icons.dialpad,
                        ),
                        labelText: "Set your Impalapay pin (Four digits).",
                        labelStyle: Theme.of(context).textTheme.displaySmall,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color:
                                  Colors.grey.withOpacity(0.4)), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 1,
                          color: Colors.grey,
                        )),
                      ),
                      keyboardType: TextInputType.numberWithOptions(),
                    ),
                  )),
              SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextField(
                      obscureText: obscureText,
                      controller: referral,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        labelText: "referral code (optional)",
                        labelStyle: Theme.of(context).textTheme.displaySmall,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color:
                                  Colors.grey.withOpacity(0.4)), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 1,
                          color: Colors.grey,
                        )),
                      ),
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 16,
                  ),
                  Checkbox(
                    value: _acceptTerms,
                    onChanged: (bool? value) {
                      setState(() {
                        _acceptTerms = value ??
                            false; // Update _acceptTerms based on checkbox state
                        print(
                            '_acceptTerms: $_acceptTerms'); // Check the value of _acceptTerms
                      });
                    },
                  ),
                  const Text("I accept the "),
                  GestureDetector(
                    onTap: () {
                      termsconditions();
                    },
                    child: const Text(
                      'Terms and Conditions',
                      style: TextStyle(
                          fontSize: 16, decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      validateemail = emailAddressControllerR.text.isEmpty;
                      validatefn = firstNameControllerR.text.isEmpty;
                      validateln = lastNameControllerR.text.isEmpty;
                      validatepn = pincontroller.text.isEmpty;
                      validatephone = phoneController.text.isEmpty;
                      validateps = passwordController.text.isEmpty;
                      validatecp = passwordControllerR.text.isEmpty;
                    });
                    if (!validateemail &&
                        !validatefn &&
                        _acceptTerms == true &&
                        !validateln &&
                        !validatephone &&
                        !validatepn &&
                        !validateps) {
                      signIn();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please fill all fields")));
                    }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height / 18,
                    width: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                      color: LightColor.navyBlue2,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: isLoading
                        ? const SpinKitThreeBounce(
                            color: Colors.white,
                            size: 25,
                          )
                        : const Center(
                            child: Text(
                              'Create account',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return const LoginPage();
                })),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Have an account? ',
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
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
