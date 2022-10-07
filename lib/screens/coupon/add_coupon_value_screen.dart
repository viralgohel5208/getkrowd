import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getkrowd/api/APIManager.dart';
import 'package:getkrowd/components/default_button.dart';
import 'package:getkrowd/components/default_textformfield.dart';
import 'package:getkrowd/constants/global_theming.dart';
import 'package:getkrowd/screens/BottomBar/BottomVC.dart';
import 'package:getkrowd/screens/ThankYouVC.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AddCouponValueScreen extends StatefulWidget {
  String scanType;
  String coupenUserId;
  AddCouponValueScreen(
      {Key? key, required this.scanType, required this.coupenUserId})
      : super(key: key);

  @override
  State<AddCouponValueScreen> createState() => _AddCouponValueScreenState();
}

class _AddCouponValueScreenState extends State<AddCouponValueScreen> {
  final dollarSpentController = TextEditingController();
  final numberOfPeopleController = TextEditingController();
  final tableNumberController = TextEditingController();
  String? selectedDineType = "";
  bool isLoading = false;
  var maskFormatter = MaskTextInputFormatter(
      mask: '##.##',
      initialText: "2.00",
      filter: {
        "#": RegExp(r'[0-9.]'),
      },
      type: MaskAutoCompletionType.lazy);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
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
                "Add Coupon Value",
                style: GoogleFonts.lato(
                  fontSize: 33,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            sizedBox20,
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Dollar Spent: ",
                    style: lato18Bold,
                  ),
                  DefaultTextField(
                    controller: dollarSpentController,
                    onChanged: (value) {},
                    hintText: "00.00",
                    textInputType: TextInputType.number,
                    inputParameters: [
                      LengthLimitingTextInputFormatter(6),
                      FilteringTextInputFormatter.digitsOnly,
                      maskFormatter
                      // maskFormatter
                    ],
                  ),
                  // lineDividerWithPadding,
                  // sizedBox10,
                  // Text(
                  //   "Number of People In Party: ",
                  //   style: lato18Bold,
                  // ),
                  // DefaultTextField(
                  //   controller: numberOfPeopleController,
                  //   textInputType: TextInputType.number,
                  // ),
                  // sizedBox10,
                  // Text(
                  //   "Dine Type",
                  //   style: lato18Bold,
                  // ),
                  // DefaultDropdownList(
                  //   selectedValue: selectedDineType ?? "",
                  //   itemList: ddlDineType,
                  //   onChanged: (String? value) {
                  //     setState(() {
                  //       selectedDineType = value;
                  //     });
                  //   },
                  // ),
                  // sizedBox15,
                  // Text(
                  //   "Table Number: ",
                  //   style: lato18Bold,
                  // ),
                  // DefaultTextField(
                  //   controller: tableNumberController,
                  //   textInputType: TextInputType.number,
                  //   textInputAction: TextInputAction.done,
                  // ),
                  lineDividerWithPadding,
                  sizedBox10,
                  isLoading
                      ? Center(
                          child: loadingIcon,
                        )
                      : DefaultButton(
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              isLoading = true;
                            });
                            String message = await APIManager.shared
                                .addCouponValue(dollarSpentController.text,
                                    widget.coupenUserId, widget.scanType);

                            print("message for add dollar:======$message");

                            if (message == "success") {
                              setState(() {
                                isLoading = false;
                              });

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ThankYouVC(),
                                ),
                              );

                              Future.delayed(
                                const Duration(seconds: 5),
                                () {
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);

                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BottomVC()));
                                },
                              );
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              showFlushbar(
                                  true, "Information", message, context, 3);
                            }
                          },
                          text: "Submit",
                          textStyle: lato24BoldWhite,
                          minimumSize: Size(width, 70),
                        ),
                  sizedBox20,
                  DefaultButton(
                    onTap: () => Navigator.pop(context),
                    text: "Cancel",
                    textStyle: lato24BoldWhite,
                    minimumSize: Size(width, 70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
