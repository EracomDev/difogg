import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:difog/models/wallet.dart';
import '../services/api_data.dart';
import '../services/transfer_service.dart';
import '../services/wallet_data.dart';
import '../utils/app_config.dart';
import '../widgets/success_or_failure_dialog.dart';

class PurchasePackage extends StatefulWidget {
  String packageAmount;

  Function function;

  PurchasePackage(
      {super.key, required this.packageAmount, required this.function});

  @override
  State<PurchasePackage> createState() => _PurchasePackageState();
}

class _PurchasePackageState extends State<PurchasePackage> {
  bool isDataLoaded = false;
  String u_id = "";

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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Container(
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
                  dropdownColor: AppConfig.cardBackground,
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

                        String transactionResult = await transferAsset(
                            address,
                            "0xeBc186336f913bfdD1406f9F7fd1D23Ca5bc3ccb",
                            (double.parse(widget.packageAmount) /
                                    double.parse(selectedRate))
                                .toStringAsFixed(2));

                        print(transactionResult);

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
          ),
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

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialogBox(
                type: "success",
                title: "Success Alert",
                desc: "Package Purchased successfully.",
              );
            });

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
