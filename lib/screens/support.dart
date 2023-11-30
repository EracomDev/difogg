// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:difog/services/api_data.dart';
import 'package:difog/utils/app_config.dart';

class Support extends StatefulWidget {
  const Support({super.key});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  String? dropdownValue;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isFormListLoading = false;
  var messageController = TextEditingController();
  List<Map<String, dynamic>> dropdownData = [];
  List<Map<String, dynamic>> tableData = [];
  final TextStyle tabledata =
  const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 12);
  @override
  void initState() {
    super.initState();
    dropdownValue = "1";
    FetchData();
    fetchSupportList();
  }

  // ignore: non_constant_identifier_names
  Future<void> FetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('u_id');
    debugPrint('token $userId');
    if (!mounted) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(ApiData.supportType);
    var body = {'u_id': userId};
    try {
      var response = await http.post(url, body: body);
      print('res ${response.body}');
      if (response.statusCode == 200) {
        print('response.body ${response.body}');
        var jsonData = await jsonDecode(response.body);
        print("jkbjkbkg hj ggiuguo gohioh");
        if (jsonData['res'] == "success") {
          final data = jsonData['data'];
          setState(() {
            dropdownData = List<Map<String, dynamic>>.from(data);
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print("jkbjkbkg hj ggiuguo gohioh");
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

  Future<void> support() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('u_id');
      if (!mounted) {
        return;
      }
      setState(() {
        isLoading = true;
      });
      var url = Uri.parse(ApiData.support);
      var body = {
        'u_id': userId,
        'message': messageController.text,
        'support_type': dropdownValue
      };
      try {
        var response = await http.post(url, body: body);
        print('res ${response.body}');
        if (response.statusCode == 200) {
          print('response.body ${response.body}');
          var jsonData = await jsonDecode(response.body);
          if (jsonData['res'] == "success") {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(jsonData['message']),
                  backgroundColor: Colors.green),
            );
            fetchSupportList();
            messageController.clear();
          } else {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(jsonData['message']),
                  backgroundColor: Colors.red),
            );
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
      }
    }
  }

  Future<void> fetchSupportList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('u_id');
    print('token $userId');
    setState(() {
      isFormListLoading = true;
    });
    var url = Uri.parse(ApiData.supportList);
    var body = {
      'u_id': userId,
    };
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.background,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppConfig.background,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Support",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppConfig.background,
              ),
              width: double.infinity,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "SUPPORT TICKET",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Would you like to speak to one of our financial advisers over the phone? Just submit your details and we'll be in touch shortly. You can also email us if you would prefer.",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        // const SelectField(),
                        DropdownButtonFormField<String>(
                          value: dropdownValue,
                          icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.white,size: 18,),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value == "1") {
                              return "Please select ticket type";
                            } else {
                              return null;
                            }
                          },
                          decoration:  InputDecoration(
                            filled: true,
                            fillColor: AppConfig.primaryColor,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                color: AppConfig.background,
                                width: 1.0,

                              ),
                            ),
                          ),
                          dropdownColor: AppConfig.background,

                          items: [
                            const DropdownMenuItem(
                              value: '1',
                              child: Text(
                                'Select Package',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),


                            ),
                            for (var rowData in dropdownData)
                              DropdownMenuItem(
                                value: rowData['type'],
                                child: Text(
                                  (rowData['type']).toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                          ],
                          onChanged: (String? newValue) {
                            // Handle dropdown value change
                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: messageController,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                          maxLines:
                          null, // Set it to null to allow multiple lines
                          decoration:  InputDecoration(
                            fillColor: AppConfig.textFieldColor,
                            labelText: 'Enter your text',
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            // Handle text changes
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "please enter text";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        isLoading
                            ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                            CircularProgressIndicator(strokeWidth: 1))
                            :

                        Container(
                          height: 40,
                          decoration: BoxDecoration(gradient:

                          AppConfig.buttonGradient,borderRadius: BorderRadius.circular(20)

                          ),
                          child: ElevatedButton(
                            onPressed: () {

                              support();
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                            child: Text('Send',style: TextStyle(color: AppConfig.titleIconAndTextColor),),
                          ),
                        )

                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Support History",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Table(
                        defaultColumnWidth: const IntrinsicColumnWidth(),
                        border: TableBorder.all(
                            color: const Color.fromARGB(48, 255, 255, 255)),
                        children: [
                          TableRow(
                            decoration: const BoxDecoration(
                                color:AppConfig.primaryColor),
                            children: [
                              TableCell(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Ticket ID',
                                      style: tabledata,
                                    ),
                                  )),
                              TableCell(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Description',
                                      style: tabledata,
                                    ),
                                  )),
                              TableCell(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Create Date',
                                      style: tabledata,
                                    ),
                                  )),
                              TableCell(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Status',
                                      style: tabledata,
                                    ),
                                  )),
                              TableCell(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Reply',
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
                                      padding: const EdgeInsets.all(5),
                                      alignment: Alignment.center,
                                      child: Text(
                                        rowData['id'].toString(),
                                        style: tabledata,
                                      ),
                                    )),
                                TableCell(
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      alignment: Alignment.center,
                                      child: Text(
                                        rowData['message'].toString(),
                                        style: tabledata,
                                      ),
                                    )),
                                TableCell(
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      alignment: Alignment.center,
                                      child: Text(
                                        rowData['updated_on'].toString(),
                                        style: tabledata,
                                      ),
                                    )),
                                TableCell(
                                    child: Container(
                                        padding: const EdgeInsets.all(5),
                                        alignment: Alignment.center,
                                        child:
                                        rowData['status'].toString() == "1"
                                            ? const Text(
                                          "Replied",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 84, 245, 90)),
                                        )
                                            : const Text(
                                          "Not Replied",
                                          style: TextStyle(
                                              color: Colors.red),
                                        ))),
                                TableCell(
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      alignment: Alignment.center,
                                      child: Text(
                                        rowData['reply'].toString(),
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
                  isFormListLoading
                      ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 1))
                      : const Center()
                ],
              ),
            ),
          )),
    );
  }
}
