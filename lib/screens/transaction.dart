// ignore_for_file: use_build_context_synchronously

import 'package:difog/utils/card_design_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

import 'package:difog/services/api_data.dart';

import '../utils/app_config.dart';
import '../widgets/success_or_failure_dialog.dart';

class Transaction extends StatefulWidget {
  String type;
  String title;
  Transaction({Key? key, required this.type, required this.title})
      : super(key: key);

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  bool isLoading = false;
  List<dynamic>? dashboardData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('u_id');
    print('token $userId');
    setState(() {
      isLoading = true;
    });

    var url = Uri.parse(ApiData.transaction);
    print(widget.type);

    print(ApiData.transaction);
    var body =
        jsonEncode({'u_id': userId, "tx_type": widget.type, "init_val": "0"});

    try {
      var response = await http.post(url, body: body);
      print('res $response');

      if (response.statusCode == 200) {
        print('Login successful');
        print('response.body ${response.body}');
        var jsonData = jsonDecode(response.body) as Map<String, dynamic>;

        log("jkbjkbkg hj ggiuguo gohioh");

        if (jsonData['res'] == "success") {
          final mydata = jsonData['data'];
          print("mydata $mydata");
          setState(() {
            dashboardData = List.from(mydata);
            isLoading = false;
          });
          print('dashboardData $dashboardData');
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialogBox(
                type: "failure",
                title: "Failed Alert",
                desc: "Failed to fetch data",
              );
            });

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialogBox(
                type: "failure",
                title: "Failed Alert",
                desc: "Failed to fetch data",
              );
            });

        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print('An error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.background,
      appBar: AppBar(
        //systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: MyColors.statusBarColor,statusBarBrightness: Brightness.light,statusBarIconBrightness: Brightness.light),

        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppConfig.titleBarColor,
        title: Text(
          "${widget.title} History",
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              strokeWidth: 1,
            ))
          : dashboardData != null && dashboardData!.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: fetchData,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount:
                        dashboardData != null ? dashboardData!.length : 0,
                    itemBuilder: (context, index) {
                      final item = dashboardData![index];
                      return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: AppConfig.myCardColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 0.5, color: AppConfig.borderColor)),
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    item['debit_credit'] == "credit"
                                        ? Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                color: AppConfig.myCardColor,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    width: 0.5,
                                                    color: const Color.fromARGB(
                                                        255, 5, 236, 102))),
                                            child: const Icon(
                                              Icons.arrow_downward,
                                              size: 18,
                                              color: Color.fromARGB(
                                                  255, 5, 236, 102),
                                            ),
                                          )
                                        : Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                color: AppConfig.myCardColor,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    width: 0.5,
                                                    color: const Color.fromARGB(
                                                        255, 5, 236, 102))),
                                            child: const Icon(
                                              Icons.arrow_upward,
                                              size: 18,
                                              color: Color.fromARGB(
                                                  255, 5, 236, 102),
                                            ),
                                          ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${item['remark']}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                          Text(
                                            "${item['date']}",
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        item['debit_credit'] == "credit"
                                            ? Text(
                                                item['tx_type'] == "token"
                                                    ? "+ ${item['amount']}"
                                                    : "+ \$ ${item['amount']} ",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              )
                                            : Text(
                                                item['tx_type'] == "token"
                                                    ? "- ${item['amount']}"
                                                    : "- \$ ${item['amount']} ",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                        item['status'] == "0"
                                            ? const Text(
                                                "Pending",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.yellow),
                                              )
                                            : item['status'] == "1"
                                                ? const Text(
                                                    "Success",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Color.fromARGB(
                                                            255, 5, 236, 102)),
                                                  )
                                                : const Text(
                                                    "Failed",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Color.fromARGB(
                                                            255, 255, 17, 0)),
                                                  )
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ));
                    },
                  ),
                )
              : Center(
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/no_data.png",
                      height: 200,
                      width: 200,
                    ),
                    const Text(
                      "Data Not Found",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                )),
    );
  }
}
