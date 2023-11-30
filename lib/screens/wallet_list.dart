import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/create_wallet_screen.dart';
import '../utils/app_config.dart';
import '../utils/secure_storage.dart';

class WalletList extends StatefulWidget {
  @override
  _WalletsPageState createState() => _WalletsPageState();
}

class _WalletsPageState extends State<WalletList> {
  List<Map<String, dynamic>> walletsArray = [];
  bool isDefaultWallet(int index) {
    return walletsArray[index]['default'] ?? false;
  }
  @override
  void initState() {
    super.initState();
    // Call the function to retrieve the wallets array from storage
    retrieveWalletsArrayFromStorage();
  }

  Future<void> retrieveWalletsArrayFromStorage() async {
    final secureStorage = SecureStorage();
    String? walletsString = await secureStorage.read('wallets');
    //print('walletsString: $walletsString'); // Add this line to check the value

    if (walletsString != null && walletsString.isNotEmpty) {
      List<dynamic> decodedData = [];
      try {
        decodedData = jsonDecode(walletsString);
        //decodedData.removeLast();
        // await secureStorage.write(key: 'wallets', value: json.encode(decodedData.removeLast()));
        //print('decodedData: $decodedData'); // Add this line to check the decoded data
      } catch (e) {
        print('Error decoding JSON: $e');
      }

      if (decodedData is List<dynamic>) {
        walletsArray = decodedData
            .cast<Map<String, dynamic>>(); // Cast items to Map<String, dynamic>
      } else {
        print('Invalid JSON data');
      }
    }

    setState(() {});
  }



  String shortenEthAddress(String ethAddress) {
    if (ethAddress.length > 10) {
      final firstCharacters = ethAddress.substring(0, 8);
      final lastCharacters = ethAddress.substring(ethAddress.length - 8);
      return '$firstCharacters...$lastCharacters';
    }
    return ethAddress;
  }

  void makeDefaultWallet(int index) async {
    setState(() {
      // Set 'default' to true for the selected wallet
      for (int i = 0; i < walletsArray.length; i++) {
        walletsArray[i]['default'] = i == index;
      }
    });

    // Retrieve the default wallet
    final defaultWallet = walletsArray[index];

    // Save the default wallet's details to secure storage
    final secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: 'mnemonic', value: defaultWallet['mnemonic']);
    await secureStorage.write(key: 'ethAddress', value: defaultWallet['ethAddress']);
    await secureStorage.write(key: 'tronAddress', value: defaultWallet['tronAddress']);
    await secureStorage.write(key: 'privateKey', value: defaultWallet['privateKey']);

    // Save the updated wallets array to secure storage
    final walletsString = jsonEncode(walletsArray);
    await secureStorage.write(key: 'wallets', value: walletsString);
  }

  Future<void> exportWallet(int index) async {
    final secureStorage = SecureStorage();
    final prefs = await SharedPreferences.getInstance();
    final password = prefs.getString('password');
    if (password == null) {
      // Password not set, handle accordingly
      return;
    }
    // print("pass $password");
    // Retrieve the wallet at the given index
    final wallet = walletsArray[index];
    final mnemonic = wallet['mnemonic'];

    // Show password prompt dialog
    final passwordPromptController = TextEditingController();
    final enteredPassword = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConfig.background,
        title: Text('Enter Password'),
        content: TextField(
          controller: passwordPromptController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            hintStyle: TextStyle(color: Colors.white)
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final enteredPassword = passwordPromptController.text;
              Navigator.of(context).pop(enteredPassword);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );

    if (enteredPassword != null && enteredPassword.isNotEmpty && enteredPassword == password) {
      // Password is correct, show the mnemonic
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppConfig.background,
          title: Text('Wallet Mnemonic'),
          content: Text(mnemonic),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      print('Wrong password');
    }
  }

  @override
  Widget build(BuildContext context) {

    try {
      return Scaffold(
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


                Text("My Wallet",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: AppConfig.titleIconAndTextColor,
                  ),
                ),
              ],
            ),

          ),
          /*actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CreateWalletScreen()),
                );
              },
            ),
          ],*/


        ),

        body: ListView.builder(
          itemCount: walletsArray.length,
          itemBuilder: (context, index) {
            final wallet = walletsArray[index];
            return ListTile(
              title: Row(
                children: [
                  Text(wallet['walletName']),
                  if (isDefaultWallet(index)) Icon(Icons.check_circle, color: Colors.green), // Display an icon if the wallet is default
                ],
              ),
              subtitle: Text(shortenEthAddress(wallet['ethAddress'])),
              trailing: PopupMenuButton<String>(
                icon: Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'makeDefault') {
                    makeDefaultWallet(index);
                  } else if (value == 'exportWallet') {
                    exportWallet(index);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'makeDefault',
                    child: Text('Make Default'),
                  ),
                  PopupMenuItem(
                    value: 'exportWallet',
                    child: Text('Export Wallet'),
                  ),
                ],
              ),
            );
          },
        ),

      );
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack trace: $stackTrace');
      return Container(); // Return an empty container or an error widget
    }
  }
}
