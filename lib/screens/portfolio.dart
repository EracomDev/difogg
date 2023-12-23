// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:difog/screens/rewards_page.dart';
import 'package:difog/screens/transaction.dart';
import 'package:difog/screens/withdraw_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:difog/utils/app_config.dart';

import '../components/incomes.dart';
import '../services/api_data.dart';
import '../utils/page_slider.dart';
import '../widgets/success_or_failure_dialog.dart';
import 'generation_team.dart';
import 'levels_lock_unlock.dart';

class PortFolio extends StatefulWidget {
  const PortFolio({super.key});

  @override
  State<PortFolio> createState() => _PortFolioState();
}

class _PortFolioState extends State<PortFolio> {
  var size;

 // Map<String, dynamic> jsonData = {};

  String balance = "0.00";
  String dailyClaim = "0.00";
  String referral = "0.00";
  String salary = "0.00";
  String freeClaim = "0.00";
  String activeDirect = "0";
  String inActiveDirect = "0";
  String totalDirect = "0";
  String totalGeneration = "0";

  final TextStyle heading = TextStyle(
      color: AppConfig.titleIconAndTextColor,
      fontSize: 16,
      fontWeight: FontWeight.w500);
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppConfig.myBackground,
      body: SizedBox(
        height:size.height,
        child: Stack(
          children: [

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
                        child: Row(
                          children: [
                            Text(
                              "Wallets",
                              style: heading,
                              textAlign: TextAlign.start,
                            ),
                            const Spacer(),
                            InkWell(
                              child: const Row(
                                children: [
                                  Text(
                                    "View History",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 100, 226, 201)),
                                  ),
                                  Icon(Icons.chevron_right,
                                      color: Color.fromARGB(255, 100, 226, 201))
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  SlidePageRoute(
                                    page: Transaction(
                                      type: "all",
                                      title: "Transaction",
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
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
                                          "Earning Wallet",
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
                                            balance,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  InkWell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                          color: AppConfig.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: const Text("Withdraw"),
                                    ),
                                    onTap: () {
                                      showConfirmDialog(context);

                                    },
                                  )

                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: size.width,
                        child: Text(
                          "Bonuses",
                          style: heading,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: HeadingWithImage(
                                letter: "D",
                                bgColor: Colors.orange,
                                currency: "",
                                name: 'Daily Claim Bonus',
                                value: dailyClaim,
                                imagePath: 'assets/images/wave3.png',
                                type: 'daily',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: HeadingWithImage(
                                letter: "R",
                                bgColor: Colors.blue,
                                currency: "",
                                name: 'Recommendations Bonus',
                                value: referral,
                                imagePath: 'assets/images/wave.png',
                                type: 'level',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: HeadingWithImage(
                                letter: "A",
                                bgColor: Colors.purple,
                                currency: "",
                                name: 'Appreciation Bonus',
                                value: salary,
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
                                name: 'Free Claim Bonus',
                                value: freeClaim,
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
                                        activeDirect,
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
                                        inActiveDirect,
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
                                      Text(totalDirect,
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
                                            totalGeneration,
                                            style: const TextStyle(
                                                fontSize: 25,
                                                color: Colors.white),
                                          ),
                                          InkWell(
                                            child: const Icon(
                                              Icons.north_east,
                                              color: AppConfig.primaryText,
                                              size: 20,
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const GenerationTeam()));
                                            },
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
                      const SizedBox(height: 16),

                      SizedBox(
                        width: size.width,
                        child: Row(
                          children: [

                            Expanded(
                              flex: 1,
                              child: InkWell(
                                child:

                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                      color: AppConfig.primaryColor.withOpacity(.2),
                                      border: Border.all(color: AppConfig.primaryColor,width: .5),
                                      borderRadius:
                                      BorderRadius.circular(20)),
                                  child: const Text("Achievements",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                                ),


                                onTap: () {
                                  Navigator.push(
                                    context,
                                    SlidePageRoute(
                                      page: LevelsLockUnlock(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 20,),

                            Expanded(
                              flex: 1,
                              child: InkWell(
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: AppConfig.primaryColor.withOpacity(.2),
                                      border: Border.all(color: AppConfig.primaryColor,width: .5),
                                      borderRadius:
                                      BorderRadius.circular(20)),
                                  child: const Text("Rewards",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    SlidePageRoute(
                                      page: RewardsPage(),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
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
        context: context,
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
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      try{

        balance=(double.tryParse(json["wallets"]["main_wallet"].toString()) ?? 0.00).toStringAsFixed(2);
        dailyClaim=(double.tryParse(json["incomes"]["daily"].toString())?? 0.00).toStringAsFixed(2);
        referral=(double.tryParse(json["incomes"]["level"].toString())?? 0.00).toStringAsFixed(2);
        salary=(double.tryParse(json["incomes"]["salary"].toString())?? 0.00).toStringAsFixed(2);
        freeClaim=(double.tryParse(json["incomes"]["free"].toString())?? 0.00).toStringAsFixed(2);
        activeDirect=json["teams"]["active_directs"].toString();
        inActiveDirect=json["teams"]["inactive_directs"].toString();
        totalDirect=json["teams"]["total_directs"].toString();
        totalGeneration=json["teams"]["total_gen"].toString();


      } catch(e){

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialogBox(
                type: "failure",
                title: "Failed Alert",
                desc: "Unable to load Data",
              );
            });

      }


      setState(() {
        totalGeneration;
      });

      //fetchSuccess(json);
    } else {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
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

  void showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          backgroundColor: const Color.fromARGB(255, 22, 59, 52),
          title: const Center(
            child: Text(
              'You should have BNB Balance to withdraw',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          content: Column(

            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Minimum balance of 0.00100000",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              const Text(
                "Minimum Withdrawal Limit Is \$10",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          actions: <Widget>[
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    SlidePageRoute(
                      page: Withdraw(
                        main_wallet: balance,
                      ),
                    ),
                  );
                },
                child: const Text('Understood'),
              ),
            ),
          ],
        );
      },
    );
  }
}
