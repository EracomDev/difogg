
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
  TransactionIncome({Key? key,required this.type,required this.title}) : super(key: key);

  @override
  State<TransactionIncome> createState() => _TransactionIncomeState();
}

class _TransactionIncomeState extends State<TransactionIncome> {
  bool isLoading = false;
  List<dynamic>? dashboardData;

  List<Map<String, dynamic>> dropdownData = [
    {"name": "All Incomes", "type": "all"},
    {"name": "Level Income", "type": "level"},
    {"name": "Daily Bonus", "type": "daily"},
    {"name": "Salary", "type": "salary"},
    {"name": "Free Income", "type": "free"},

  ];



  String selectedValue = "";

  @override
  void initState() {
    super.initState();
    fetchData();


    selectedValue=widget.type;
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

    var body = jsonEncode({'u_id': userId,"income_type":selectedValue,"init_val":"0"});

    try {
      var response = await http.post(url, body: body);
      print('res $response');

      if (response.statusCode == 200) {
        print('response.body ${response.body}');
        var jsonData = jsonDecode(response.body) as Map<String, dynamic>;

        log("jkbjkbkg hj ggiuguo gohioh");

        if (jsonData['res'] == "success") {
          final mydata = jsonData['data'];
          print("mydata $mydata");

          if(dashboardData!=null){
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


        showDialog(context: context,
            builder: (BuildContext context){
              return AlertDialogBox(
                type: "failure",
                title: "Failed Alert",
                desc: "Failed to fetch data",

              );
            }
        );
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
          style: TextStyle(color: Colors.white,fontSize: 18),

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
        child:



        Column(
          children: [

            if(widget.type=="all")

              Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(children: [
                  Text("Filter By",style: TextStyle(fontSize: 16),),

                  Spacer(),
                  Container(
                    width: MediaQuery.of(context).size.width*.5,
                    child: DropdownButtonFormField<String>(
                      value: selectedValue,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppConfig.textFieldColor,
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
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
                            style: const TextStyle(color: Colors.white),
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




                ],),
              ),

            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount:
                dashboardData != null ? dashboardData!.length : 0,
                itemBuilder: (context, index) {
                  final item = dashboardData![index];
                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        //padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        /*decoration:  BoxDecoration(
                          // color: MyColors.mainColor,
                            gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: [
                                  AppConfig.cardBackground,
                                  AppConfig.cardBackground.withOpacity(1),
                                  AppConfig.cardBackground.withOpacity(1),
                                ]),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10))),*/
                        child:
                        designNewCard(Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                item['debit_credit'] == "credit"
                                    ? Image.asset(
                                  "assets/images/wallet.png",
                                  width: 40,)
                                    : Image.asset(
                                    "assets/images/delete.png",
                                    width: 40),
                                const SizedBox(
                                    width:
                                    8), // Add spacing between the image and text
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Amount",
                                            style:TextStyle(
                                                color: Colors.white),
                                          ),
                                          const Spacer(), // Add spacing between "Amount" and "Value"

                                          Text(
                                            item['tx_type'] == "token"
                                                ? "${item['amount']}"
                                                : "\$ ${item['amount']} ",
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                          height:
                                          4), // Add vertical spacing
                                      Text(
                                        "${item['remark']}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${item['date']}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 11),
                                ),
                                item['status'] == "0"
                                    ? Text(
                                  "Pending",
                                  style: TextStyle(
                                      color: Colors.yellow),
                                )
                                    : item['status'] == "1"
                                    ? Text(
                                  "Success",
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 5, 236, 102)),
                                )
                                    : Text(
                                  "Failed",
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 17, 0)),
                                )
                              ],
                            )
                          ],
                        ))

                        ,
                      ));
                },
              ),
            ),
          ],
        ),
      )
          :  Container(

        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
            color: AppConfig.background,
            child: Column(

              children: [
                if(widget.type=="all")

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(children: [
                      Text("Filter By",style: TextStyle(fontSize: 16),),

                      Spacer(),
                      Container(
                        width: MediaQuery.of(context).size.width*.5,
                        child: DropdownButtonFormField<String>(
                          value: selectedValue,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppConfig.textFieldColor,
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25)),
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
                                style: const TextStyle(color: Colors.white),
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




                    ],),
                  ),

                Center(
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                      height: 200,
                      child: Lottie.asset('assets/images/no_data.json',
                          fit: BoxFit.contain,repeat: false),
                    ),

                    //Image.asset("assets/images/no_data.png",height: 200,width: 200,),
                    Text("Data Not Found",style: TextStyle(fontSize: 18),
                    ),
                  ],
                )
      ),
              ],
            ),
          ),
    );
  }
}
