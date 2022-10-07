import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:getkrowd/api/APIManager.dart';
import 'package:getkrowd/constants/global_theming.dart';
import 'package:getkrowd/screens/BottomBar/BottomVC.dart';
import 'package:getkrowd/screens/ThankYouVC.dart';
import 'package:getkrowd/screens/coupon/add_coupon_value_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:http/http.dart';
import 'package:just_audio/just_audio.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  MobileScannerController scannerController = MobileScannerController();

  ScanResult? scanResult;

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Barcode Scanner'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            sizedBox50,
            Container(
              height: 40,
              width: width,
              color: colorGray,
              child: Text(
                "Scan Barcode",
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
            SizedBox(
              height: 350,
              width: 500,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(35, 20, 35, 20),
                    child: MobileScanner(
                      controller: scannerController,
                      allowDuplicates: false,
                      onDetect: (barcode, args) async {
                        if (barcode.rawValue == null) {
                          debugPrint('Failed to scan Barcode');
                        } else {
                          final String? code = barcode.rawValue;
                          Response res = await APIManager.shared
                              .checkScanQRCode(code ?? "");

                          Map<String, dynamic> responseBody =
                              jsonDecode(res.body);
                          var result = responseBody["Response"];
                          var statusCode = result[0]["Status"];
                          var message = result[0]["Message"];

                          if (statusCode == "200") {
                            var nextstape = result[0]["nextStep"];

                            if (nextstape == "none") {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ThankYouVC(),
                                ),
                              );

                              Future.delayed(const Duration(seconds: 5), () {
                                scannerController.dispose();
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const BottomVC()));
                              });
                            } else {
                              print(
                                  "result===============================================================================================================$result");
                              var scaneType = result[0]["scanType"];
                              var coupenUserId = result[0]["couponUserId"];

                              Future.delayed(const Duration(seconds: 0), () {
                                scannerController.dispose();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => AddCouponValueScreen(
                                      scanType: scaneType ?? "",
                                      coupenUserId: coupenUserId ?? "",
                                    ),
                                  ),
                                );
                              });
                            }
                          } else if (statusCode == "400") {
                            print("code already scan==============");

                            final player = AudioPlayer();
                            await player.setAsset('assets/audio/myAudio.mp3');
                            player.play();

                            await showFlushbar(
                              true,
                              "Invalid Coupon",
                              message ?? "Coupon has already been used.",
                              context,
                              5,
                            );
                          } else {}
                        }
                      },
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: SizedBox(
                      width: 500,
                      height: 350,
                      child: Image.asset("assets/icons/border.png"),
                    ),
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
