// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:difog/components/MyPieChart.dart';
import 'package:difog/components/PortfolioCard.dart';
import 'package:difog/screens/my_packages.dart';
import 'package:difog/screens/tester.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:difog/screens/packages.dart';
import 'package:difog/screens/support.dart';
import 'package:difog/screens/transaction.dart';
import 'package:difog/screens/withdraw_page.dart';
import 'package:difog/services/api_data.dart';
import 'package:difog/utils/app_config.dart';
import '../models/home_menu.dart';
import '../utils/page_slider.dart';
import '../widgets/claim_popup.dart';
import '../widgets/complete_profile_popup.dart';
import '../widgets/success_or_failure_dialog.dart';
import 'fund_transfer.dart';
import 'transaction_income.dart';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

const List<Widget> Currency = <Widget>[
  Text('USD'),
  Text('DiFogg'),
];

class _DashboardPageState extends State<DashboardPage> {
  final List<bool> _selectedCurrency = <bool>[true, false];
  late SharedPreferences _prefs;
  String u_id = "";
  String packageAmount = "";
  String capping = "0";
  String earning = "0";
  String mainWallet = "0";
  String mainWalletToShow = "0";
  String dailyIncome = "0";
  String currencySign = "\$";
  bool isClaimable = false;
  var size;

  var isProfileUpdated = "";
  // String? selectedCurrency = 'USD';
  bool vertical = false;
  final List<HomeMenu> rechargeMenus = [
    HomeMenu(
      image: Image.asset(
        "assets/images/package.png",
        height: 24,
        width: 24,
      ),
      name: 'My Packages',
    ),
    HomeMenu(
      image: Image.asset(
        "assets/images/2.png",
        height: 24,
        width: 24,
      ),
      // image: "assets/images/ic_addmoney.png",
      name: 'Support',
    ),
    HomeMenu(
      image: Image.asset(
        "assets/images/6.png",
        height: 24,
        width: 24,
      ),
      // image: "assets/images/ic_addmoney.png",
      name: 'Withdraw',
    ),
    HomeMenu(
      image: Image.asset(
        "assets/images/money-bag.png",
        height: 24,
        width: 24,
      ),
      // image: "assets/images/ic_addmoney.png",
      name: 'Payments',
    ),
  ];

  List<dynamic> dataPackage = [];

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 26),
      body: Stack(
        children: [
          Positioned(
            left: MediaQuery.sizeOf(context).width * .5,
            bottom: -110,
            child: Container(
              height: 1,
              width: 1,
              // color: Colors.yellow,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF7043).withOpacity(.08),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 0, 65, 90)
                        .withOpacity(1), // Shadow color
                    blurRadius: 1011.0, // Blur radius
                    spreadRadius: 150.0, // Spread radius
                    offset: const Offset(
                        5.0, 5.0), // Offset in the x and y direction
                  ),
                ],
                //border: Border.all(style: BorderStyle.solid,width: 2,color: MyColors.primary.withOpacity(.6))
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Total Balance",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          mainWalletToShow,
                                          //"\$ 502,240.00",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 27,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          currencySign,
                                          style: const TextStyle(fontSize: 11),
                                        )
                                      ],
                                    )
                                  ]),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    "Currency",
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.grey),
                                  ),
                                  ToggleButtons(
                                    borderColor: AppConfig.primaryColor,
                                    onPressed: (int index) {
                                      setState(() {
                                        // The button that is tapped is set to true, and the others to false.
                                        for (int i = 0;
                                            i < _selectedCurrency.length;
                                            i++) {
                                          _selectedCurrency[i] = i == index;
                                        }

                                        if (index == 0) {
                                          mainWalletToShow = mainWallet;
                                          currencySign = "\$";
                                        } else {
                                          mainWalletToShow =
                                              (double.parse(mainWallet) /
                                                      double.parse(
                                                          AppConfig.tokenRate))
                                                  .toStringAsFixed(2);
                                          currencySign = "Difogg";
                                        }

                                        print(index);
                                      });
                                    },
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    selectedBorderColor: AppConfig.primaryColor,
                                    selectedColor: Colors.white,
                                    fillColor: AppConfig.primaryColor,
                                    color: Colors.white,
                                    constraints: const BoxConstraints(
                                      minHeight: 25.0,
                                      minWidth: 40.0,
                                    ),
                                    isSelected: _selectedCurrency,
                                    textStyle: const TextStyle(fontSize: 10),
                                    children: Currency,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "My Portfolio",
                          style: TextStyle(color: Colors.grey),
                        ),
                        InkWell(
                          child: const Row(
                            children: [
                              Text(
                                "View",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 100, 226, 201)),
                              ),
                              Icon(Icons.chevron_right,
                                  color: Color.fromARGB(255, 100, 226, 201))
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              SlidePageRoute(
                                page: MyPackages(data: dataPackage),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 300,
                    margin: const EdgeInsets.only(left: 10),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            height: MediaQuery.sizeOf(context).height,
                            width: 220,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: AppConfig.primaryColor.withOpacity(.40),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    width: 1,
                                    color: AppConfig.primaryColor
                                        .withOpacity(.20))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.asset(
                                        "assets/images/bitcoin.png",
                                        width: 40,
                                      ),
                                      const Text(
                                        "Overall",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ]),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    /*Column(
                                      children: [
                                        Text(
                                          "\$ ${packageAmount}",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromARGB(
                                                  255, 100, 226, 201)),
                                        ),
                                        Text(
                                          "Portfolio",
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),*/
                                    Column(
                                      children: [
                                        Text(
                                          "\$ ${capping}",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromARGB(
                                                  255, 100, 226, 201)),
                                        ),
                                        const Text(
                                          "Total Limit",
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "\$ ${earning}",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromARGB(
                                                  255, 100, 226, 201)),
                                        ),
                                        const Text(
                                          "Total Earning",
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                  child: MyPieChart(
                                    dataMap: {
                                      "Limit": double.parse(capping),
                                      "Earned": double.parse(earning),
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),

                          //dataPackage.map((e) => Container());

                          for (var item in dataPackage)
                            PortfolioCard(
                              packageName: "\$ " + item["order_amount"],
                              limit: double.parse(item["capping"]),
                              earned: double.parse(item["earning"]),
                            ),

                          if (dataPackage.length == 0)
                            PortfolioCard(
                              packageName: "\$ " + "0",
                              limit: double.parse("0"),
                              earned: double.parse("0"),
                            ),

                          /*PortfolioCard(
                            packageName: "Package 1",
                            limit: double.parse("100"),
                            earned: double.parse("25"),
                          ),
                          PortfolioCard(
                            packageName: "Package 2",
                            limit: double.parse("100"),
                            earned: double.parse("35"),
                          ),
                          PortfolioCard(
                            packageName: "Package 3",
                            limit: double.parse("100"),
                            earned: double.parse("75"),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "My Earning",
                              style: TextStyle(color: Colors.grey),
                            ),
                            InkWell(
                              child: const Row(
                                children: [
                                  Text(
                                    "View",
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
                                    page: TransactionIncome(
                                      type: "all",
                                      title: "Earnings",
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: AppConfig.myCardColor,
                              border: Border.all(color: AppConfig.myCardColor),
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Today's Total Income",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text("\$ $dailyIncome",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                FilledButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(isClaimable
                                                ? AppConfig.primaryColor
                                                : Colors.grey.shade600)),
                                    onPressed: () {
                                      if (isClaimable) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ClaimDialogBox(
                                                u_id: u_id,
                                              );
                                            });
                                      }

                                      //Navigator.push(context, MaterialPageRoute(builder:(context)=>ClaimAmount()));
                                    },
                                    child: const Text("Claim"))
                              ]),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppConfig.myCardColor),
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/gift.png",
                          height: 50,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Premium",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                        const Text(
                          "Upgrade to premium and enjoy priority access to high-paying gigs and opportunities.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          width: 200,
                          decoration: BoxDecoration(
                              color: AppConfig.primaryColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                SlidePageRoute(
                                  page: const Packages(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent),
                            child: Text(
                              'Subscribe Now',
                              style: TextStyle(
                                  color: AppConfig.titleIconAndTextColor,
                                  fontSize: 16),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.push(context,
                  //           MaterialPageRoute(builder: (context) => Tester()));
                  //     },
                  //     child: Text("go"))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rechargeHomeMenu(HomeMenu e) {
    return Container(
        child: InkWell(
      onTap: () {
        print("TapClicked");

        if (e.name == "My Packages") {
          Navigator.push(
            context,
            SlidePageRoute(
              page: const Packages(),
            ),
          );
        } else if (e.name == "Transfer") {
          Navigator.push(
            context,
            SlidePageRoute(
              page: const FundTransfer(),
            ),
          );
        } else if (e.name == "Support") {
          Navigator.push(
            context,
            SlidePageRoute(
              page: const Support(),
            ),
          );
        } else if (e.name == "Withdraw") {
          Navigator.push(
            context,
            SlidePageRoute(
              page: Withdraw(
                  main_wallet: mainWallet, live_rate: AppConfig.tokenRate),
            ),
          );
        } else if (e.name == "Payments") {
          Navigator.push(
            context,
            SlidePageRoute(
              page: Transaction(
                type: "all",
                title: "All",
              ),
            ),
          );
        }
        //Navigator.pushNamed(context, MyRoots.productDetail);
      }, // Handle your callback
      child: Container(
        //margin:EdgeInsets.symmetric(horizontal: 8,vertical: 8,),
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: e.image,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppConfig.primaryColor.withOpacity(.15),
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                //boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3),blurRadius: 1,offset: Offset(1, 1))]
              ),
            ),

            // e.image,

            const SizedBox(
              height: 4,
            ),

            Text(
              e.name,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * .03,
                  fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    )
        //padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
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

    hitApi(u_id);
  }

  hitApi(id) {
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

  void setConfigData(String data) {
    // Access the singleton instance of AppConfig
    AppConfig.instance.clientAddress = data;
    print(AppConfig.instance.clientAddress);
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

    var response = await post(Uri.parse(ApiData.dashboard),
        headers: headersnew, body: requestBody);

    String body = response.body;
    log("response=1111${response.body}");
    if (response.statusCode == 200) {
      print("response=${response.body}");
      Map<String, dynamic> json = jsonDecode(response.body.toString());
      log("json111111111111111=${json['deposit_address']}");
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      _checkIfShowDialog();
      setConfigData(json['deposit_address'].toString());
      fetchSuccess(json);
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
                desc: 'Oops! Something went wrong!');
          });
    }
  }

  Future<void> _checkIfShowDialog() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? showDialog = prefs.getBool('showPop');

    if (showDialog != null && showDialog == true) {
      prefs.setBool('showPop', false);
      fetchData();
    }
  }

  Future<void> fetchSuccess(Map<String, dynamic> json) async {
    String tokenPrice = "";
    try {
      if (json['res'] == "success") {
        packageAmount = json["package"].toString();
        //capping = json["capping"].toString();
        earning = json["pkg_earning"].toString();
        //earning ="1100";
        mainWallet = double.parse(json["wallets"]["main_wallet"].toString())
            .toStringAsFixed(2);
        isProfileUpdated = json["profile"]["profile_edited"].toString();
        // dailyIncome = json["incomes"]["daily"].toString();
        dailyIncome =
            double.parse(json["today_earning"].toString()).toStringAsFixed(2);
        mainWalletToShow = mainWallet;
        log("mainWalletToShow $mainWalletToShow");
        tokenPrice = json["token_rate"].toString();
        log("tokenPrice $tokenPrice");
        AppConfig.tokenRate = tokenPrice;
        isClaimable = json["claimable"] ?? false;

        dataPackage.clear();
        List<dynamic> dataList = await json["orders"];

        var format = DateFormat('yyyy-MM-DD');

        if (dataList.isNotEmpty) {
          int orderAmount = 0;
          int cappingOverAll = 0;

          for (int i = 0; i < dataList.length; i++) {
            DateTime newDate = format.parse(dataList[i]["added_on"].toString());
            orderAmount += int.parse(dataList[i]["order_amount"].toString());
            cappingOverAll = orderAmount * 3;

            if (double.parse(earning) >= cappingOverAll) {
              dataPackage.add({
                "package": dataList[i]["package"].toString(),
                "order_amount": dataList[i]["order_amount"].toString(),
                "capping": cappingOverAll.toString(),
                "earning": cappingOverAll.toString(),
                "added_on": DateFormat.yMMMd().format(newDate).toString(),
              });
            } else {
              dataPackage.add({
                "package": dataList[i]["package"].toString(),
                "order_amount": dataList[i]["order_amount"].toString(),
                "capping": cappingOverAll.toString(),
                "earning": earning.toString(),
                "added_on": DateFormat.yMMMd().format(newDate).toString(),
              });
            }
          }

          capping = cappingOverAll.toString();
        }

        setState(() {
          dataPackage;
          packageAmount;
        });

        if (isProfileUpdated == "0") {
          await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => WillPopScope(
                  onWillPop: () async => false,
                  child: CustomDialogBox(
                    function: (u_id) => hitApi(u_id),
                  ),
                ),
              ) ??
              false;
        }

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

  void _showDialogOnStart(String title, String des, String img) {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title, style: const TextStyle(color: Colors.black)),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Image.network(
                    img,
                    width: MediaQuery.sizeOf(context).width,
                    height: 200,
                    fit: BoxFit.contain,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      }
                    },
                  ),
                ),
                Text(
                  des,
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    });
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('u_id');
    print('token popup $userId');

    var url = Uri.parse(
        "https://test.mlmreadymade.com/token_app/jhg7q/user/other_content");

    try {
      var response = await http.get(url);
      print('res $response');

      if (response.statusCode == 200) {
        log('response.body ${response.body}');
        var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        if (jsonData['res'] == "success") {
          if (jsonData['popup'][0]['status'] == "1") {
            _showDialogOnStart(
                jsonData['popup'][0]['title'],
                jsonData['popup'][0]['description'],
                jsonData['popup'][0]['img_path']);
          }
        } else {}
      }
    } catch (error) {
      print('An error occurred: $error');
    }
  }
}
