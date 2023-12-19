import 'dart:convert';
import 'dart:developer';

import 'package:difog/utils/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_data.dart';
import '../widgets/success_or_failure_dialog.dart';

class LevelsLockUnlock extends StatefulWidget {
  const LevelsLockUnlock({super.key});

  @override
  State<LevelsLockUnlock> createState() => _LevelsLockUnlockState();
}

class _LevelsLockUnlockState extends State<LevelsLockUnlock> {

  String u_id = "";
  List<Map<String, dynamic>> tableData = [];
  final TextStyle tabledata =
  const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 13);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.background,

      body: Container(child:  SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          child: Table(
            defaultColumnWidth: IntrinsicColumnWidth(),
            border: TableBorder.all(
                color: const Color.fromARGB(255, 78, 75, 75),
                width: 0.5),
            children: [
              TableRow(
                
                children: [
                  TableCell(
                    
                      child: Container(
                        constraints: BoxConstraints(minWidth: 60),
                        color: AppConfig.primaryColor,
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text(
                          'Sr. No.',
                          style: tabledata,
                        ),
                      )),

                  TableCell(

                      child: Container(
                        constraints: BoxConstraints(minWidth: 120),
                        color: AppConfig.primaryColor,
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text(
                          'Direct Business',
                          style: tabledata,
                        ),
                      )),
                  TableCell(
                      child: Container(
                        constraints: BoxConstraints(minWidth: 120),
                        color: AppConfig.primaryColor,
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text(
                          'Team Business',
                          style: tabledata,
                        ),
                      )),
                  TableCell(
                      child: Container(
                        constraints: BoxConstraints(minWidth: 120),
                        color: AppConfig.primaryColor,
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text(
                          'Status',
                          style: tabledata,
                        ),
                      )),

                ],
              ),
              for (var rowData in tableData)
                //int index = tableData.indexOf(rowData);
                TableRow(
                  children: [


                    TableCell(
                      child: Container(
                        color: tableData.indexOf(rowData)%2==0?Colors.grey.withOpacity(.2):Colors.grey.shade600,
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text(
                          (tableData.indexOf(rowData)+1).toString(),
                          style:tabledata
                        ),
                      ),
                    ),

                    TableCell(
                      child: Container(
                        color: tableData.indexOf(rowData)%2==0?Colors.grey.withOpacity(.2):Colors.grey.shade600,
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text(
                          rowData['directs_business'].toString(),
                          style: tabledata
                        ),
                      ),
                    ),
                    TableCell(
                        child: Container(
                          color: tableData.indexOf(rowData)%2==0?Colors.grey.withOpacity(.2):Colors.grey.shade600,
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Text(
                            rowData['team_business'].toString(),
                            style: tabledata
                          ),
                        )),


                    TableCell(
                        child: Container(
                          color: tableData.indexOf(rowData)%2==0?Colors.grey.withOpacity(.2):Colors.grey.shade600,
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Text(
                            rowData['status'].toString(),
                            style:tabledata
                          ),
                        )),

                  ],
                ),
            ],
          ),
        ),
      ),),


    );
  }

  @override
  void initState() {


    fetchPref();
    super.initState();
  }

  fetchPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String userId = prefs.get('u_id').toString();
    u_id = userId;

    hitApi(userId);
  }

  hitApi(id) {
    print("response=");
    //_makePayment();

    //_activePackage(id);

    showDialog(
        barrierDismissible: false,
        barrierColor: const Color(0x56030303),
        context: context!,
        builder: (_) => const Material(
          type: MaterialType.transparency,
          child: Center(
            // Aligns the container to center
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Please wait....",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ));

    callApi(id);
  }

  callApi(id) async {
    var requestBody = jsonEncode({
      "u_id": id,
    });

    print(requestBody);

    print("u_id=" + id);

    Map<String, String> headersnew = {
      "Content-Type": "application/json; charset=utf-8",
      "xyz": "",

    };

    // print(rootPathMain+apiPathMain+ApiData.preRequest);

    var response = await post(Uri.parse(ApiData.levelStatus),
        headers: headersnew, body: requestBody);

    String body = response.body;
    print("response=1111${response.statusCode}");
    if (response.statusCode == 200) {
      print("response=${response.body}");
      Map<String, dynamic> json = jsonDecode(response.body.toString());
      log("json=$body");
      if (Navigator.canPop(context!)) {
        Navigator.pop(context!);
      }
      fetchSuccess(json);
    } else {
      if (Navigator.canPop(context!)) {
        Navigator.pop(context!);
      }

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialogBox(
                type: "failure",
                title: "Failed Alert",
                desc: 'Oops! Something went wrong!');
          });
    }
  }

  Future<void> fetchSuccess(Map<String, dynamic> json) async {
    String tokenPrice = "";
    try {
      if (json['res'] == "success") {

        final data = json['data'];
        setState(() {
          tableData = List<Map<String, dynamic>>.from(data);

        });


        //{"total_directs":"0","active_directs":"0","inactive_directs":"0","total_gen":"0"}
      } else {
        String message = json['message'].toString();

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialogBox(
                  type: "failure", title: "Failed Alert", desc: message);
            });
      }
    } catch (e) {
      print(e.toString());
    }
  }


}
