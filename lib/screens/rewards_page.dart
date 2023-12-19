import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_data.dart';
import '../utils/app_config.dart';
import '../utils/card_design_new.dart';
import '../widgets/success_or_failure_dialog.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {

  String u_id = "";
  List<Map<String, dynamic>>data = [];

  bool isDataLoaded = false;

  final TextStyle packageText = const TextStyle(
      color: Color.fromARGB(255, 255, 255, 255),
      fontSize: 16,
      fontWeight: FontWeight.normal);

  final TextStyle heading = const TextStyle(
      color: Color.fromARGB(255, 255, 255, 255),
      fontSize: 14,
      fontWeight: FontWeight.normal);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.background,
      appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: AppConfig.background,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Rewards",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )),

      body: Container(child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (data.length > 0)
                for (var item in data)

                // item["order_amount"],
                //(item["capping"]),
                //e(item["earning"]),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: designNewCard(Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Rank",
                                style: heading,
                              ),
                              Text(item["rank"],
                                  style: packageText),
                            ],
                          ),
                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Days",
                                style: heading,
                              ),
                              Text(item["days"], style: packageText),
                            ],
                          ),

                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Direct Business",
                                style: heading,
                              ),
                              Text('${(item["direct_business"])}',
                                  style: packageText),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Team Business",
                                style: heading,
                              ),
                              Text("${(item["team_business"])}",
                                  style: packageText),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Status",
                                style: heading,
                              ),
                              Text("${(item["status"])}",
                                  style: TextStyle(
                                      color: (item["status"]).toString()=="Achieved"?Color.fromARGB(
                                          255, 64, 220, 77):Color.fromARGB(
                                          255, 227, 139, 14),
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),

                        ],
                      ),
                    )),),

              if(isDataLoaded && data.length==0)

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
                        const Text(
                          "Data Not Found",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    )),
            ],
          ),
        ),
      ),),


    );
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchPref();
    super.initState();
  }


  fetchPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String userId = prefs.get('u_id').toString();

    u_id = userId;
    hitApi();
  }


  hitApi() {
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

    callApi();
  }

  callApi() async {
    var requestBody = jsonEncode({
      "u_id": u_id,
    });



    print(requestBody);

    print("u_id=" + u_id);

    Map<String, String> headersnew = {
      "Content-Type": "application/json; charset=utf-8",
      "xyz": "",

    };

     print(ApiData.rewards);

    var response = await post(Uri.parse(ApiData.rewards),
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
    try {
      if (json['res'] == "success") {



        data.clear();

        Map<String, dynamic> dataMap = json["data"];

        for(var key in  dataMap.keys){
          data.add(dataMap[key]);

        }

        print(data.length);
        setState(() {
          data;
          isDataLoaded = true;
        });



        //{"total_directs":"0","active_directs":"0","inactive_directs":"0","total_gen":"0"}

       /* List<dynamic> dataList = json["data"];

        if (dataList.length > 0) {

        }*/
      } else {
        if (Navigator.canPop(context!)) {
          Navigator.pop(context!);
        }

        String message = json['message'];

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialogBox(
                  type: "failure", title: "Failed Alert", desc: message);
            });
      }
    } catch (e) {
      if (Navigator.canPop(context!)) {
        Navigator.pop(context!);
      }

      print(e.toString());
    }
  }
}
