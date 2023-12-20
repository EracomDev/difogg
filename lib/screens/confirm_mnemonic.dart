// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:math' hide log;
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:difog/screens/main_page.dart';
import 'package:difog/services/api_data.dart';
import '../services/wallet_service.dart';
import '../utils/app_config.dart';
import '../widgets/success_or_failure_dialog.dart';
import 'create_wallet_screen.dart';

class ConfirmMnemonics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: MnemonicConfirmationPage());
  }
}

class MnemonicConfirmationPage extends StatefulWidget {
  @override
  _MnemonicConfirmationPageState createState() =>
      _MnemonicConfirmationPageState();
}

class _MnemonicConfirmationPageState extends State<MnemonicConfirmationPage> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  List<String> mnemonics = [];
  List<int> randomNumbers = [];
  List<int?> selectedNumbers = [];
  String mnemonic = '';
  String ethAddress = '';
  String tronAddress = '';
  String privateKey = '';
  var size;

  bool isShowingProgress = false;
  TextEditingController referralController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMnemonic().then((_) {
      generateRandomNumbers();
      initializeSelectedNumbers();
    });
  }

  void initializeSelectedNumbers() {
    selectedNumbers = List<int?>.filled(randomNumbers.length, null);
  }

  void generateRandomNumbers() {
    var random = Random();
    randomNumbers =
        List<int>.generate(4, (_) => random.nextInt(mnemonics.length));
  }

  Future<void> fetchMnemonic() async {
    final dataArrayString = await secureStorage.read(key: 'tempWallet');
    if (dataArrayString != null) {
      final dataArray = json.decode(dataArrayString);
      mnemonic = dataArray[0][1];
      ethAddress = dataArray[1][1];
      tronAddress = dataArray[2][1];
      privateKey = dataArray[3][1];
      setState(() {
        mnemonics = mnemonic.split(' ');
      });
    }
  }

  Widget buildMnemonicItem(int index) {
    if (index >= randomNumbers.length) {
      return Container(); // Return an empty container or handle the out-of-range case
    }

    int mnemonicIndex = randomNumbers[index];
    String mnemonic = mnemonics[mnemonicIndex];

    return ListTile(
      title: Text(mnemonic),
      trailing: DropdownButton<int>(
        dropdownColor: AppConfig.background,
        value: selectedNumbers[index],
        hint: const Text(
          'Select Number',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        items: List.generate(12, (i) {
          return DropdownMenuItem<int>(
            value: i + 1,
            child: Text((i + 1).toString()),
          );
        }),
        onChanged: (int? selectedNumber) {
          setState(() {
            selectedNumbers[index] = selectedNumber;
          });
        },
      ),
    );
  }

  bool isConfirmationComplete() {
    return selectedNumbers.every((number) => number != null);
  }

  void confirmMnemonic() async {
    if (isConfirmationComplete()) {
      for (var i = 0; i < randomNumbers.length; i++) {
        if (mnemonics[randomNumbers[i]] != null &&
            randomNumbers[i] + 1 != selectedNumbers[i]) {
          // Mnemonic does not match the selected number
          // Handle the error condition
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: AppConfig.background,
                title: const Text('Error'),
                content: Text(
                    'Mnemonic does not match the selected number at position ${i + 1}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateWalletScreen()),
                      );
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
          return;
        }
      }

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

      // All mnemonics match the selected numbers
      // Proceed with the confirmation logic
      await secureStorage.write(key: 'mnemonic', value: mnemonic);
      await secureStorage.write(key: 'ethAddress', value: ethAddress);
      await secureStorage.write(key: 'tronAddress', value: tronAddress);
      await secureStorage.write(key: 'privateKey', value: privateKey);
      //print(wallets);
      // Create a new wallet object and add it to the array
      // Create a new wallet object
      Map<String, dynamic> newWallet = {
        'walletName': walletName!,
        'mnemonic': mnemonic,
        'ethAddress': ethAddress,
        'tronAddress': tronAddress,
        'privateKey': privateKey,
        'default': true
      };

// Get the existing wallet array
      List<Map<String, dynamic>> wallets = await getWalletArray();

      // Set default property to false for all existing wallets
      wallets = wallets.map((wallet) {
        wallet['default'] = false;
        return wallet;
      }).toList();

// Add the new wallet object to the array
      wallets.add(newWallet);

// Update the wallet array in secure storage
      await secureStorage.write(key: 'wallets', value: json.encode(wallets));

      confirmSuccessCall(sponsorId, ethAddress);
    } else {
      // Not all numbers have been selected
      // Handle the error condition
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: AppConfig.background,
            title: const Text('Error'),
            content: const Text('Please select all numbers.'),
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
    }
  }

  confirmSuccessCall(sponsorId, ethAddress) async {
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
        fetchResponse(json);
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

  Future<void> fetchResponse(Map<String, dynamic> json) async {
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
                child: contentBox(context, size,"Success","Wallet created successfully.","success"),
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
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppConfig.myBackground,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
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
                "Mnemonic Confirmation",
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
      body: SizedBox(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Select the number corresponding to each mnemonic word:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16.0),
                        Wrap(
                            //height: MediaQuery.of(context).size.height,
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                // todo comment this out and check the result
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: randomNumbers.length,
                                itemBuilder: (context, index) {
                                  return buildMnemonicItem(index);
                                },
                              ),
                            ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isShowingProgress)
              const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppConfig.primaryColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Please wait...")
                ],
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: confirmMnemonic,
        child: const Icon(Icons.check),
      ),
    );
  }
}
