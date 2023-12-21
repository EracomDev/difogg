// ignore_for_file: file_names

import 'package:difog/screens/support_history.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:difog/services/api_data.dart';
import 'package:difog/utils/app_config.dart';

import '../widgets/success_or_failure_dialog.dart';

class Support extends StatefulWidget {
  const Support({super.key});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  String? dropdownValue;
  var size;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isFormListLoading = false;
  var messageController = TextEditingController();
  List<Map<String, dynamic>> dropdownData = [
    /*{"type":"Package Info"},
    {"type":"Package Info1"},
    {"type":"Package Info2"},
    {"type":"Package Info3"},*/
  ];
  List<Map<String, dynamic>> tableData = [];
  final TextStyle tabledata =
  const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 12);
  @override
  void initState() {
    super.initState();
    dropdownValue = "1";
    FetchData();
    //fetchSupportList();
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
    print(ApiData.supportType);
    var url = Uri.parse(ApiData.supportType);
    var body = jsonEncode({'u_id': userId});

    print(body);
    try {
      var response = await http.post(url, body: body);
      print('res ${response.body}');
      if (response.statusCode == 200) {
        print('response.body ${response.body}');
        var jsonData = await jsonDecode(response.body);
        print("jkbjkbkg hj ggiuguo gohioh");
        if (jsonData['res'].toString() == "true") {
          List<dynamic> data = jsonData['data'];

          print("reason");
          print(data);

          for(int i = 0 ; i< data.length;i++){
            String reason  = data[i].toString();
            dropdownData.add({"type":reason});
          }
          
          
          setState(() {
            dropdownData;
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
      var body = jsonEncode({
        'u_id': userId,
        'message': messageController.text,
        'support_type': dropdownValue,
        'subject': dropdownValue
      });
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

            showDialog(context: context,
                builder: (BuildContext context){
                  return AlertDialogBox(
                    type: "success",
                    title: "Success Alert",
                    desc: jsonData['message'].toString(),

                  );
                }
            );


            messageController.clear();
          } else {
            setState(() {
              isLoading = false;
            });
            showDialog(context: context,
                builder: (BuildContext context){
                  return AlertDialogBox(
                    type: "failure",
                    title: "Failed Alert",
                    desc: jsonData['message'].toString(),

                  );
                }
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


  @override
  Widget build(BuildContext context) {
    size= MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppConfig.background,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppConfig.background,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(

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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
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

                        SizedBox(width: size.width,child: Text("Select Reason",style: TextStyle(fontSize: 16),),),
                        const SizedBox(height: 4),
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
                                'Select Reason',
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
                        const SizedBox(height: 20),

                        SizedBox(width: size.width,child: Text("Enter Message",style: TextStyle(fontSize: 16),),),
                        const SizedBox(height: 4),

                        Container(
                          alignment: Alignment.topLeft,
                          child: TextFormField(

                            controller: messageController,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                            textAlign: TextAlign.start,

                            minLines: 3,
                            maxLines:
                            null, // Set it to null to allow multiple lines
                            decoration:  InputDecoration(
                              fillColor: AppConfig.textFieldColor,
                              hintText: 'Enter your message',

                              hintStyle: TextStyle(color: Colors.white,),
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
                        ),
                        const SizedBox(height: 20),
                        isLoading
                            ? const SizedBox(
                            width: 25,
                            height: 25,
                            child:
                            CircularProgressIndicator(strokeWidth: 2))
                            :

                        Row(

                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 40,
                              width: size.width*.35,
                              decoration: BoxDecoration(gradient:

                              AppConfig.buttonGradient,borderRadius: BorderRadius.circular(20)

                              ),
                              child: ElevatedButton(
                                onPressed: () {

                                  support();
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                                child: Text('Submit',style: TextStyle(color: AppConfig.titleIconAndTextColor),),
                              ),
                            ),

                            SizedBox(width: 10,),

                            Container(
                              alignment: Alignment.center,
                              height: 40,
                              width: size.width*.35,
                              decoration: BoxDecoration(gradient:

                              AppConfig.buttonGradient,borderRadius: BorderRadius.circular(20)

                              ),
                              child: ElevatedButton(
                                onPressed: () {

                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SupportHistory()));
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                                child: Text('History',style: TextStyle(color: AppConfig.titleIconAndTextColor),),
                              ),
                            ),
                          ],
                        )

                      ],
                    ),
                  ),

                  SizedBox(height: 10,),




                ],
              ),
            ),
          )),
    );
  }
}
