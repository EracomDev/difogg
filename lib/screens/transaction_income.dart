// ignore_for_file: use_build_context_synchronously

import 'package:difog/utils/card_design_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

import 'package:difog/services/api_data.dart';

import '../utils/app_config.dart';
import '../widgets/success_or_failure_dialog.dart';

class TransactionIncome extends StatefulWidget {
  String type;
  String title;
  TransactionIncome({Key? key, required this.type, required this.title})
      : super(key: key);

  @override
  State<TransactionIncome> createState() => _TransactionIncomeState();
}

class _TransactionIncomeState extends State<TransactionIncome> {
  bool isLoading = false;
  List<dynamic>? dashboardData;

  List<Map<String, dynamic>> dropdownData = [
    {"name": "All Incomes", "type": "all"},
    {"name": "Recommendations Bonus", "type": "level"},
    {"name": "Daily Claim Bonus", "type": "daily"},
    {"name": "Appreciation Bonus", "type": "salary"},
    {"name": "Free Claim Bonus", "type": "free"},
  ];

  String selectedValue = "";

  @override
  void initState() {
    super.initState();
    fetchData();

    selectedValue = widget.type;
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('u_id');
    print('token $userId');
    setState(() {
      isLoading = true;
    });

    var url = Uri.parse(ApiData.transactionIncome);
    print(widget.type);

    print(ApiData.transactionIncome);

    var body = jsonEncode(
        {'u_id': userId, "income_type": selectedValue, "init_val": "0"});

    try {
      var response = await http.post(url, body: body);
      print('res $response');

      if (response.statusCode == 200) {
        print('response.body ${response.body}');
        var jsonData = jsonDecode(response.body) as Map<String, dynamic>;

        if (jsonData['res'] == "success") {
          final mydata = jsonData['data'];
          print("mydata $mydata");

          if (dashboardData != null) {
            dashboardData!.clear();
          }
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
                  child: Column(
                    children: [
                      if (widget.type == "all")
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              const Text(
                                "Filter By",
                                style: TextStyle(
                                    fontSize: 12, color: AppConfig.primaryText),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .5,
                                child: DropdownButtonFormField<String>(
                                  value: selectedValue,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppConfig.myCardColor,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(25)),
                                      borderSide: BorderSide(
                                        color: AppConfig.borderColor,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  dropdownColor: AppConfig.background,
                                  items: dropdownData.map((data) {
                                    return DropdownMenuItem<String>(
                                      value: data['type']!,
                                      child: Text(
                                        data['name']!,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedValue = newValue!;
                                      fetchData();
                                      //fetchData(selectedValue);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
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
                                        width: 0.5,
                                        color: AppConfig.primaryColor
                                            .withOpacity(0.4))),
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 8),
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
                                                    color:
                                                        AppConfig.myCardColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    border: Border.all(
                                                        width: 0.5,
                                                        color: const Color
                                                            .fromARGB(
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
                                                    color:
                                                        AppConfig.myCardColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    border: Border.all(
                                                        width: 0.5,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 5, 236, 102))),
                                                child: const Icon(
                                                  Icons.arrow_upward,
                                                  size: 18,
                                                  color: Color.fromARGB(
                                                      255, 5, 236, 102),
                                                ),
                                              ),
                                        const SizedBox(
                                            width:
                                                12), // Add spacing between the image and text
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
                                                    fontSize: 11),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
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
                                                        fontSize: 10,
                                                        color: Colors.yellow),
                                                  )
                                                : item['status'] == "1"
                                                    ? const Text(
                                                        "Success",
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    5,
                                                                    236,
                                                                    102)),
                                                      )
                                                    : const Text(
                                                        "Failed",
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    17,
                                                                    0,
                                                                    1)),
                                                      )
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                  ],
                                ));
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: AppConfig.background,
                  child: Column(
                    children: [
                      if (widget.type == "all")
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: const Text(
                                  "Filter By",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),

                              Expanded(
                                flex: 4,
                                child: SizedBox(
                                  //width: MediaQuery.of(context).size.width * .7,
                                  child: DropdownButtonFormField<String>(
                                    value: selectedValue,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: AppConfig.textFieldColor,
                                      contentPadding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                      border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(25)),
                                        borderSide: BorderSide(
                                          color: AppConfig.textFieldColor,
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    dropdownColor: AppConfig.background,
                                    items: dropdownData.map((data) {
                                      return DropdownMenuItem<String>(
                                        value: data['type']!,
                                        child: Text(
                                          data['name']!,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedValue = newValue!;

                                        fetchData();
                                        //fetchData(selectedValue);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: Center(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 250,
                              child: Lottie.asset('assets/images/no_data.json',
                                  fit: BoxFit.contain, repeat: false),
                            ),

                            //Image.asset("assets/images/no_data.png",height: 200,width: 200,),
                            const Text(
                              "Data Not Found",
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 100),
                          ],
                        )),
                      ),
                    ],
                  ),
                ),
    );
  }
}
