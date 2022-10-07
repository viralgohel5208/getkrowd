import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:getkrowd/api/ModelManager.dart';
import 'package:getkrowd/constants/global_constants.dart';
import 'package:getkrowd/constants/global_theming.dart';
import 'package:getkrowd/models/WaitListModel.dart';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIManager {
  static final APIManager _singleton = APIManager._internal();
  factory APIManager() => _singleton;

  APIManager._internal();

  static APIManager get shared => _singleton;

  //Login API

  Future<bool> login(String email, String password) async {
    var url = Uri.parse(postLoginEndpoint +
        "&merchantEmailAddress=$email&merchantPassWord=$password");

    try {
      final ioc = HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);
      var response = await http.post(
        url,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        var result = responseBody["Response"];
        var statusCode = result[0]["Status"];
        var message = result[0]["Message"];

        print("login result:====$result");
        print("login status code:===$statusCode");
        print("login message:===$message");

        if (statusCode == "200" && message == "User Authenticated") {
          var prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLogin', true);

          // User user = User();
          // user.userId = result[0]["userId"];
          // user.companyId = result[0]["companyId"];
          // user.pointsId = result[0]["pointsId"];
          // user.authToken = result[0]["authToken"];
          //saveToUserProvider(ref, user);

          var compId = result[0]["companyId"];

          await prefs.setString("companyId", compId);
          await prefs.setString('email', email);
          await prefs.setString('pass', password);

          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (ex) {
      print("error issue:========$ex");
      return false;
    }
  }

  //Scan APIs

  Future checkScanQRCode(String qrCodeValue) async {
    if (qrCodeValue != "") {
      var prefs = await SharedPreferences.getInstance();
      var companyId = prefs.getString("companyId");

      var url = Uri.parse(
        qrCodeValue +
            "&apikey=${ModelManager.shared.apiKey}&userName=${ModelManager.shared.userName}&passWord=${ModelManager.shared.passWord}&userId=$companyId",
      );

      print(url);

      final ioc = HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);

      var response = await http.get(
        url,
        headers: {
          // 'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        var result = responseBody["Response"];
        var statusCode = result[0]["Status"];
        var message = result[0]["Message"];

        if (statusCode == "200") {
          return response;
        } else {
          return response;
        }
      } else {
        return "400";
      }
    } else {
      return "400";
    }
  }

  Future<String> addCouponValue(
      String dollarSpent, String couponUserId, String scanType) async {
    // final scan = ref.watch(scanProvider);
    // final user = ref.watch(userProvider);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var companyId = prefs.getString("companyId");

    var message = "";
    var url = Uri.parse(postAddCouponValue +
        "&couponValue=$dollarSpent&couponUserId=$dollarSpent&placeId=$companyId&scantype=$scanType");

    print("add doller value url :===$url");

    final ioc = HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = IOClient(ioc);

    var response = await http.get(
      url,
      headers: {
        // 'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      var result = responseBody["Response"];
      var statusCode = result[0]["Status"];

      if (statusCode == "200") {
        message = result[0]["message"];
      } else if (statusCode == "400") {
        message = result[0]["Message"];
      }

      if (statusCode == "200") {
        return "success";
      } else {
        return message;
      }
    } else {
      print(response.body);
      message = "Something went wrong. Please try again";
      return message;
    }
  }

  //Wait lists APIs

  Future getCurrentWaitTime(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final ioc = HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyId = prefs.getString("companyId");

      var res = await http.get(
        Uri.parse(
            '${ModelManager.domainURL}method=getCurrentWaitTime&apiKey=${ModelManager.shared.apiKey}&userName=${ModelManager.shared.userName}&passWord=${ModelManager.shared.passWord}&companyId=$companyId'),
      );
      print("res status = ${res.statusCode}");
      print("res body = ${res.body}");

      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        print("Wait List body = $body");

        var response = body['Response'];
        print("Wait List Response = $response");

        var status = response[0]['Status'];
        print("Wait List Status = $status");

        var time = response[0]['waitTimne'];
        print("Wait List Data = $time");

        return time;
      } else {
        return showFlushbar(
            true, "Error", "Unable to retrieve data", context, 4);
      }
    } else {
      return showFlushbar(
          true, "Error", "Check your network connection", context, 4);
    }
  }

  Future getWaitList(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final ioc = HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyId = prefs.getString("companyId");

      print("Company Id: $companyId");

      var res = await http.get(
        Uri.parse(
            '${ModelManager.domainURL}method=getWaitList&apiKey=${ModelManager.shared.apiKey}&userName=${ModelManager.shared.userName}&passWord=${ModelManager.shared.passWord}&companyId=$companyId'),
      );

      print("res status = ${res.statusCode}");
      print("res body = ${res.body}");

      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        print("Wait List body = $body");

        var response = body['Response'];
        print("Wait List Response = $response");

        var status = response[0]['Status'];
        print("Wait List Status = $status");

        if (status == "200") {
          var data = response[0]['data'];
          print("Wait List Data = $data");

          List<WaitListModel> waitList =
              (data as List).map((d) => WaitListModel.fromJson(d)).toList();
          print("Wait List Array = $waitList");

          return waitList;
        } else if (status == "400") {
          var msg = response[0]['Message'];
          return showFlushbar(true, "Error", msg, context, 4);
        } else {
          return showFlushbar(true, "Error", "Somthing went wrong", context, 4);
        }
      } else {
        return showFlushbar(
            true, "Error", "Unable to retrieve data", context, 4);
      }
    } else {
      return showFlushbar(
          true, "Error", "Check your network connection", context, 4);
    }
  }

  Future getWaitListSortNumber(
      BuildContext context, String numberSeated) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final ioc = HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyId = prefs.getString("companyId");

      var res = await http.get(
        Uri.parse(
            '${ModelManager.domainURL}method=getWaitListSortNumber&apiKey=${ModelManager.shared.apiKey}&userName=${ModelManager.shared.userName}&passWord=${ModelManager.shared.passWord}&companyId=$companyId&numberSeated=$numberSeated'),
      );

      print("Sort Number status = ${res.statusCode}");
      print("Sort Number body = ${res.body}");

      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        print("Sort Number body = $body");

        var response = body['Response'];
        print("Sort Number Response = $response");

        var status = response[0]['Status'];
        print("Sort Number Status = $status");

        var data = response[0]['data'];
        print("Sort Number Data = $data");

        List<WaitListModel> waitListSort =
            (data as List).map((d) => WaitListModel.fromJson(d)).toList();
        print("Sort Number Array = $waitListSort");

        return waitListSort;
      } else {
        return showFlushbar(
            true, "Error", "Unable to retrieve data", context, 4);
      }
    } else {
      return showFlushbar(
          true, "Error", "Check your network connection", context, 4);
    }
  }

  Future checkInWaitList(BuildContext context, String waitId) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final ioc = HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyId = prefs.getString("companyId");

      var res = await http.get(
        Uri.parse(
            '${ModelManager.domainURL}method=checkInWaitList&apiKey=${ModelManager.shared.apiKey}&userName=${ModelManager.shared.userName}&passWord=${ModelManager.shared.passWord}&companyId=$companyId&waitId=$waitId'),
      );

      print(res.statusCode);
      print(res.body);

      if (res.statusCode == 200) {
        return res;
      } else {
        return showFlushbar(
            true, "Error", "Unable to retrieve data", context, 4);
      }
    } else {
      return showFlushbar(
          true, "Error", "Check your network connection", context, 4);
    }
  }

  Future waitListSeatCustomer(BuildContext context, String waitId) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final ioc = HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyId = prefs.getString("companyId");

      var res = await http.get(
        Uri.parse(
            '${ModelManager.domainURL}method=waitListSeatCustomer&apiKey=${ModelManager.shared.apiKey}&userName=${ModelManager.shared.userName}&passWord=${ModelManager.shared.passWord}&companyId=$companyId&waitId=$waitId'),
      );

      print(res.statusCode);
      print(res.body);

      if (res.statusCode == 200) {
        return res;
      } else {
        return showFlushbar(
            true, "Error", "Unable to retrieve data", context, 4);
      }
    } else {
      return showFlushbar(
          true, "Error", "Check your network connection", context, 4);
    }
  }

  Future setWaitTime(BuildContext context, String waitTime) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final ioc = HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyId = prefs.getString("companyId");

      print("company id:=== $companyId");

      var res = await http.get(
        Uri.parse(
            '${ModelManager.domainURL}method=setWaitTime&apiKey=${ModelManager.shared.apiKey}&userName=${ModelManager.shared.userName}&passWord=${ModelManager.shared.passWord}&companyId=$companyId&waitTime=$waitTime'),
      );

      print(res.statusCode);
      print(res.body);

      if (res.statusCode == 200) {
        return res;
      } else {
        return showFlushbar(
            true, "Error", "Unable to retrieve data", context, 4);
      }
    } else {
      return showFlushbar(
          true, "Error", "Check your network connection", context, 4);
    }
  }

  Future getWaitListPageCustomer(BuildContext context, String waitId) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final ioc = HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyId = prefs.getString("companyId");

      var res = await http.get(
        Uri.parse(
            '${ModelManager.domainURL}method=getWaitListPageCustomer&apiKey=${ModelManager.shared.apiKey}&userName=${ModelManager.shared.userName}&passWord=${ModelManager.shared.passWord}&companyId=$companyId&waitId=$waitId'),
      );

      print(res.statusCode);
      print(res.body);

      if (res.statusCode == 200) {
        return res;
      } else {
        return showFlushbar(
            true, "Error", "Unable to retrieve data", context, 4);
      }
    } else {
      return showFlushbar(
          true, "Error", "Check your network connection", context, 4);
    }
  }

  Future getWaitListFinalText(BuildContext context, String waitId) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final ioc = HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyId = prefs.getString("companyId");

      var res = await http.get(
        Uri.parse(
            '${ModelManager.domainURL}method=waitListFinalText&apiKey=${ModelManager.shared.apiKey}&userName=${ModelManager.shared.userName}&passWord=${ModelManager.shared.passWord}&companyId=$companyId&waitId=$waitId'),
      );

      print(res.statusCode);
      print(res.body);

      if (res.statusCode == 200) {
        return res;
      } else {
        return showFlushbar(
            true, "Error", "Unable to retrieve data", context, 4);
      }
    } else {
      return showFlushbar(
          true, "Error", "Check your network connection", context, 4);
    }
  }

  Future cancelWaitList(BuildContext context, String waitId) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyId = prefs.getString("companyId");

      final ioc = HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);
      var res = await http.get(
        Uri.parse(
            '${ModelManager.domainURL}method=cancelWaitList&apiKey=${ModelManager.shared.apiKey}&userName=${ModelManager.shared.userName}&passWord=${ModelManager.shared.passWord}&companyId=$companyId&waitId=$waitId'),
      );

      print(res.statusCode);
      print(res.body);

      if (res.statusCode == 200) {
        return res;
      } else {
        return showFlushbar(
            true, "Error", "Unable to retrieve data", context, 4);
      }
    } else {
      return showFlushbar(
          true, "Error", "Check your network connection", context, 4);
    }
  }
}
