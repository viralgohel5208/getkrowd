import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:getkrowd/api/APIManager.dart';
import 'package:getkrowd/api/ModelManager.dart';
import 'package:getkrowd/constants/global_theming.dart';
import 'package:getkrowd/models/WaitListModel.dart';
import 'package:getkrowd/screens/SetWaitTimeVc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart';

class WaitListVC extends StatefulWidget {
  const WaitListVC({Key? key}) : super(key: key);

  @override
  State<WaitListVC> createState() => _WaitListVCState();
}

class _WaitListVCState extends State<WaitListVC> {
  bool isSelectedA = true;
  bool isSelected12 = false;
  bool isSelected34 = false;
  bool isSelected5 = false;

  final List<WaitListModel> _arrWaitList = [];
  String? time;

  bool isLoading = false;

  _updateStatus(bool load) {
    setState(() {
      isLoading = load;
    });
  }

  @override
  void initState() {
    super.initState();
    _callGetCurrentWaitTimeAPI();
    _callGetWaitListAPI();
  }

  _callGetCurrentWaitTimeAPI() async {
    String? t = await APIManager.shared.getCurrentWaitTime(context);
    print(t);
    if (t != null) {
      setState(() {
        time = t;
      });
    }
  }

  _callGetWaitListAPI() async {
    setState(() {
      _arrWaitList.clear();
    });
    _updateStatus(true);
    List<WaitListModel>? d = await APIManager.shared.getWaitList(context);
    _updateStatus(false);
    print("d = $d");
    if (d != null) {
      setState(() {
        _arrWaitList.addAll(d);
      });
    }
  }

  _callGetWaitListSortNumber() async {
    setState(() {
      _arrWaitList.clear();
    });
    String? sortNumber;
    if (isSelected12) {
      sortNumber = "2";
    } else if (isSelected34) {
      sortNumber = "4";
    } else if (isSelected5) {
      sortNumber = "5+";
    }
    _updateStatus(true);
    List<WaitListModel>? d =
        await APIManager.shared.getWaitListSortNumber(context, sortNumber!);
    _updateStatus(false);
    if (d != null) {
      setState(() {
        _arrWaitList.addAll(d);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Wait List'),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.all(5),
          child:
              //SingleChildScrollView(
              // child:
              Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Current Wait Time: ",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => SetWaitTimeVc(time: time!),
                          ),
                        )
                            .then((value) {
                          _callGetCurrentWaitTimeAPI();
                        });
                      },
                      child: Row(
                        children: [
                          Text(
                            " $time minutes",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 5),
                    btn(
                        "All",
                        isSelectedA ? Colors.grey : Colors.white,
                        isSelectedA
                            ? Colors.white
                            : const Color.fromARGB(255, 110, 110, 110), () {
                      setState(() {
                        isSelectedA = true;
                        isSelected12 = false;
                        isSelected34 = false;
                        isSelected5 = false;
                      });
                      _callGetWaitListAPI();
                    }),
                    const SizedBox(width: 7),
                    btn(
                        "1-2",
                        isSelected12 ? Colors.grey : Colors.white,
                        isSelected12
                            ? Colors.white
                            : const Color.fromARGB(255, 110, 110, 110), () {
                      setState(() {
                        isSelectedA = false;
                        isSelected12 = true;
                        isSelected34 = false;
                        isSelected5 = false;
                      });
                      _callGetWaitListSortNumber();
                    }),
                    const SizedBox(width: 7),
                    btn(
                        "3-4",
                        isSelected34 ? Colors.grey : Colors.white,
                        isSelected34
                            ? Colors.white
                            : const Color.fromARGB(255, 110, 110, 110), () {
                      setState(() {
                        isSelectedA = false;
                        isSelected12 = false;
                        isSelected34 = true;
                        isSelected5 = false;
                      });
                      _callGetWaitListSortNumber();
                    }),
                    const SizedBox(width: 7),
                    btn(
                        "5+",
                        isSelected5 ? Colors.grey : Colors.white,
                        isSelected5
                            ? Colors.white
                            : const Color.fromARGB(255, 110, 110, 110), () {
                      setState(() {
                        isSelectedA = false;
                        isSelected12 = false;
                        isSelected34 = false;
                        isSelected5 = true;
                      });
                      _callGetWaitListSortNumber();
                    }),
                    const SizedBox(width: 5),
                  ],
                ),
                const SizedBox(height: 10),
                _arrWaitList.isEmpty ? noDataFound() : _listView(_arrWaitList),
              ],
            ),
          ),
          //),
        ),
      ),
    );
  }

  Widget noDataFound() {
    return Column(
      children: const [
        Center(child: Icon(Icons.dnd_forwardslash)),
        Text(
          "No Data Found",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget btn(String title, Color bgColor, Color fontColor, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: const Color.fromARGB(255, 110, 110, 110)),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: fontColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _listView(List<WaitListModel> arr) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 286,
      child: ListView.separated(
        itemCount: arr.length,
        padding:
            const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 20);
        },
        itemBuilder: (context, index) => InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 0),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child:
                  // Expanded(
                  //   child:
                  Row(
                children: [
                  // Expanded(
                  // child:
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 233,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Container(
                        //   constraints: BoxConstraints(
                        //       maxWidth:
                        //           MediaQuery.of(context).size.width - 180),
                        //   child: const Text(
                        //     "6:35 PM - 10m ago",
                        //     maxLines: 1,
                        //     overflow: TextOverflow.ellipsis,
                        //     style: TextStyle(
                        //       fontSize: 16,
                        //       fontWeight: FontWeight.w500,
                        //       color: Colors.black,
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 5),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width - 180),
                          child: Text(
                            "${arr[index].firstname} ${arr[index].lastname}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width - 180,
                          ),
                          child: Text(
                            arr[index].cellphone ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width - 180,
                          ),
                          child: Text(
                            arr[index].krowdWaitListNumberOfPeople ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  // ),
                  const SizedBox(width: 10),
                  arr[index].action == "Awaiting Check-in"
                      ? InkWell(
                          onTap: () {
                            ModelManager.shared.showCupertinoDialog(
                              context,
                              "Check - In",
                              "Would you like to check-in Gary Kraeger?",
                              "Yes - Check In",
                              () async {
                                Navigator.pop(context);

                                Response res = await APIManager.shared
                                    .checkInWaitList(
                                        context, arr[index].waitid.toString());

                                if (res.statusCode == 200) {
                                  var body = jsonDecode(res.body);
                                  var response = body['Response'];
                                  var status = response[0]['Status'];

                                  if (status == "200") {
                                    _callGetWaitListAPI();
                                  }
                                }
                              },
                            );
                          },
                          child: Container(
                            //width: 150,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.blue,
                            ),
                            padding: const EdgeInsets.all(5),
                            child: const Center(
                              child: Text(
                                "Awaiting Check-In",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      : arr[index].action == "Seated"
                          ? Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) => Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0)),
                                        elevation: 0.0,
                                        backgroundColor: Colors.transparent,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 0.0, right: 0.0),
                                          child: Stack(
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                padding: const EdgeInsets.only(
                                                  top: 18.0,
                                                ),
                                                margin: const EdgeInsets.only(
                                                    top: 13.0, right: 8.0),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    shape: BoxShape.rectangle,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: Colors.black26,
                                                        blurRadius: 0.0,
                                                        offset:
                                                            Offset(0.0, 0.0),
                                                      ),
                                                    ]),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    const SizedBox(
                                                      height: 20.0,
                                                    ),
                                                    const Center(
                                                      child: Text(
                                                        "Page Customer Again",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 30),
                                                      child: Center(
                                                        child: Text(
                                                          "Do you want to send a final notification to Gary Kraeger that the table is ready?",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        height: 24.0),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        InkWell(
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 15.0,
                                                                    bottom:
                                                                        15.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .grey[300],
                                                              borderRadius: const BorderRadius
                                                                      .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          16.0),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          16.0)),
                                                            ),
                                                            child: const Text(
                                                              "Yes - Notify Party",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          onTap: () async {
                                                            Navigator.pop(
                                                                context);

                                                            Response res = await APIManager
                                                                .shared
                                                                .getWaitListFinalText(
                                                                    context,
                                                                    arr[index]
                                                                        .waitid
                                                                        .toString());

                                                            if (res.statusCode ==
                                                                200) {
                                                              var body =
                                                                  jsonDecode(
                                                                      res.body);
                                                              var response = body[
                                                                  'Response'];
                                                              var status =
                                                                  response[0][
                                                                      'Status'];

                                                              if (status ==
                                                                  "200") {
                                                                _callGetWaitListAPI();
                                                              }
                                                            }
                                                          },
                                                        ),
                                                        Container(
                                                          width: 2,
                                                          height: 50,
                                                          color: Colors.grey,
                                                        ),
                                                        InkWell(
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 15.0,
                                                                    bottom:
                                                                        15.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .grey[300],
                                                              borderRadius: const BorderRadius
                                                                      .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          16.0),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          16.0)),
                                                            ),
                                                            child: const Text(
                                                              "Cancel Party",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                            ModelManager.shared
                                                                .showCupertinoDialog(
                                                              context,
                                                              "Cancel Party Spot In Line",
                                                              "Do you want to cancel Gary Kraeger place in line. \n Delete this persons reservation?",
                                                              "Yes - Cancel Party",
                                                              () async {
                                                                // _updateStatus(
                                                                //     true);
                                                                Response res = await APIManager
                                                                    .shared
                                                                    .cancelWaitList(
                                                                        context,
                                                                        arr[index]
                                                                            .waitid
                                                                            .toString());
                                                                // _updateStatus(
                                                                //     false);

                                                                var body =
                                                                    jsonDecode(
                                                                        res.body);

                                                                var response = body[
                                                                    'Response'];

                                                                var status =
                                                                    response[0][
                                                                        'Status'];

                                                                if (status ==
                                                                    "200") {
                                                                  Navigator.pop(
                                                                      context);

                                                                  var msg =
                                                                      response[
                                                                              0]
                                                                          [
                                                                          'message'];
                                                                  showFlushbar(
                                                                      false,
                                                                      "Success",
                                                                      msg,
                                                                      context,
                                                                      4);
                                                                }
                                                              },
                                                            );
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Positioned(
                                                right: 20,
                                                top: 20,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child:
                                                        // CircleAvatar(
                                                        //   radius: 14.0,
                                                        //   backgroundColor:
                                                        //       Colors.white,
                                                        //   child:
                                                        Icon(
                                                      Icons.close,
                                                      color: Colors.black,
                                                      size: 30,
                                                    ),
                                                    //),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );

                                    // ModelManager.shared.showCupertinoDialog(
                                    //   context,
                                    //   "Page Customer Again",
                                    //   "Do you want to send a final notification to Gary Kraeger that the table is ready?",
                                    //   "Yes - Notify Party",
                                    //   () async {
                                    // Navigator.pop(context);

                                    // Response res = await APIManager.shared
                                    //     .getWaitListFinalText(context,
                                    //         arr[index].waitid.toString());

                                    // if (res.statusCode == 200) {
                                    //   var body = jsonDecode(res.body);
                                    //   var response = body['Response'];
                                    //   var status = response[0]['Status'];

                                    //   if (status == "200") {
                                    //     _callGetWaitListAPI();
                                    //   }
                                    // }
                                    //   },
                                    //   failTxt: "Cancel Party",
                                    //   onTapFail: () {},
                                    // );
                                  },
                                  child: Container(
                                    //width: 100,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.black,
                                    ),
                                    padding: const EdgeInsets.all(5),
                                    child: const Center(
                                      child: Text(
                                        "Didn't Come",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "# Messages Sent: ${arr[index].finalPageSend}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                InkWell(
                                  onTap: () {
                                    ModelManager.shared.showCupertinoDialog(
                                        context,
                                        "Seat the guest",
                                        "Are you sure you want to seat Gary Kraeger?",
                                        "Yes - Seat Guest", () async {
                                      Navigator.pop(context);

                                      Response res = await APIManager.shared
                                          .waitListSeatCustomer(context,
                                              arr[index].waitid.toString());

                                      if (res.statusCode == 200) {
                                        var body = jsonDecode(res.body);
                                        var response = body['Response'];
                                        var status = response[0]['Status'];

                                        if (status == "200") {
                                          _callGetWaitListAPI();
                                        }
                                      }
                                    });
                                  },
                                  child: Container(
                                    // width: 90,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: const Color.fromARGB(
                                          255, 46, 162, 185),
                                    ),
                                    padding: const EdgeInsets.all(5),
                                    child: const Center(
                                      child: Text(
                                        "Seated",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : arr[index].action == "Table Ready"
                              ? InkWell(
                                  onTap: () {
                                    ModelManager.shared.showCupertinoDialog(
                                        context,
                                        "Check - In",
                                        "Would you like to check-in Gary Kraeger?",
                                        "Yes - Notify User", () async {
                                      Navigator.pop(context);

                                      Response res = await APIManager.shared
                                          .getWaitListPageCustomer(context,
                                              arr[index].waitid.toString());

                                      if (res.statusCode == 200) {
                                        var body = jsonDecode(res.body);
                                        var response = body['Response'];
                                        var status = response[0]['Status'];

                                        if (status == "200") {
                                          _callGetWaitListAPI();
                                        }
                                      }
                                    });
                                  },
                                  child: Container(
                                    // width: 100,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.red,
                                    ),
                                    padding: const EdgeInsets.all(5),
                                    child: const Center(
                                      child: Text(
                                        "Table Ready",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                ],
              ),
              //),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 0.0, right: 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 14.0,
                backgroundColor: Colors.white,
                child: Icon(Icons.close, color: Colors.red),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 18.0,
            ),
            margin: const EdgeInsets.only(top: 13.0, right: 8.0),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 0.0,
                    offset: Offset(0.0, 0.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                const Center(
                  child: Text(
                    "Page Customer Again",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Center(
                    child: Text(
                      "Do you want to send a final notification to Gary Kraeger that the table is ready?",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16.0),
                              bottomRight: Radius.circular(16.0)),
                        ),
                        child: const Text(
                          "Yes - Notify Party",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                      },
                    ),
                    Container(
                      width: 2,
                      height: 50,
                      color: Colors.grey,
                    ),
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16.0),
                              bottomRight: Radius.circular(16.0)),
                        ),
                        child: const Text(
                          "Cancel Party",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
