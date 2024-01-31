// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import 'package:url_launcher/url_launcher.dart';
import 'package:difog/services/api_data.dart';
import '../utils/app_config.dart';
import '../widgets/success_or_failure_dialog.dart';

class withdrawHistory extends StatefulWidget {
  @override
  State<withdrawHistory> createState() => _withdrawHistoryState();
}

class _withdrawHistoryState extends State<withdrawHistory> {
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

    print(ApiData.transaction);
    var body =
        jsonEncode({'u_id': userId, "tx_type": "withdrawal", "init_val": "0"});

    try {
      var response = await http.post(url, body: body);
      print('res $response');

      if (response.statusCode == 200) {
        log('response.body ${response.body}');
        var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
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
        title: const Text(
          "Withdrawal History",
          style: TextStyle(color: Colors.white, fontSize: 18),
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
                      return item['status'] == "1"
                          ? GestureDetector(
                              onTap: () {
                                _launchURL(item['tx_hash'].toString());
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: AppConfig.myCardColor,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 0.5,
                                          color: AppConfig.borderColor)),
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  child: Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  color: AppConfig.myCardColor,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  border: Border.all(
                                                      width: 0.5,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              5,
                                                              236,
                                                              102))),
                                              child: const Icon(
                                                Icons.near_me,
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
                                                      item['tx_hash']
                                                          .toString(),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Color.fromARGB(
                                                              255,
                                                              5,
                                                              236,
                                                              102))),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "\$ ${(double.parse(item['amount'].toString()) + double.parse(item['tx_charge'].toString()))}",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                      ],
                                    ),
                                  )),
                            )
                          : Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: AppConfig.myCardColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 0.5,
                                      color: AppConfig.borderColor)),
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: AppConfig.myCardColor,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  width: 0.5,
                                                  color: Colors.yellow)),
                                          child: const Icon(
                                            Icons.arrow_downward,
                                            size: 18,
                                            color: Colors.yellow,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              item['status'] == "0"
                                                  ? const Text(
                                                      "Pending",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.yellow),
                                                    )
                                                  : const Text(
                                                      "Failed",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Color.fromARGB(
                                                              255, 255, 17, 0)),
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
                                            Text(
                                              "\$ ${(double.parse(item['amount'].toString()) + double.parse(item['tx_charge'].toString()))}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
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
    );
  }

  Future<void> _launchURL(String url) async {
    String newStr = "https://bscscan.com/tx/" + url;
    final Uri _url = Uri.parse(newStr);
    if (!await canLaunch(_url.toString())) {
      throw Exception('Could not launch $_url');
    } else {
      await launch(_url.toString());
    }
  }
}
