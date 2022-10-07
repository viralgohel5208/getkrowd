import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ModelManager {
  static final ModelManager _singleton = ModelManager._internal();
  factory ModelManager() => _singleton;
  static String domainURL = "https://adminapi.getkrowd.com/?";
  //String? serverURL;
  String? apiKey = "LIAzuq60iXGdzT3St599JQ";
  String? userName = "zrinity7380";
  String? passWord = "Y6t778T1iuo";
  String appUserId = "appUserId";

  ModelManager._internal() {
    // serverURL = domainURL + "";
  }

  static ModelManager get shared => _singleton;

  showCupertinoDialog(BuildContext context, String title, String subTitle,
      String successTxt, Function() onTapSuccess,
      {String? failTxt, Function()? onTapFail}) {
    showDialog(
      //barrierDismissible: false,
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          subTitle,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            textStyle: const TextStyle(color: Colors.red),
            isDefaultAction: true,
            onPressed: onTapSuccess,
            child: Text(successTxt),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: onTapFail ??
                () {
                  Navigator.pop(context);
                },
            child: Text(failTxt ?? "Cancel"),
          ),
        ],
      ),
    );
  }

  setRootView(Widget view) {
    runApp(
      MaterialApp(
        title: "Krowd",
        home: view,
        theme: ThemeData(
          //primaryColor: pale.appColor,
          //focusColor: AppTheme.black_800,
          // highlightColor: AppTheme.black_800,
          // fontFamily: AppTheme.rubik,
          primarySwatch: Colors.grey,
          //canvasColor: Colors.black,
          backgroundColor: Colors.white,
          accentColor: Colors.white,

          //  brightness: Brightness.dark, // or use Brightness.dark
          primaryColorBrightness: Brightness.dark,
          accentColorBrightness: Brightness.light,

          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            //backgroundColor: Palette.appColor,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            textTheme: TextTheme(
              headline6: TextStyle(
                //color: Palette.appColor,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        showPerformanceOverlay: false,
      ),
    );
  }
}
