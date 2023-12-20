// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:difog/screens/app_layout.dart';
import 'package:difog/screens/wallet_list.dart';
import '../screens/wallet.dart';
import '../services/api_data.dart';
import '../services/wallet_service.dart';
import '../utils/app_config.dart';
import '../utils/secure_storage.dart';
import '../widgets/success_or_failure_dialog.dart';
import 'main_page.dart';

class RestoreWallet extends StatefulWidget {
  @override
  State<RestoreWallet> createState() => _RestoreWalletWidgetState();
}

class _RestoreWalletWidgetState extends State<RestoreWallet> {
  @override
  Widget build(BuildContext context) {
    /*final currentRoute = ModalRoute.of(context)?.settings.name;
    print('Current Route: $currentRoute');*/
    return AppLayout(
      child: Scaffold(
        backgroundColor: AppConfig.myBackground,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: AppConfig.titleIconAndTextColor, //change your color here
          ),
          backgroundColor: AppConfig.myBackground,

          //systemOverlayStyle:SystemUiOverlayStyle(statusBarColor: MyColors.secondaryColor,statusBarBrightness: Brightness.light,statusBarIconBrightness: Brightness.light),

          elevation: 0,

          automaticallyImplyLeading: true,
          //brightness: Brightness.light,

          //brightness: Brightness.light,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  "Restore Wallet",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: AppConfig.titleIconAndTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Restore your wallet using mnemonics',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                MnemonicForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MnemonicForm extends StatefulWidget {
  @override
  _MnemonicFormState createState() => _MnemonicFormState();
}

class _MnemonicFormState extends State<MnemonicForm> {
  TextEditingController referralController = TextEditingController();
  final walletService = WalletService();
  final secureStorage = SecureStorage();
  String? mnemonic;
  String? ethAddress;
  String? tronAddress;
  String? privateKey;
  var size;
  bool isShowingProgress = false;
  bool _dialogCancelled = false;
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers =
      List.generate(12, (_) => TextEditingController());

  void _onFormSubmit() async {
    setState(() {
      isShowingProgress = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () async {
      if (_formKey.currentState!.validate()) {
        String mnemonics =
            _controllers.map((controller) => controller.text.trim()).join(' ');

        // Validate the mnemonic
        bool isValidMnemonic =
            await walletService.validateMnemonicWords(mnemonics);

        // If the mnemonic is invalid, show an error and return
        if (!isValidMnemonic) {

          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                backgroundColor: AppConfig.background,
                title: const Text('Invalid Mnemonic'),
                content: const Text(
                    'The provided mnemonic is not valid. Please enter a valid mnemonic.'),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {

                      setState(() {
                        isShowingProgress = false;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ) ??
              false;

          return;
        }

        // Generate wallet and save data to secure storage
        final wallet = await walletService.WalletWithMnimonics(mnemonics);
        await secureStorage.write('mnemonic', wallet.mnemonic);
        await secureStorage.write('ethAddress', wallet.ethAddress);
        await secureStorage.write('tronAddress', wallet.tronAddress);
        await secureStorage.write('privateKey', wallet.privateKey);

        // Display dialog box to enter wallet name

        confirmSuccessCall(wallet.ethAddress, wallet);

      }
    });
  }

  confirmSuccessCall(ethAddress, wallet) async {
    print("response=2");
    setState(() {
      isShowingProgress = true;
    });

    var requestBody = jsonEncode({
      "user_address": ethAddress,
    });

    log("requestBody = $requestBody");

    Map<String, String> headersnew = {
      "Content-Type": "application/json; charset=utf-8",
      "xyz": "",
    };

    Response response = await post(Uri.parse(ApiData.checkAddress),
        headers: headersnew, body: requestBody);

    String body = response.body;
    print("response=1111${response.statusCode}");
    if (response.statusCode == 200) {
      try {
        print("response=${response.statusCode}");
        Map<String, dynamic> json = jsonDecode(response.body.toString());
        log("json=$body");
        fetchResponse(json, wallet);
      } catch (e) {
        print(e.toString());
        setState(() {
          isShowingProgress = false;
        });

        showDialog(context: context,
            builder: (BuildContext context){
              return AlertDialogBox(
                type: "failure",
                title: "Failed Alert",
                desc: "Oops! Something went wrong!",

              );
            }
        );

      }
    } else {
      setState(() {
        isShowingProgress = false;
      });

      showDialog(context: context,
          builder: (BuildContext context){
            return AlertDialogBox(
              type: "failure",
              title: "Failed Alert",
              desc: "Oops! Something went wrong!",

            );
          }
      );
    }
  }

  Future<void> fetchResponse(
      Map<String, dynamic> jsonData, wallet) async {
    try {
      if (jsonData['res'] == "success") {
        var dataList = jsonData["data"];
        if(dataList!=null && dataList is List<dynamic> && dataList.isNotEmpty){
          List<Map<String, dynamic>> wallets = await getWalletArray();
          String? walletName;
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: AppConfig.background,
                title: const Text('Enter Wallet Name'),
                content: TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Wallet Name',
                      hintStyle: TextStyle(color: Colors.white)),
                  onChanged: (value) {
                    walletName = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a wallet name';
                    }
                    return null;
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      _dialogCancelled = true; // Set the flag to true when canceled

                      setState(() {
                        isShowingProgress=false;
                      });
                      Navigator.of(context).pop();

                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          walletName != null) {
                        print("callApi");
                        ethAddress = wallet.ethAddress;


                        Navigator.of(context).pop();

                        Map<String, dynamic> newWallet = {
                          'walletName': walletName,
                          'mnemonic': wallet.mnemonic,
                          'ethAddress': wallet.ethAddress,
                          'tronAddress': wallet.tronAddress,
                          'privateKey': wallet.privateKey,
                          'default': true
                        };

                        // Set default property to false for all existing wallets
                        wallets = wallets.map((wallet) {
                          wallet['default'] = false;
                          return wallet;
                        }).toList();
                        // Add the new wallet object to the array
                        wallets.add(newWallet);

                        // Update the wallet array in secure storage
                        await secureStorage.write('wallets', json.encode(wallets));
                        // Navigate to the ShowWallets screen

                        SharedPreferences prefs = await SharedPreferences.getInstance();

                        String session_key = jsonData["data"][0]['session_key'].toString();
                        String username = jsonData["data"][0]['username'].toString();
                        String u_id = jsonData["data"][0]['id'].toString();

                        prefs.setString('session_key', session_key);
                        prefs.setString('username', username);
                        prefs.setString('u_id', u_id);

                        String message = jsonData['message'].toString();


                        setState(() {
                          isShowingProgress = false;
                        });

                        await showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => WillPopScope(
                            onWillPop: () async => false,
                            child:  Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              child: contentBox(context, size,"Success","Wallet restore successfully.","success"),
                            )
                          ),
                        ) ??
                            false;

                      }
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );


        } else {

          String walletName = '';
          String sponsorId = '';

          FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

          final PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();
          final Uri? deepLink = data?.link;

          if (deepLink != null) {
            try {
              print(deepLink.queryParameters.toString());

              String id = deepLink.queryParameters['referral_id'].toString();
              //String position = deepLink.queryParameters['position'].toString();

              if (mounted) {

                setState(() {
                  sponsorId = id;
                  referralController.text=sponsorId;
                  //positionVal = position;
                });

              }

              print("referral_id = $id");
            } catch (e) {
              print("Error1=$e");
            }
          }

          dynamicLinks.onLink.listen((dynamicLinkData) {
            Uri uri = dynamicLinkData.link;

            if (uri != null) {
              try {
                String id = uri.queryParameters['referral_id'].toString();
                //String position = uri.queryParameters['position'].toString();
                print("referral_id = $id");

                if (mounted) {
                  setState(() {
                    sponsorId = id;
                    referralController.text=sponsorId;
                    //positionVal = position;
                  });
                }
              } catch (e) {
                print("Error2=$e");
              }
            }

            //Navigator.pushNamed(context, dynamicLinkData.link.path);
          }).onError((error) {
            print('onLink error');
            print(error.message);
          });

          // Show a dialog to get the wallet name
          await showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    backgroundColor: AppConfig.background,
                    title: const Text('Enter Following Data'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          onChanged: (value) {
                            walletName = value;
                          },
                          decoration: const InputDecoration(
                              hintText: 'Wallet Name',
                              hintStyle: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: referralController,
                          onChanged: (value) {
                            sponsorId = value;
                          },
                          decoration: const InputDecoration(
                              hintText: 'Sponsor Id',
                              hintStyle: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(walletName);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          );

          if (walletName == "" || referralController.text == "") {
            // Wallet name not provided
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: AppConfig.background,
                  title: const Text('Error'),
                  content: const Text('Please provide required data.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
            return;
          }

          ethAddress = wallet.ethAddress;


          //Navigator.of(context).pop();

          List<Map<String, dynamic>> wallets = await getWalletArray();

          Map<String, dynamic> newWallet = {
            'walletName': walletName,
            'mnemonic': wallet.mnemonic,
            'ethAddress': wallet.ethAddress,
            'tronAddress': wallet.tronAddress,
            'privateKey': wallet.privateKey,
            'default': true
          };

          // Set default property to false for all existing wallets
          wallets = wallets.map((wallet) {
            wallet['default'] = false;
            return wallet;
          }).toList();
          // Add the new wallet object to the array
          wallets.add(newWallet);

          // Update the wallet array in secure storage
          await secureStorage.write('wallets', json.encode(wallets));


          confirmAddId(sponsorId, ethAddress);

        }

        //HashMap<String,dynamic> myInfo = jsonDecode(json['myaccount_info'].toString());
      } else if (jsonData['res'] == "error") {

        setState(() {
          isShowingProgress = false;
        });

        String message = jsonData['error'];

        message = message.replaceAll("</p>", "").replaceAll("<p>", "");

        showDialog(context: context,
            builder: (BuildContext context){
              return AlertDialogBox(
                type: "failure",
                title: "Failed Alert",
                desc: message.toString(),

              );
            }
        );


      } else {
        setState(() {
          isShowingProgress = false;
        });

      }
    } catch (e) {
      setState(() {
        isShowingProgress = false;
      });

      showDialog(context: context,
          builder: (BuildContext context){
            return AlertDialogBox(
              type: "failure",
              title: "Failed Alert",
              desc: "Oops! Something went wrong!",

            );
          }
      );

      print(e.toString());
    }
  }


  confirmAddId(sponsorId, ethAddress) async {
    print("response=2");
    setState(() {
      isShowingProgress = true;
    });

    var requestBody = jsonEncode({
      "referrer_id": sponsorId,
      "userwallet": ethAddress,
    });

    log("requestBody = $requestBody");

    /*print("selected_pin="+selectedAmount);
    print("tx_username="+username);
    print("selected_wallet="+selectedWalletValue);
    print("session_key="+session_key);*/

    Map<String, String> headersnew = {
      "Content-Type": "application/json; charset=utf-8",
      "xyz": "",
    };

    Response response = await post(Uri.parse(ApiData.registerPath),
        headers: headersnew, body: requestBody);

    String body = response.body;
    print("response=1111${response.statusCode}");
    if (response.statusCode == 200) {
      try {
        print("response=${response.statusCode}");
        Map<String, dynamic> json = jsonDecode(response.body.toString());
        log("json=$body");
        fetchResponse2(json);
      } catch (e) {
        print(e.toString());
        setState(() {
          isShowingProgress = false;
        });
        showDialog(context: context,
            builder: (BuildContext context){
              return AlertDialogBox(
                type: "failure",
                title: "Failure Alert",
                desc: "Oops! Something went wrong!",

              );
            }
        );

      }
    } else {
      setState(() {
        isShowingProgress = false;
      });

      showDialog(context: context,
          builder: (BuildContext context){
            return AlertDialogBox(
              type: "failure",
              title: "Failure Alert",
              desc: "Oops! Something went wrong!",

            );
          }
      );
    }
  }

  Future<void> fetchResponse2(Map<String, dynamic> json) async {
    try {
      if (json['res'] == "success") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String session_key = json['session_key'].toString();
        String username = json['username'].toString();
        String u_id = json['code'].toString();

        prefs.setString('session_key', session_key);
        prefs.setString('username', username);
        prefs.setString('u_id', u_id);

        String message = json['message'].toString();



        setState(() {
          isShowingProgress = false;
        });

        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => WillPopScope(
              onWillPop: () async => false,
              child:  Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: contentBox(context, size,"Success","Wallet restore successfully.","success"),
              )
          ),
        ) ??
            false;
        //HashMap<String,dynamic> myInfo = jsonDecode(json['myaccount_info'].toString());
      } else if (json['res'] == "error") {
        setState(() {
          isShowingProgress = false;
        });

        String message = json['error'];

        message = message.replaceAll("</p>", "").replaceAll("<p>", "");

        showDialog(context: context,
            builder: (BuildContext context){
              return AlertDialogBox(
                type: "failure",
                title: "Failed Alert",
                desc: message,

              );
            }
        );

      } else {
        setState(() {
          isShowingProgress = false;
        });

        String message = json['message'];
        showDialog(context: context,
            builder: (BuildContext context){
              return AlertDialogBox(
                type: "failure",
                title: "Failed Alert",
                desc: message,

              );
            }
        );
      }
    } catch (e) {
      setState(() {
        isShowingProgress = false;
      });


      showDialog(context: context,
          builder: (BuildContext context){
            return AlertDialogBox(
                type: "failure",
                title: "Failed Alert",
                desc: 'Oops! Something went wrong!'

            );
          }
      );


      print(e.toString());
    }
  }

  contentBox(context, size,title,desc,type) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppConfig.background, offset: const Offset(0, 4),
                    blurRadius: 10,
                    //https://twitter.com/zone_astronomy/status/1447864808808894470?t=JKgA51-MpMK4TUm8t1jxEg
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    // color: widget.type == "success"
                    //     ? AppConfig.primaryText
                    //     : Colors.red,
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                type == "failure"
                    ? Image.asset(
                  "assets/images/error.png",
                  width: 100,
                )
                    : Image.asset(
                  "assets/images/success.png",
                  width: 100,
                ),
                const SizedBox(height: 10),
                Text(
                  desc,
                  style: const TextStyle(color: Colors.black, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 150,
                        child: TextButton(
                          onPressed: () {

                            Navigator.pushAndRemoveUntil<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) => const MainPage(),
                              ),
                                  (route) =>
                              false, //if you want to disable back feature set to false
                            );

                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  AppConfig.primaryColor.withOpacity(1))),
                          child: const Text(
                            "OK",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    /* setState(() {
      isShowingProgress=false;
    });*/

    size = MediaQuery.of(context).size;
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _buildMnemonicFields(),
            ),
            const SizedBox(height: 16),
            if (isShowingProgress) const CircularProgressIndicator(),
            if (!isShowingProgress)
              Container(
                width: 200,
                decoration: BoxDecoration(
                    gradient: AppConfig.buttonGradient,
                    borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
                  onPressed: _onFormSubmit,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent),
                  child: Text(
                    'Restore',
                    style: TextStyle(color: AppConfig.titleIconAndTextColor),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMnemonicFields() {
    return List.generate(12, (index) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * .42,
        child: TextFormField(
          controller: _controllers[index],
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            fillColor: AppConfig.myCardColor,
            labelText: 'Word ${index + 1}',
            labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            hintStyle: const TextStyle(fontSize: 10),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {

                setState(() {
                  isShowingProgress = false;
                });

              return 'Please enter word ${index + 1}';


            }
            return null;
          },
        ),
      );
    });
  }
}
