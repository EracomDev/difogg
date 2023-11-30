import 'dart:convert';
import 'dart:developer';

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
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: AppConfig.titleIconAndTextColor, //change your color here
          ),
          backgroundColor: AppConfig.titleBarColor,

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


                Text("Restore Wallet",
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
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Restore your wallet using mnemonics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
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
  final walletService = WalletService();
  final secureStorage = SecureStorage();
  String? mnemonic;
  String? ethAddress;
  String? tronAddress;
  String? privateKey;
  bool isShowingProgress = false;
  bool _dialogCancelled = false;
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers =
  List.generate(12, (_) => TextEditingController());

  void _onFormSubmit() async {

    setState(() {
      isShowingProgress = true;
    });

    Future.delayed(Duration(milliseconds: 500),() async {
      if (_formKey.currentState!.validate()) {
        String mnemonics = _controllers.map((controller) => controller.text.trim()).join(' ');

        // Validate the mnemonic
        bool isValidMnemonic = await walletService.validateMnemonicWords(mnemonics);

        // If the mnemonic is invalid, show an error and return
        if (!isValidMnemonic) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: AppConfig.background,
                title: Text('Invalid Mnemonic'),
                content: Text('The provided mnemonic is not valid. Please enter a valid mnemonic.'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          return;
        }

        // Generate wallet and save data to secure storage
        final wallet = await walletService.WalletWithMnimonics(mnemonics);
        await secureStorage.write('mnemonic', wallet.mnemonic);
        await secureStorage.write('ethAddress', wallet.ethAddress);
        await secureStorage.write('tronAddress', wallet.tronAddress);
        await secureStorage.write('privateKey', wallet.privateKey);

        // Display dialog box to enter wallet name
        String? walletName;
        await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppConfig.background,
            title: Text('Enter Wallet Name'),
            content: TextFormField(
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
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && walletName != null) {

                    print("callApi");
                    ethAddress = wallet.ethAddress;
                    confirmSuccessCall(ethAddress,wallet,walletName);

                    /*if (!_dialogCancelled && walletName != null) {
                      // Create a new wallet object
                      // Get the existing wallet array



                    }*/
                    Navigator.of(context).pop();
                  }
                },
                child: Text('OK'),
              ),
            ],
          );
        },
        );


      }

    });


  }

  confirmSuccessCall(ethAddress,wallet,walletName) async {

    print("response=2");
    setState(() {
      isShowingProgress = true;
    });


    var requestBody = jsonEncode({


      "user_address":ethAddress,


    });

    log("requestBody = $requestBody");

    /*print("selected_pin="+selectedAmount);
    print("tx_username="+username);
    print("selected_wallet="+selectedWalletValue);
    print("session_key="+session_key);*/



    Map<String, String> headersnew ={
      "Content-Type":"application/json; charset=utf-8",
      "xyz":"",

    };


    Response response = await post(Uri.parse(ApiData.checkAddress),

        headers: headersnew,
        body: requestBody);


    String body = response.body;
    print("response=1111${response.statusCode}");
    if(response.statusCode==200){
      try{
        print("response=${response.statusCode}");
        Map<String, dynamic> json = jsonDecode(response.body.toString());
        log("json=$body");
        fetchResponse(json,wallet,walletName);

      }
      catch(e){
        print(e.toString());
        setState(() {
          isShowingProgress = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Oops! Something went wrong!'),
        ));
      }

    } else {
      setState(() {
        isShowingProgress = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Oops! Something went wrong!'),
      ));
    }

  }

  Future<void> fetchResponse(Map<String, dynamic> jsonData,wallet,walletName) async {


    try{

      if(jsonData['res']=="success"){



        List<Map<String, dynamic>> wallets = await getWalletArray();
        // Check if ethAddress already exists in the wallets list





        //bool isEthAddressExists = wallets.any((wallet) => wallet['ethAddress'] == ethAddress);

        /*if (isEthAddressExists) {
          // If ethAddress already exists, don't proceed
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: AppConfig.background,
                title: Text('Wallet Exists'),
                content: Text('A wallet with the same ethAddress already exists.'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WalletList()),
                      );
                    },
                  ),
                ],
              );
            },
          );
          return;
        }*/
        // Create a new wallet object
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
        /*Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WalletList()),
        );*/

        SharedPreferences prefs = await SharedPreferences.getInstance();


        String session_key = jsonData["data"][0]['session_key'].toString();
        String username = jsonData["data"][0]['username'].toString();
        String u_id = jsonData["data"][0]['id'].toString();

        prefs.setString('session_key',session_key);
        prefs.setString('username',username);
        prefs.setString('u_id',u_id);

        String message = jsonData['message'].toString();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));


        setState(() {



          isShowingProgress = false;


        });


        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: AppConfig.background,
              title: Text('Success'),
              content: Text('Wallet restore successfully.'),
              actions: [
                TextButton(
                  onPressed: () {

                    Navigator.pushAndRemoveUntil<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => MainPage(),
                      ),
                          (route) => false,//if you want to disable back feature set to false
                    );
                    /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CryptoWalletDashboard()),
                  );*/
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        //HashMap<String,dynamic> myInfo = jsonDecode(json['myaccount_info'].toString());


      }
      else if(jsonData['res']=="error"){


        setState(() {
          isShowingProgress = false;
        });

        String message = jsonData['error'];

        message = message.replaceAll("</p>", "").replaceAll("<p>", "");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }

      else {


        setState(() {
          isShowingProgress = false;
        });

        /*String message = jsonData['message'];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));*/
      }

    } catch(e){

      setState(() {
        isShowingProgress = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Oops! Something went wrong!'),
      ));

      print(e.toString());

    }

  }


  @override
  Widget build(BuildContext context) {

   /* setState(() {
      isShowingProgress=false;
    });*/
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _buildMnemonicFields(),
            ),
            SizedBox(height: 16),

            if(isShowingProgress)


              CircularProgressIndicator(),

            if(!isShowingProgress)

              Container(

                width: 200,
                decoration: BoxDecoration(gradient:

                AppConfig.buttonGradient,borderRadius: BorderRadius.circular(20)

                ),
                child: ElevatedButton(
                  onPressed: _onFormSubmit,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                  child: Text('Restore',style: TextStyle(color: AppConfig.titleIconAndTextColor),),
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
        width: MediaQuery.of(context).size.width*.42,
        child: TextFormField(
          controller: _controllers[index],
          style: TextStyle(fontSize: 16),
          decoration: InputDecoration(
            labelText: 'Word ${index + 1}',
            contentPadding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),

            hintStyle: TextStyle(fontSize: 12),

          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter word ${index + 1}';
            }
            return null;
          },
        ),
      );
    });
  }
}

