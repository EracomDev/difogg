// ignore_for_file: depend_on_referenced_packages

import 'package:difog/utils/app_config.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_data.dart';

class GenerationTeam extends StatefulWidget {
  const GenerationTeam({super.key});

  @override
  State<GenerationTeam> createState() => _GenerationTeamState();
}

class _GenerationTeamState extends State<GenerationTeam> {
  var sno = 0;
  final TextStyle tableText = const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: Color.fromARGB(255, 255, 255, 255),
  );

  String? dropdownValue;
  var pageController = TextEditingController();
  bool isLoading = false;
  var next_init_val;
  var totalPage = 0;
  List<dynamic>? incomesData;
  final TextStyle tabledata =
      const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 12);

  List<Map<String, dynamic>> dropdownData = [
    {"name": "Level 1", "type": "1"},
    {"name": "Level 2", "type": "2"},
    {"name": "Level 3", "type": "3"},
    {"name": "Level 4", "type": "4"},
    {"name": "Level 5", "type": "5"},
    {"name": "Level 6", "type": "6"},
    {"name": "Level 7", "type": "7"},
    {"name": "Level 8", "type": "8"},
    {"name": "Level 9", "type": "9"},
    {"name": "Level 10", "type": "10"},
  ];
  String selectedValue = ""; // Set initial value
  List<Map<String, dynamic>> tableData = [];
  @override
  void initState() {
    super.initState();
    selectedValue = dropdownData[0]['type']!;
    fetchData(selectedValue, 0);
  }

  Future<void> fetchData(teamLevel, initialValue) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('u_id');

    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(ApiData.teamGeneration);

    var body = jsonEncode(
        {'u_id': userId, "init_val": initialValue, "level": teamLevel});

    try {
      var response = await http.post(url, body: body);
      print('res $response');
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['res'] == "success") {
          final data = jsonData['data'];
          setState(() {
            tableData = List<Map<String, dynamic>>.from(data);
            next_init_val = jsonData['next_init_val'];
            totalPage = (int.parse(jsonData['total_count']) / 20).ceil();
            pageController.clear();
            isLoading = false;
          });
          print('tableData $tableData');
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
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

  Future<void> GoTo(teamType, int initVal) async {
    if (initVal > 0 && initVal <= totalPage) {
      var nextPage = (initVal - 1) * 20;
      fetchData(teamType.toString(), nextPage.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.background,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppConfig.background,
        title: const Text(
          "Generation Team",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedValue,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                    borderSide: BorderSide(
                      color: AppConfig.borderColor,
                      width: 0.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                    borderSide: BorderSide(
                      color: AppConfig.borderColor,
                      width: 0.5,
                    ),
                  ),
                  filled: true,
                  fillColor: AppConfig.background,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
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
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                    fetchData(selectedValue, 0);
                  });
                },
              ),
              const SizedBox(height: 15),
              isLoading == true
                  ? const Center(
                      child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ))
                  : Container(),
              const SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  child: Table(
                    defaultColumnWidth: const IntrinsicColumnWidth(),
                    border: TableBorder.all(
                        color: const Color.fromARGB(255, 78, 75, 75),
                        width: 0.5),
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                              child: Container(
                            color: AppConfig.primaryColor,
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: Text(
                              'Name',
                              style: tabledata,
                            ),
                          )),
                          TableCell(
                              child: Container(
                            color: AppConfig.primaryColor,
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: Text(
                              'User Id',
                              style: tabledata,
                            ),
                          )),
                          TableCell(
                              child: Container(
                            color: AppConfig.primaryColor,
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: Text(
                              'Country & Code',
                              style: tabledata,
                            ),
                          )),
                          TableCell(
                              child: Container(
                            color: AppConfig.primaryColor,
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: Text(
                              'Mobile',
                              style: tabledata,
                            ),
                          )),
                          TableCell(
                              child: Container(
                            color: AppConfig.primaryColor,
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: Text(
                              'Email',
                              style: tabledata,
                            ),
                          )),
                          TableCell(
                              child: Container(
                            color: AppConfig.primaryColor,
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: Text(
                              'Status',
                              style: tabledata,
                            ),
                          )),
                          TableCell(
                              child: Container(
                            color: AppConfig.primaryColor,
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: Text(
                              'Active Date',
                              style: tabledata,
                            ),
                          )),
                        ],
                      ),
                      for (var rowData in tableData)
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child: Text(
                                  rowData['name'].toString(),
                                  style: tabledata,
                                ),
                              ),
                            ),
                            TableCell(
                                child: Container(
                              padding: const EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: Text(
                                rowData['username'].toString(),
                                style: tabledata,
                              ),
                            )),
                            TableCell(
                                child: Container(
                              padding: const EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: Text(
                                "${rowData['country_code'].toString()}   ${rowData['country'].toString()}",
                                style: tabledata,
                              ),
                            )),
                            TableCell(
                                child: Container(
                              padding: const EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: Text(
                                rowData['mobile'].toString(),
                                style: tabledata,
                              ),
                            )),
                            TableCell(
                                child: Container(
                              padding: const EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: Text(
                                " ${rowData['email'].toString()}",
                                style: tabledata,
                              ),
                            )),
                            TableCell(
                                child: Container(
                              padding: const EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: Text(
                                rowData['active_status'] == "1"
                                    ? "Active"
                                    : "Inactive",
                                style: tabledata,
                              ),
                            )),
                            TableCell(
                                child: Container(
                              padding: const EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: Text(
                                rowData['active_date'] ?? "",
                                style: tabledata,
                              ),
                            )),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 40,
                          child: TextFormField(
                            controller: pageController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Page',
                              labelStyle: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                              filled: true,
                              fillColor: const Color.fromARGB(83, 66, 66, 66),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 25.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        isLoading == true
                            ? const SizedBox(
                                width: 15,
                                height: 15,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  GoTo(selectedValue,
                                      int.parse(pageController.text));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: AppConfig.primaryColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: const Center(
                                    child: Text(
                                      "GO",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ),
                    Text(
                      "Pages   ${next_init_val != null ? (next_init_val / 20).ceil() : "0"} / $totalPage",
                      textAlign: TextAlign.end,
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
