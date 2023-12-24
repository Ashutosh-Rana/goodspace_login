import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:goodspace_login/api_handler/network_handler.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  final String countryCode;

  const OTPScreen({super.key, required this.phone, required this.countryCode});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  List<TextEditingController> otpControllers =
      List.generate(4, (index) => TextEditingController());
  String enteredOTP = '';
  List<bool> isDigitEntered = List.generate(4, (index) => false);
  late NetworkHandler networkHandler;
  bool isOtpIncorrect = false;

  void initState() {
    super.initState();
    networkHandler = NetworkHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/login_screen_route");
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey,
                  ),
                  Spacer(),
                  Text(
                    "Edit Phone number",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.edit, color: Colors.grey)
                ],
              ),
            ),
            SizedBox(
              height: 88,
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'OTP sent to ${widget.countryCode} ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: widget.phone,
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Text(
              "Enter OTP to confirm your phone",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "You’ll receive a four digit verification code. ",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                4,
                (index) => Container(
                  margin: EdgeInsets.only(right: 24.0),
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: isOtpIncorrect
                          ? Colors.white
                          : isDigitEntered[index]
                              ? Colors.blue
                              : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: isOtpIncorrect ? Colors.red : Colors.blue)),
                  child: TextField(
                    controller: otpControllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(color:isOtpIncorrect? Colors.red: Colors.white, fontSize: 18),
                    maxLength: 1,
                    onChanged: (value) {
                      setState(() {
                        isDigitEntered[index] = value.isNotEmpty;
                      });
                      if (value.length == 1) {
                        if (index < 3) {
                          FocusScope.of(context).nextFocus();
                        } else {
                          FocusScope.of(context).requestFocus(
                            FocusNode(),
                          ); 
                          FocusScope.of(context)
                              .previousFocus();
                        }
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context).previousFocus();
                      }
                    },
                    onSubmitted: (value) {
                      // When Enter is pressed, move focus to the next box
                      if (index < 3) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    decoration: const InputDecoration(
                        counterText: '', // Hide the character counter
                        
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 6)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            isOtpIncorrect
                ? const Text(
                    "Please enter correct OTP",
                    style: TextStyle(color: Colors.red),
                  )
                : RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "Didn't receive OTP? ",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        TextSpan(
                            text: 'Resend',
                            style: TextStyle(color: Colors.blue, fontSize: 14),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                await networkHandler.sendOTP(
                                    "/api/d2/auth/v2/login",
                                    widget.phone,
                                    widget.countryCode);
                              }),
                      ],
                    ),
                  ),
            Expanded(
              child: SizedBox.expand(),
            ),
            GestureDetector(
              onTap: () async {
                enteredOTP =
                    otpControllers.map((controller) => controller.text).join();
                bool res = await networkHandler.confirmOTP(
                    "/api/d2/auth/verifyotp", widget.phone, enteredOTP);
                if (res) {
                  Navigator.pushNamed(context, "/home_screen_route");
                } else {
                  setState(() {
                    isOtpIncorrect = true;
                  });
                  // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  //   content: Text("Wrong OTP"),
                  // ));
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
                  "Verify Phone",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
