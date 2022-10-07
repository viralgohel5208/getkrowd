import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:another_flushbar/flushbar.dart';

// Color Settings
var colorGreenPrimary = HexColor("#7fa518");
var colorGray = HexColor("#899499");

// Spaces / breakline settings
const sizedBox50 = SizedBox(
  height: 50,
);
const sizedBox40 = SizedBox(
  height: 40,
);
const sizedBox30 = SizedBox(
  height: 30,
);
const sizedBox20 = SizedBox(
  height: 20,
);
const sizedBox15 = SizedBox(
  height: 15,
);
const sizedBox10 = SizedBox(
  height: 10,
);
const sizedBox5 = SizedBox(
  height: 5,
);

// Fonts settings

var lato14Regular = GoogleFonts.lato(
  fontSize: 14,
);

var lato18Bold = GoogleFonts.lato(
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

var lato24BoldWhite = GoogleFonts.lato(
  fontSize: 24,
  fontWeight: FontWeight.w900,
  color: Colors.white,
);

// Hex code settings
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

showFlushbar(bool isError, String title, String message, BuildContext context,
    int seconds) {
  Flushbar(
    backgroundColor: isError ? Colors.red : Colors.green,
    icon: isError
        ? const Icon(
            Icons.error,
            color: Colors.black,
          )
        : const Icon(
            Icons.check,
            color: Colors.white,
          ),
    title: title,
    message: message,
    duration: Duration(seconds: seconds),
  ).show(context);
}

// Loading icon
var loadingIcon = const Center(
  child: CircularProgressIndicator(strokeWidth: 1),
);

// FractionallySizedBoxHeight
var heightFactor = 0.91;

const double kDefaultPadding = 16.0;

var lineDividerWithPadding = const PreferredSize(
  child: Padding(
    padding: EdgeInsets.only(top: 10, bottom: 10),
    child: Divider(
      color: Colors.grey,
      thickness: 1,
    ),
  ),
  preferredSize: Size.fromHeight(kDefaultPadding / 2),
);
