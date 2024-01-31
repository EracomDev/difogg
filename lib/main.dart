import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:difog/screens/main_page.dart';
import 'package:difog/screens/splash_screen.dart';
import 'package:difog/services/contract_service.dart';
import 'package:difog/utils/app_config.dart';
import 'routes.dart';
import 'screens/create_wallet_screen.dart';
import 'screens/password_set.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    if (Platform.isAndroid) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyB69XckpvQxzcjUtTr9XhiPK0AHVTa7FJc',
          appId: '1:1061676129060:android:4378b1beec61d77726b1b1',
          messagingSenderId: '1061676129060',
          projectId: 'difogg',
          // authDomain: 'react-native-firebase-testing.firebaseapp.com',
          //iosClientId: '448618578101-4km55qmv55tguvnivgjdiegb3r0jquv5.apps.googleusercontent.com',
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } else {
    // iOS requires that there is a GoogleService-Info.plist otherwise getInitialLink & getDynamicLink will not work correctly.
    // iOS also requires you run in release mode to test dynamic links ("flutter run --release").
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double roundSize = 16;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //initialRoute: '/',
      onGenerateRoute: Routes.generateRoute,
      home: SplashPage(),

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppConfig.primaryColor),
        useMaterial3: true,
        fontFamily: 'Outfit',

        //scaffoldBackgroundColor: AppConfig.background,
        scaffoldBackgroundColor: Colors.transparent,

        textTheme: const TextTheme(
          displayMedium: TextStyle(color: Colors.white), //<-- SEE HERE
          displayLarge: TextStyle(color: Colors.white), //<-- SEE HERE
          displaySmall: TextStyle(color: Colors.white), //<-- SEE HERE
          headlineMedium: TextStyle(color: Colors.white), //<-- SEE HERE
          headlineLarge: TextStyle(color: Colors.white), //<-- SEE HERE
          headlineSmall: TextStyle(color: Colors.white), //<-- SEE HERE
          titleLarge: TextStyle(color: Colors.white), //<-- SEE HERE
          titleMedium: TextStyle(color: Colors.white), //<-- SEE HERE
          titleSmall: TextStyle(color: Colors.white), //<-- SEE HERE
          bodySmall: TextStyle(color: Colors.white), //<-- SEE HERE
          bodyMedium: TextStyle(color: Colors.white), //<-- SEE HERE
          bodyLarge: TextStyle(color: Colors.white), //<-- SEE HERE
        ),

        listTileTheme: ListTileThemeData(
            iconColor: AppConfig.textColor, textColor: AppConfig.textColor),
        expansionTileTheme: ExpansionTileThemeData(
            collapsedIconColor: AppConfig.textColor,
            collapsedTextColor: AppConfig.textColor,
            textColor: AppConfig.primaryColor,
            iconColor: AppConfig.primaryColor),

        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(color: Colors.white),
          prefixIconColor: AppConfig.textColor,
          suffixIconColor: AppConfig.textColor,

          //fillColor: Colors.white.withOpacity(.8),
          fillColor: AppConfig.textFieldColor,
          filled: true,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(roundSize),
            borderSide: const BorderSide(
              color: Color(0xEAEAEA),
              width: 1,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(roundSize),
            borderSide: const BorderSide(
              color: Color(0xEAEAEA),
              width: 1,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(roundSize),
            borderSide: const BorderSide(
              color: Color(0xEAEAEA),
              width: 1,
            ),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(roundSize),
            borderSide: const BorderSide(
              color: Color(0xEAEAEA),
              width: 1,
            ),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(roundSize),
            borderSide: const BorderSide(
              color: Color(0xEAEAEA),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  /*Future<String> getPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? password = prefs.getString('password');
    bool walletset = (await prefs.getBool('walletSet')) ?? false;
    if(walletset==false){
      ContractService contractService = ContractService();
      Map<String, List<Map<String, dynamic>>> contractData = {
        AppConfig.custName: [
          {                       //dont forgot to change abiData below for your token
            'internalName': AppConfig.custName,
            'symbol' : AppConfig.custName,
            'type': 'token',
            'address': AppConfig.custToken,
            'blockchain': AppConfig.custTokenBlockchain,
            'currency': '\$',
            'showStatus': true,
            'isToken': true
          },
        ],
        'BNB': [
          {
            'internalName': 'binancecoin',
            'symbol' : 'BNB',
            'type': 'coin',
            'address': 'bnb',
            'blockchain': 'bscMainnet',
            'currency': 'BNB',
            'showStatus': true,
            'isToken': false
          },
        ],
        '0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56': [
          {
            'internalName': 'binance-usd',
            'symbol' : 'BUSD',
            'type': 'token',
            'address': '0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56',
            'blockchain': 'bscMainnet',
            'currency': '\$',
            'showStatus': true,
            'isToken': true
          },
        ],
        '0x55d398326f99059fF775485246999027B3197955': [
          {
            'internalName': 'binance-usd',
            'symbol' : 'USDT',
            'type': 'token',
            'address': '0x55d398326f99059fF775485246999027B3197955',
            'blockchain': 'bscMainnet',
            'currency': '\$',
            'showStatus': true,
            'isToken': true
          },
        ],
        'ETH': [
          {
            'internalName': 'ethereum',
            'symbol' : 'ETH',
            'type': 'coin',
            'address': 'eth',
            'blockchain': 'ethereumMainnet',
            'currency': 'ETH',
            'showStatus': true,
            'isToken': false
          },
        ],
        'MATIC': [
          {
            'internalName': 'matic-network',
            'symbol' : 'MATIC',
            'type': 'coin',
            'address': 'matic',
            'blockchain': 'polygonMainnet',
            'currency': 'MATIC',
            'showStatus': true,
            'isToken': false
          },
        ],

        // ... other contracts data here
      };

      String abiData=AppConfig.custTokenAbi;

      await ContractService().saveAbiToFile(AppConfig.custName, abiData);

      String abiUSD_BEP='[{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"spender","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Transfer","type":"event"},{"constant":true,"inputs":[],"name":"_decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"_name","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"_symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"spender","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"burn","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"subtractedValue","type":"uint256"}],"name":"decreaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getOwner","outputs":[{"internalType":"address","name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"addedValue","type":"uint256"}],"name":"increaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"mint","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"renounceOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"sender","type":"address"},{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"}]';
      await ContractService().saveAbiToFile('0x55d398326f99059fF775485246999027B3197955', abiUSD_BEP);

      String abiBUSD='[{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"spender","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Transfer","type":"event"},{"constant":true,"inputs":[],"name":"_decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"_name","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"_symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"spender","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"burn","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"subtractedValue","type":"uint256"}],"name":"decreaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getOwner","outputs":[{"internalType":"address","name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"addedValue","type":"uint256"}],"name":"increaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"mint","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"renounceOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"sender","type":"address"},{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"}]';
      await ContractService().saveAbiToFile('0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56', abiBUSD);



      contractService.saveContracts(contractData);
      await prefs.setBool('walletSet', true);
    }

    //print("My password $password");
    if (password == null || password.isEmpty || password.length==0) {
      // Your one-time code execution here.
      return ''; // Password is empty, so navigate to SetPasswordPage.
    } else {
      return password;
    }
  }*/
}
