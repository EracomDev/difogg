import 'package:flutter/material.dart';

class AppConfig {
  static const String appName = "DiFogg";
  static const String appLogo = "assets/images/logo.png";
  static String ChainName = 'bscMainnet';
  static String bscContract = 'USDT-BEP20';
  static String baseUrl = 'https://react.mlmreadymade.com/';
  static String currency = '\$';
  static String browserDefaultUrl = '';

  // static const Color primaryColor = Color(0xFF7369DB);
  static const Color primaryColor = Color.fromRGBO(68, 160, 141, 1);
  static const Color btnBg = Color.fromRGBO(68, 160, 141, 1);
  static const Color primaryText = Color.fromARGB(255, 103, 224, 200);

  static const Color textColor = Color(0xFFFFFFFF);

  //static Color background = const Color(0xFF2A2623);
  static Color borderColor =
      Color.fromARGB(255, 103, 224, 200).withOpacity(0.3);
  static Color myBackground = Color.fromRGBO(0, 0, 26, 1);
  static Color myCardColor = Color.fromRGBO(68, 160, 141, 0.192);
  static Color background = const Color.fromARGB(255, 0, 0, 26);
  static Color darkBackground = const Color(0xFF12001C);
  static Color titleBarColor = const Color.fromARGB(255, 0, 0, 26);
  static Color titleIconAndTextColor = const Color(0xFFFFFFFF);
  static Color cardBackground = const Color(0xFF282828);
  static Color textFieldColor = const Color(0x333E3E3F);
  //static Color textFieldColor =const Color(0xFF403C3D);
  static Color cardBackgroundHome = const Color(0xFF26272A);

  static const Color accentColor = Colors.green;
  static const TextStyle headlineTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static const LinearGradient primaryGradient = LinearGradient(colors: [
    Color.fromRGBO(39, 153, 215, 1.0),
    Color.fromRGBO(39, 153, 215, 1.0)
  ]);

  /*static const LinearGradient containerGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [

    Color.fromRGBO(51, 47, 48, 1.0),
    Color.fromRGBO(35, 32, 30, 1.0),
    Color.fromRGBO(16, 16, 16, 1.0),

    //Color.fromRGBO(24, 24, 24, 1.0)
  ]);*/

  static const LinearGradient containerGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromRGBO(58, 61, 57, 1.0),
        Color.fromRGBO(35, 37, 35, 1.0),
        Color.fromRGBO(21, 21, 21, 1.0),

        //Color.fromRGBO(24, 24, 24, 1.0)
      ]);

  static const LinearGradient containerGradientNew = const LinearGradient(
      colors: [
        Color.fromRGBO(15, 16, 30, 1.0),
        Color.fromRGBO(15, 16, 30, 1.0)
      ]);

  /*static const LinearGradient buttonGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [

    Color.fromRGBO(185, 161, 113, 1.0),
    Color.fromRGBO(138, 118, 71, 1.0),
    Color.fromRGBO(79, 62, 37, 1.0),

    //Color.fromRGBO(24, 24, 24, 1.0)
  ]);*/

  static const LinearGradient buttonGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        /*Color.fromRGBO(42, 103, 89, 1.0),
        Color.fromRGBO(68, 160, 141, 1.0),
        Color.fromRGBO(42, 103, 89, 1.0),*/

// ------------------------------------------
        // Color.fromRGBO(50, 46, 91, 1.0),
        // Color.fromRGBO(115, 105, 219, 1.0),
        // Color.fromRGBO(50, 46, 91, 1.0),
// ----------------------------------------------

        Color.fromRGBO(68, 160, 141, 1),
        Color.fromRGBO(68, 160, 141, 1),
        Color.fromRGBO(68, 160, 141, 1)

        //Color.fromRGBO(113, 185, 117, 1.0),
        //Color.fromRGBO(78, 138, 71, 1.0),
        //Color.fromRGBO(40, 79, 37, 1.0),
        //Color.fromRGBO(24, 24, 24, 1.0)
      ]);

  /*static const LinearGradient buttonGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [

    Color.fromRGBO(185, 161, 113, 1.0),
    Color.fromRGBO(138, 118, 71, 1.0),
    Color.fromRGBO(79, 62, 37, 1.0),

    //Color.fromRGBO(24, 24, 24, 1.0)
  ]);*/

  //Own Contract data
  static String custName = 'DFOG';
  static String custTokenBlockchain = 'bscMainnet';
  static String tokenRate = '1';
  static String custToken = '0x3f992D5B5b2Ffd3847193c3eEb46A0F0870DC648';
  static int custTokenDecimal = 8;
  // static String clientAddress = '0xeBc186336f913bfdD1406f9F7fd1D23Ca5bc3ccb';

  // ---------------------------------clientAddress start-----------------------------------

  String clientAddress = '';
  static final AppConfig _instance = AppConfig._internal();
  AppConfig._internal();
  static AppConfig get instance => _instance;

  // ----------------------------------clientAddress end----------------------------------
  static String custTokenAbi =
      '[{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"spender","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Transfer","type":"event"},{"constant":true,"inputs":[],"name":"_decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"_name","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"_symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"spender","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"burn","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"subtractedValue","type":"uint256"}],"name":"decreaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getOwner","outputs":[{"internalType":"address","name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"addedValue","type":"uint256"}],"name":"increaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"mint","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"renounceOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"sender","type":"address"},{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"}]';

  //swap contract
  static String swapContractAddress =
      '0xf5Ca6AD6a2361FBA179F41aDfd29f9F5403b6bf9';
  static String swapRpcUrl = 'https://data-seed-prebsc-1-s1.binance.org:8545/';
  static int swapChainId = 56;
  static String swapContractAbi =
      '[{"inputs":[{"internalType":"address","name":"_buytoken","type":"address"},{"internalType":"address","name":"_saletoken","type":"address"}],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"buyer","type":"address"},{"indexed":true,"internalType":"uint256","name":"spent","type":"uint256"},{"indexed":true,"internalType":"uint256","name":"recieved","type":"uint256"}],"name":"Buy","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"buyer","type":"address"},{"indexed":true,"internalType":"uint256","name":"spent","type":"uint256"},{"indexed":true,"internalType":"uint256","name":"recieved","type":"uint256"}],"name":"Sale","type":"event"},{"inputs":[],"name":"Buystatus","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"Sellstatus","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"amnt","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"address","name":"token","type":"address"}],"name":"buy","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"buyRatePerToken","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"rate","type":"uint256"},{"internalType":"uint256","name":"div","type":"uint256"}],"name":"buygetrate","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"buytoken","outputs":[{"internalType":"contract BEP20","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"contract BEP20","name":"_buytoken","type":"address"},{"internalType":"contract BEP20","name":"_saletoken","type":"address"}],"name":"changeToken","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"rateDiv","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"contract BEP20","name":"b_token","type":"address"}],"name":"sale","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"rate","type":"uint256"},{"internalType":"uint256","name":"div","type":"uint256"}],"name":"salegetrate","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"saletoken","outputs":[{"internalType":"contract BEP20","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"sellRatePerToken","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_status","type":"uint256"}],"name":"setBuyStatus","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_status","type":"uint256"}],"name":"setSellStatus","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address payable","name":"_contributors","type":"address"},{"internalType":"uint256","name":"_balances","type":"uint256"},{"internalType":"contract BEP20","name":"token","type":"address"}],"name":"shareSingleContribution","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"contract BEP20","name":"BUSD","type":"address"},{"internalType":"address","name":"userAddress","type":"address"},{"internalType":"uint256","name":"amt","type":"uint256"}],"name":"withdraw","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"}]';

  //list of tokens in which custtoken can be swap using swap contract
  //this list is based on swap contract
  static final validAddresses = [
    '0x5f6Cc322C1849cfC769fA4c4D9e2E274e8c78A55',
    '0xE7FF9229215D99C58702740D31b44DF2E6a6F090',
    custName
  ];

  //default swap with
  static String defaultSwap = '0x5f6Cc322C1849cfC769fA4c4D9e2E274e8c78A55';
  // Add other color constants and design configurations here
}
