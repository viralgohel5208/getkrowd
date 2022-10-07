import 'package:flutter/material.dart';
import 'package:getkrowd/api/APIManager.dart';
import 'package:getkrowd/components/default_button.dart';
import 'package:getkrowd/components/default_textformfield.dart';
import 'package:getkrowd/constants/global_theming.dart';
import 'package:getkrowd/screens/BottomBar/BottomVC.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isInit = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: isInit
          ? loadingIcon
          : SafeArea(
              minimum: const EdgeInsets.all(5),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sizedBox50,
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        color: colorGray,
                        child: Text(
                          "Login",
                          style: GoogleFonts.lato(
                            fontSize: 33,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      Text(
                        "Email Address:",
                        style: lato18Bold,
                      ),
                      DefaultTextField(
                        controller: emailController,
                      ),
                      sizedBox30,
                      Text(
                        "Password:",
                        style: lato18Bold,
                      ),
                      DefaultTextField(
                        obscureText: true,
                        controller: passwordController,
                      ),
                      lineDividerWithPadding,
                      sizedBox10,
                      isInit
                          ? Center(
                              child: loadingIcon,
                            )
                          : DefaultButton(
                              onTap: () async {
                                setState(() {
                                  isInit = true;
                                });
                                bool isSuccess = await APIManager.shared.login(
                                  emailController.text,
                                  passwordController.text,
                                );
                                if (isSuccess == true) {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString(
                                      'email', emailController.text);
                                  await prefs.setString(
                                      'pass', passwordController.text);
                                  await prefs.setBool('isLogin', true);

                                  setState(() {
                                    isInit = false;
                                  });

                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const BottomVC()),
                                    (Route<dynamic> route) => false,
                                  );
                                } else {
                                  setState(() {
                                    isInit = false;
                                  });

                                  showFlushbar(true, "Information",
                                      "Not Authenticated", context, 3);
                                }
                              },
                              text: "Login",
                              textStyle: lato24BoldWhite,
                              minimumSize: Size(width, 70),
                            ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
