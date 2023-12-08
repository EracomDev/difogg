import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:difog/utils/app_config.dart';

import '../components/incomes.dart';
import '../services/api_data.dart';
import '../widgets/success_or_failure_dialog.dart';

class PortFolio extends StatefulWidget {
  const PortFolio({super.key});

  @override
  State<PortFolio> createState() => _PortFolioState();
}

class _PortFolioState extends State<PortFolio> {
  var size;

  Map<String, dynamic> jsonData = {};

  final TextStyle heading = TextStyle(
      color: AppConfig.titleIconAndTextColor,
      fontSize: 16,
      fontWeight: FontWeight.w500);
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppConfig.myBackground,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // Positioned(
            //   right: -180,
            //   top: 150,
            //   child: Container(
            //     height: size.width * .6,
            //     width: size.width * .6,
            //     // color: Colors.yellow,
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       color: const Color(0xFFFF7043).withOpacity(.08),
            //       //border: Border.all(style: BorderStyle.solid,width: 2,color: MyColors.secondary.withOpacity(.6))
            //       boxShadow: [
            //         BoxShadow(
            //           color: const Color.fromARGB(255, 0, 65, 90)
            //               .withOpacity(1), // Shadow color
            //           blurRadius: 1011.0, // Blur radius
            //           spreadRadius: 100.0, // Spread radius
            //           offset: const Offset(
            //               5.0, 5.0), // Offset in the x and y direction
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // Positioned(
            //   left: MediaQuery.sizeOf(context).width * .5,
            //   bottom: -110,
            //   child: Container(
            //     height: 1,
            //     width: 1,
            //     // color: Colors.yellow,
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,

            //       boxShadow: [
            //         BoxShadow(
            //           color:
            //               AppConfig.primaryColor.withOpacity(1), // Shadow color
            //           blurRadius: 1000.0, // Blur radius
            //           spreadRadius: 150.0, // Spread radius
            //           offset: const Offset(
            //               5.0, 5.0), // Offset in the x and y direction
            //         ),
            //       ],
            //       //border: Border.all(style: BorderStyle.solid,width: 2,color: MyColors.primary.withOpacity(.6))
            //     ),
            //   ),
            // ),
            Container(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: size.width,
                        child: Text(
                          "Wallets",
                          style: heading,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              decoration: BoxDecoration(
                                  color: AppConfig.myCardColor,
                                  border: Border.all(
                                      color: AppConfig.myCardColor, width: 0.4),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth: size.width * .32),
                                        child: Text(
                                          "Main Wallet",
                                          style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(.5),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            AppConfig.currency,
                                            style: const TextStyle(
                                                fontSize: 17,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            jsonData["wallets"] == null
                                                ? "0.0"
                                                : jsonData["wallets"]
                                                    ["main_wallet"],
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  FilledButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.add),
                                      label: const Text("Add"))
                                ],
                              ),
                            ),
                          ),
                          /* const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          // color: MyColors.containerColor,
                            gradient: AppConfig.containerGradient,
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Image.asset("assets/images/wallet.png", width: 30),
                            const SizedBox(width: 5),
      
      
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
      
                                Container(
                                  constraints: BoxConstraints(maxWidth: size.width*.32),
                                  child: const Text(
                                    "Fund Wallet",
                                    style: TextStyle(color: Colors.white,fontSize: 12),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text( "0.00",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),*/
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: size.width,
                        child: Text(
                          "Incomes",
                          style: heading,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: HeadingWithImage(
                                letter: "L",
                                bgColor: Colors.blue,
                                currency: "",
                                name: 'Level Income',
                                value: jsonData["incomes"] == null
                                    ? "0.0"
                                    : jsonData["incomes"]["level"].toString(),
                                imagePath: 'assets/images/wave.png',
                                type: 'level',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: HeadingWithImage(
                                letter: "D",
                                bgColor: Colors.orange,
                                currency: "",
                                name: 'Daily Bonus',
                                value: jsonData["incomes"] == null
                                    ? "0.0"
                                    : jsonData["incomes"]["daily"].toString(),
                                imagePath: 'assets/images/wave3.png',
                                type: 'daily',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: HeadingWithImage(
                                letter: "S",
                                bgColor: Colors.purple,
                                currency: "",
                                name: 'Salary',
                                value: jsonData["incomes"] == null
                                    ? "0.0"
                                    : jsonData["incomes"]["salary"].toString(),
                                imagePath: 'assets/images/wave.png',
                                type: 'salary',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: HeadingWithImage(
                                letter: "F",
                                bgColor: Colors.green,
                                currency: "",
                                name: 'Free Income',
                                value: jsonData["incomes"] == null
                                    ? "0.0"
                                    : jsonData["incomes"]["free"].toString(),
                                imagePath: 'assets/images/wave3.png',
                                type: 'free',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      SizedBox(
                        width: size.width,
                        child: Text(
                          "Team",
                          style: heading,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppConfig.myCardColor, width: 0.4),
                            color: AppConfig.myCardColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        jsonData["teams"] == null
                                            ? "0.0"
                                            : jsonData["teams"]
                                                    ["active_directs"]
                                                .toString(),
                                        style: const TextStyle(
                                            fontSize: 25, color: Colors.white),
                                      ),
                                      Text(
                                        "Active Directs",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white.withOpacity(.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //const Spacer(),
                                      Text(
                                        jsonData["teams"] == null
                                            ? "0.0"
                                            : jsonData["teams"]
                                                    ["inactive_directs"]
                                                .toString(),
                                        style: const TextStyle(
                                            fontSize: 25, color: Colors.white),
                                      ),
                                      Text(
                                        "Inactive Directs",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white.withOpacity(.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        jsonData["teams"] == null
                                            ? "0.0"
                                            : jsonData["teams"]["total_directs"]
                                                .toString(),
                                        style: const TextStyle(
                                            fontSize: 25, color: Colors.white),
                                      ),
                                      Text(
                                        "Total Directs",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white.withOpacity(.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            jsonData["teams"] == null
                                                ? "0.0"
                                                : jsonData["teams"]["total_gen"]
                                                    .toString(),
                                            style: const TextStyle(
                                                fontSize: 25,
                                                color: Colors.white),
                                          ),
                                          const Icon(
                                            Icons.north_east,
                                            color: AppConfig.primaryText,
                                            size: 20,
                                          )
                                        ],
                                      ),
                                      Text(
                                        "Total Generation ",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white.withOpacity(.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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

      //"Authorization":"gGpjrL14ksvhIUTnj2Y2xdjoe623YWbKGbWSSe0ewD0gLtFjRqvpPaxDa2JVaFeBRz5U89Eq5VCCZmGdsl7sZc2lyNclvurR4vmtec67IjL6R2e75DT9cuuXZrjNP1frCZ1pCUeAHSemYiSuDSN29ptwJKCmeFF7uUHS5CxJB3Ee1waEWvvtHFxFvoDa0HGMvt5YxLZFmiPWpWv6MANggsaNOnx9PAjTSsZtjLP2DCjgH2bHtBVJOGPz7prtvJpx"
    };

    // print(rootPathMain+apiPathMain+ApiData.preRequest);

    var response = await post(Uri.parse(ApiData.dashboard),
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

      jsonData = json;

      setState(() {
        jsonData;
      });
      //fetchSuccess(json);
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
              desc: "Oops! Something went wrong!",
            );
          });
    }
  }

  /*Future<void> fetchSuccess(Map<String, dynamic> json) async {


    try{

      if(json['res']=="success"){

        packageAmount=json["package"].toString();
        mainWallet=json["wallets"]["main_wallet"].toString();

        setState(() {
          packageAmount;
        });




      } else {



        String message = json['message'];


      }


    } catch(e){




      print(e.toString());

    }


  }*/
}
