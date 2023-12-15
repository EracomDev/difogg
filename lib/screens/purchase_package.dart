import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:difog/utils/card_design_new.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:difog/models/wallet.dart';
import 'package:web3dart/web3dart.dart';
import '../services/api_data.dart';
import '../services/transfer_service.dart';
import '../services/wallet_data.dart';
import '../utils/app_config.dart';
import '../widgets/success_or_failure_dialog.dart';
import 'main_page.dart';

class PurchasePackage extends StatefulWidget {
  String packageAmount;

  Function function;

  PurchasePackage(
      {super.key, required this.packageAmount, required this.function});

  @override
  State<PurchasePackage> createState() => _PurchasePackageState();
}

const List<Widget> Currency = <Widget>[
  Text('ERA'),
  Text('BNB'),
  Text('USDT'),
];

class _PurchasePackageState extends State<PurchasePackage> {
  final List<bool> _selectedCurrency = <bool>[true, false, false];
  bool isDataLoaded = false;
  String u_id = "";
  var size;

  String selected = "Select Type";

  String selectedSymbol = "none";

  String selectedRate = "";

  String balanceAvailable = "";
  String address = "";

  List<Map<String, dynamic>> dropdownData = [
    {
      "name": "Select Type",
      "symbol": "none",
      "price": "0.0",
      "amountUsd": "0.0",
      "address": "",
    },

    //{"name": "WM Point", "type": "wm_point"},
  ];

  @override
  Widget build(BuildContext context) {

    size=MediaQuery.of(context).size;
    //selected = dropdownData[0]["name"];
    return Scaffold(
      backgroundColor: AppConfig.myBackground,
      appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: AppConfig.background,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Purchase Package",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: designNewCard(Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Text("Select type"),

                Container(
                  //margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Text("Package Amount"),
                      const Spacer(),
                      Text(widget.packageAmount + " \$")
                    ],
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                DropdownButtonFormField<String>(
                  value: selected,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppConfig.textFieldColor,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      borderSide: BorderSide(
                        color: AppConfig.cardBackground,
                        width: 1.0,
                      ),
                    ),
                  ),
                  dropdownColor: AppConfig.primaryColor.withOpacity(1),
                  items: dropdownData.map((data) {
                    return DropdownMenuItem<String>(
                      value: data['name']!,
                      child: Text(
                        data['name']!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    var data = {};

                    for (var element in dropdownData) {
                      if (element['name'] == newValue) {
                        data = element;

                        selectedRate = element["price"].toString();
                        selectedSymbol = element["symbol"].toString();
                        balanceAvailable = element["amountUsd"].toString();
                        address = element["address"].toString();
                      }
                    }

                    print(data);

                    setState(() {
                      selected = newValue!;
                    });
                  },
                ),
               /* ToggleButtons(
                  borderColor: AppConfig.primaryColor,
                  onPressed: (int index) {
                    setState(() {
                      // The button that is tapped is set to true, and the others to false.
                      for (int i = 0; i < _selectedCurrency.length; i++) {
                        _selectedCurrency[i] = i == index;
                      }
                    });
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: AppConfig.primaryColor,
                  selectedColor: Colors.white,
                  fillColor: AppConfig.primaryColor,
                  color: Colors.white,
                  constraints: BoxConstraints(
                    minHeight: 50.0,
                    minWidth: MediaQuery.sizeOf(context).width / 4,
                  ),
                  isSelected: _selectedCurrency,
                  textStyle: const TextStyle(fontSize: 10),
                  children: Currency,
                ),*/
                if (selectedSymbol != "none")
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Available"),
                            Text(
                              (double.parse(balanceAvailable))
                                      .toStringAsFixed(2) +
                                  " $selectedSymbol",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Required"),
                            Text(
                                (double.parse(widget.packageAmount) /
                                            double.parse(selectedRate))
                                        .toStringAsFixed(2) +
                                    " $selectedSymbol",
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  ),
                if (isDataLoaded)
                  Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      child: const CircularProgressIndicator()),

                const SizedBox(
                  height: 16,
                ),
                if (!isDataLoaded)
                  InkWell(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          gradient: AppConfig.buttonGradient,
                          borderRadius: (BorderRadius.circular(20))),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Text(
                        "Purchase",
                        style: TextStyle(
                            color: AppConfig.titleIconAndTextColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    onTap: () async {
                      if (selectedSymbol != "none") {
                        if ((double.parse(widget.packageAmount) /
                                double.parse(selectedRate)) >
                            (double.parse(balanceAvailable))) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertDialogBox(
                                  type: "failure",
                                  title: "Failed Alert",
                                  desc: "Low Balance in selected wallet.",
                                );
                              });

                          return;
                        }

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


                        //BigInt value = BigInt.parse((BigInt.parse("1000")*BigInt.parse("1000000000000000000")).toString());



                        /*final amountInWei = (double.parse((double.parse(widget.packageAmount) /
                            double.parse(selectedRate))
                            .toStringAsFixed(2)) * pow(10, 18)).toInt();

                        final value = EtherAmount.inWei(BigInt.from(amountInWei));


                       */

                        /*final value = BigInt.parse((double.parse( (double.parse(widget.packageAmount) /
                            double.parse(selectedRate))
                            .toStringAsFixed(2)) * pow(10, 18)).toStringAsFixed(0));*/


                        //9223372036854775807
                        //9223372036854775807



                        //print(double.parse(((double.parse(widget.packageAmount))/double.parse(selectedRate)).toStringAsFixed(2)));
                        /*print((double.parse(widget.packageAmount) /
                            double.parse(selectedRate))
                            .toStringAsFixed(2));*/

                        //print(value);

                        String transactionResult = await transferAsset(
                            address,
                            "0xeBc186336f913bfdD1406f9F7fd1D23Ca5bc3ccb",
                            (double.parse(widget.packageAmount) /
                                double.parse(selectedRate))
                                .toStringAsFixed(2));

                        hitApi(u_id, transactionResult);
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialogBox(
                                type: "failure",
                                title: "Failed Alert",
                                desc: "Please Select transaction type.",
                              );
                            });
                      }
                    },
                  )
              ],
            ),
          )),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    fetchData();
  }

  fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String userId = prefs.get('u_id').toString();

    u_id = userId;

    setState(() {
      isDataLoaded = true;
    });
    final walletService = WalletService();

    try {
      List<WalletData> data = await walletService.getWallets(context);
      dropdownData.clear();
      dropdownData = [
        {
          "name": "Select Type",
          "symbol": "none",
          "price": "0.0",
          "amountUsd": "0.0",
          "address": "",
        },

        //{"name": "WM Point", "type": "wm_point"},
      ];

      for (int i = 0; i < data.length; i++) {
        var singleData = data[i];
        print(singleData.toString());

        print(singleData.cryptoName);

        dropdownData.add({
          "name": singleData.symbol,
          "symbol": singleData.symbol,
          "price": singleData.price,
          "amountUsd": singleData.balance,
          "address": singleData.cryptoName
        });
      }

      selected = "Select Type";
      selectedSymbol = "none";

      setState(() {
        isDataLoaded = false;
      });
    } catch (e) {
      print(e.toString());
    }


  }

  contentBox(context, size) {
    return Stack(
      children: <Widget>[

        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(top: 38),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54, offset: Offset(0, 4),
                    blurRadius: 10,
                    //https://twitter.com/zone_astronomy/status/1447864808808894470?t=JKgA51-MpMK4TUm8t1jxEg
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                const SizedBox(
                  height: 45,
                ),
                Text(
                  "Congratulations",
                  style: const TextStyle(
                    // color: widget.type == "success"
                    //     ? AppConfig.primaryText
                    //     : Colors.red,
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "You have purchased package of ${widget.packageAmount} \$",
                  style: const TextStyle(
                      color: Color.fromARGB(255, 88, 88, 88), fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 16,
                ),

                ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      foregroundColor:
                      MaterialStateProperty.all<Color>(
                          Colors.white),
                      backgroundColor:
                      MaterialStateProperty.all<Color>(
                          Colors.green),
                      shape: MaterialStateProperty.all<
                          RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                    onPressed: () {
                      //Navigator.of(context).pop();

                      Future.delayed(Duration(milliseconds: 250),(){
                        Navigator.pushAndRemoveUntil<dynamic>(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => const MainPage(),
                          ),
                              (route) =>
                          false, //if you want to disable back feature set to false
                        );

                      });

                      //Navigator.of(context).pop();
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Enjoy Your Earning Now",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ))),

              ],
            ),
          ),
        ),

        Positioned(
          left: 16,
          right: 16,
          child: Opacity(
            opacity: 1,
            child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(1),
                  // border: Border.all(width: 1,color: Colors.green)
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 63, 63, 63)
                          .withOpacity(1), // Shadow color
                      blurRadius: 5.0, // Blur radius
                      spreadRadius: 1.0, // Spread radius
                      offset:
                      const Offset(0, 0), // Offset in the x and y direction
                    ),
                  ],
                ),
                child: Image.asset(
                  "assets/images/gift.png",
                  height: 60,
                )),
          ),
        )
      ],
    );
  }

  hitApi(id, hash) {
    print("response=");
    //_makePayment();

    //_activePackage(id);

    callApi(id, hash);
  }

  callApi(id, hash) async {
    var requestBody = jsonEncode({
      "code": id,
      "type": selectedSymbol,
      "amount": widget.packageAmount,
      "tx_hash": hash,
    });

    print(requestBody);

    print("u_id=" + id);

    Map<String, String> headersnew = {
      "Content-Type": "application/json; charset=utf-8",
      "xyz": "",

      //"Authorization":"gGpjrL14ksvhIUTnj2Y2xdjoe623YWbKGbWSSe0ewD0gLtFjRqvpPaxDa2JVaFeBRz5U89Eq5VCCZmGdsl7sZc2lyNclvurR4vmtec67IjL6R2e75DT9cuuXZrjNP1frCZ1pCUeAHSemYiSuDSN29ptwJKCmeFF7uUHS5CxJB3Ee1waEWvvtHFxFvoDa0HGMvt5YxLZFmiPWpWv6MANggsaNOnx9PAjTSsZtjLP2DCjgH2bHtBVJOGPz7prtvJpx"
    };

    // print(rootPathMain+apiPathMain+ApiData.preRequest);

    var response = await post(Uri.parse(ApiData.autoTopup),
        headers: headersnew, body: requestBody);

    String body = response.body.toString();

    print("response=1111${response.statusCode}");
    print("body=1111${body}");
    if (response.statusCode == 200) {
      print("response=${response.body}");
      Map<String, dynamic> json = jsonDecode(response.body.toString());
      //log("json=$body");

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
              desc: "Oops! Something went wrong!",
            );
          });
    }
  }

  Future<void> fetchSuccess(Map<String, dynamic> json) async {
    try {
      if (json['res'] == "success") {
        fetchData();

        widget.function();

        await showDialog(
          barrierDismissible : false,
          context: context,
          builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: contentBox(context, size),
            ),
          ),
        )??false;


        //{"total_directs":"0","active_directs":"0","inactive_directs":"0","total_gen":"0"}
      } else {
        String message = json['message'].toString();

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialogBox(
                type: "failure",
                title: "Failed Alert",
                desc: message,
              );
            });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
