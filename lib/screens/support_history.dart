import 'dart:convert';

import 'package:difog/screens/ticket_detail_page.dart';
import 'package:difog/services/api_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../utils/app_config.dart';
import '../utils/card_design_new.dart';

class SupportHistory extends StatefulWidget {
  const SupportHistory({super.key});

  @override
  State<SupportHistory> createState() => _SupportHistoryState();
}

class _SupportHistoryState extends State<SupportHistory> {
  bool isFormListLoading = true;
  var size;

  List<Map<String, dynamic>> tableData = [];
  final TextStyle tabledata =
      const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 12);

  final TextStyle packageText = const TextStyle(
      color: Color.fromARGB(255, 255, 255, 255),
      fontSize: 14,
      fontWeight: FontWeight.normal);
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppConfig.background,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppConfig.background,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Support History",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                for (var rowData in tableData)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      //padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                rowData['support_type'].toString(),
                                style: const TextStyle(
                                    color: AppConfig.primaryText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              // Text(rowData['id'].toString(),
                              //     style: packageText),
                              const Spacer(),
                              InkWell(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: AppConfig.primaryColor,
                                      border: Border.all(
                                          color: AppConfig.primaryColor)),
                                  child: const Text(
                                    "View Detail",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TicketDetail(data: rowData)));
                                },
                              )
                            ],
                          ),
                          const SizedBox(height: 10),

                          /*Row(

                      children: [
                        Text(
                          "Message : ",
                          style: packageText,
                        ),
                        SizedBox(
                            width: size.width*.5,
                            child: Text( rowData['message'].toString(), style: packageText)),
                      ],
                    ),

                    const SizedBox(height: 10),*/
                          Row(
                            children: [
                              Text(
                                "Create Date : ",
                                style: packageText,
                              ),
                              Text(rowData['updated_on'].toString(),
                                  style: packageText),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Status",
                                style: packageText,
                              ),
                              rowData['status'].toString() == "1"
                                  ? const Text(
                                      "Replied",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 84, 245, 90)),
                                    )
                                  : Text(
                                      "Not Replied",
                                      style: TextStyle(
                                          color: Colors.yellow.shade900),
                                    )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            height: 1,
                            color: Color.fromARGB(97, 158, 158, 158),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                if (isFormListLoading)
                  const Center(
                    child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchSupportList();
    super.initState();
  }

  Future<void> fetchSupportList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('u_id');
    print('token $userId');
    setState(() {
      isFormListLoading = true;
    });
    var url = Uri.parse(ApiData.supportList);
    var body = jsonEncode({
      'u_id': userId,
    });
    try {
      var response = await http.post(url, body: body);
      print('res $response');
      if (response.statusCode == 200) {
        print('response.body ${response.body}');
        var jsonData = jsonDecode(response.body);
        if (jsonData['res'] == "success") {
          final data = jsonData['statements'];
          setState(() {
            tableData = List<Map<String, dynamic>>.from(data);
            isFormListLoading = false;
          });
          print('tableData $tableData');
        } else {
          setState(() {
            isFormListLoading = false;
          });
        }
      } else {
        setState(() {
          isFormListLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isFormListLoading = false;
        });
      }
    }
  }
}
