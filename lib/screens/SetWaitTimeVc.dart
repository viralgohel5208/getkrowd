import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:getkrowd/api/APIManager.dart';
import 'package:http/http.dart';
import 'package:getkrowd/components/default_textformfield.dart';
import 'package:getkrowd/constants/global_theming.dart';

class SetWaitTimeVc extends StatefulWidget {
  String time;
  SetWaitTimeVc({Key? key, required this.time}) : super(key: key);

  @override
  State<SetWaitTimeVc> createState() => _SetWaitTimeVcState();
}

class _SetWaitTimeVcState extends State<SetWaitTimeVc> {
  final timeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Change Wait Time'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(5),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Current Wait Time: ${widget.time} minuts",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Change Wait Time",
                    style: lato18Bold,
                  ),
                  DefaultTextField(
                    hintText: "Enter Time",
                    controller: timeController,
                  ),
                  sizedBox30,
                  ElevatedButton(
                    onPressed: () async {
                      if (timeController.text.isNotEmpty) {
                        Response res = await APIManager.shared
                            .setWaitTime(context, timeController.text);

                        print(res.body);

                        var body = jsonDecode(res.body);
                        print("Sort Number body = $body");

                        var response = body['Response'];
                        print("Sort Number Response = $response");

                        var status = response[0]['Status'];
                        print("Sort Number Status = $status");

                        var msg = response[0]['Message'];

                        if (status == "200") {
                          Navigator.of(context).pop();
                          showFlushbar(false, "Success", msg, context, 4);
                        } else {
                          showFlushbar(true, "Fail", msg, context, 4);
                        }
                      } else {
                        showFlushbar(
                            true, "Error!", "Please Enter Time", context, 4);
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
