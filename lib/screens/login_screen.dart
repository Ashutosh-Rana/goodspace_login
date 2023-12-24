import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:goodspace_login/api_handler/network_handler.dart';
import 'package:goodspace_login/screens/otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController phoneController;
  late NetworkHandler networkHandler;
  Country? selectedCountry;
  String selectedCountryCode = "+91";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isOtpSending = false;
  int currentImageIndex = 0;
  List<String> imagePaths = [
    "assets/images/login_image.png",
    "assets/images/login_image2.png",
    "assets/images/login_image3.png",
  ];
  List<RichText> richTexts = [
    RichText(
      text: const TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: 'FIND ',
            style: TextStyle(color: Colors.grey, fontSize: 22),
          ),
          TextSpan(
            text: 'WORK ',
            style: TextStyle(
                color: Colors.blue, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: 'OPPORTUNITIES',
            style: TextStyle(color: Colors.grey, fontSize: 22),
          ),
        ],
      ),
    ),
    RichText(
      text: const TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: 'DISCOVER\n',
            style: TextStyle(color: Colors.grey, fontSize: 22),
          ),
          TextSpan(
            text: 'DREAM ',
            style: TextStyle(color: Colors.blue, fontSize: 32,fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: 'DIVE IN ',
            style: TextStyle(color: Colors.grey, fontSize: 22),
          ),
        ],
      ),
    ),
    RichText(
      text: const TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: 'EXPLORE MORE\n',
            style: TextStyle(color: Colors.grey, fontSize: 22),
          ),
          TextSpan(
            text: 'SETTLE ',
            style: TextStyle(color: Colors.blue, fontSize: 32,fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: 'FOR MORE',
            style: TextStyle(color: Colors.grey, fontSize: 22),
          ),
        ],
      ),
    )
  ];
  late PageController _pageController;

  void initState() {
    super.initState();
    phoneController = TextEditingController();
    networkHandler = NetworkHandler();
    _pageController = PageController();

    // Start a timer to change the image every 2 seconds
    Timer.periodic(Duration(seconds: 2), (timer) {
      // if (currentImageIndex < imagePaths.length - 1) {
      //   currentImageIndex++;
      // } else {
      //   currentImageIndex--;
      // }
      currentImageIndex++;
      currentImageIndex % 3 != 0
          ? _pageController.animateToPage(currentImageIndex % 3,
              duration: Duration(milliseconds: 500), curve: Curves.linear)
          : _pageController.jumpToPage(currentImageIndex % 3);
    });
  }

  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      // showPhoneCode: true,
      onSelect: (Country country) {
        setState(() {
          selectedCountry = country;
          selectedCountryCode = country.phoneCode;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 380,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: imagePaths.length,
                        onPageChanged: (index) {
                          setState(() {
                            currentImageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return FadeTransition(
                            opacity: AlwaysStoppedAnimation(1.0),
                            child: Column(
                              children:[ 
                                richTexts[index],
                                SizedBox(height: 64,),
                                Image.asset(
                                imagePaths[index],
                                fit: BoxFit.cover,
                              ),
                  ]),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 120,
                    ),
                    RichText(
                      text: const TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Please enter your phone number to sign in ',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          TextSpan(
                            text: 'GoodSpace ',
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                          TextSpan(
                            text: 'account',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors.black,
                          ),
                          color: Colors.grey.withOpacity(0.4)),
                      child: Row(
                        children: [
                          // Open country picker on left button click
                          GestureDetector(
                            onTap: _showCountryPicker,
                            child: Container(
                                child: Text(
                              selectedCountry?.flagEmoji ?? '🇮🇳',
                              style: TextStyle(fontSize: 30),
                            )),
                          ),
                          SizedBox(width: 8.0),
                          Container(
                            width: 2,
                            height: 30,
                            color: Colors.black,
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a valid phone number';
                                }
                                return null; // Return null if the validation is successful
                              },
                              decoration: InputDecoration(
                                hintText: 'Please enter mobile number',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    RichText(
                      text: const TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'You will receive a ',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          TextSpan(
                            text: '4 digit OTP',
                            style: TextStyle(color: Colors.blue, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 42,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isOtpSending = true;
                          });
                          bool res = await networkHandler.sendOTP(
                              "/api/d2/auth/v2/login",
                              phoneController.text,
                              selectedCountryCode);
                          if (res) {
                            // ignore: use_build_context_synchronously
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OTPScreen(
                                      phone: phoneController.text,
                                      countryCode: selectedCountryCode,
                                    ),
                                  ));
                            });
                          } else {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Invalid Phone"),
                            ));
                          }
                        }
                      },
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(0xff389FFF),
                            borderRadius: BorderRadius.circular(8)),
                        child: const Text(
                          "Get OTP",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
        isOtpSending
            ? Container(
                color: Colors.blue.withOpacity(0.1),
                child: Center(child: CircularProgressIndicator()))
            : Container()
      ]),
    );
  }
}
