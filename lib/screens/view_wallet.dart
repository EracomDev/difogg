// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:difog/screens/qr_code.dart';
import 'package:difog/screens/transfer.dart';
import 'package:difog/utils/app_config.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import '../services/api_service.dart';
import '../services/contract_service.dart';
import '../utils/secure_storage.dart';
import '../services/blockchain_service.dart';
import '../utils/blockchains.dart';
import 'app_layout.dart';
import 'transaction_list.dart';
import '../models/transaction_model.dart';
import 'package:http/http.dart' as http;

class CryptoPage extends StatefulWidget {
  final String cryptoName;
  final String symbol;

  const CryptoPage({required this.cryptoName, required this.symbol});
  @override
  _CryptoPageState createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  final SecureStorage secureStorage = SecureStorage();
  BlockchainDataManager? showDetails;
  final BlockchainData blockchainData =
      BlockchainData(); // Initialize blockchainData with a default value
  Map<String, dynamic> contractData = {};
  String contractAddressHex = '';
  String blockchain = '';
  String? address;
  String? symbol;
  String assetName = '';
  String balance = '';
  double price = 0.0;
  double change = 0.0; // Add a balance variable
  List<MyTransaction> transactions = []; // Declare transactions as a list

  List<_CoinData> data = [];
  @override
  void initState() {
    super.initState();
    initialize();
    dayGraphAPI();
  }

  Future<void> dayGraphAPI() async {
    final response =
        await http.get(Uri.parse('https://difogg.com/jhg7q/user/day_price'));
    if (response.statusCode == 200) {
      final res = await jsonDecode(response.body);
      setState(() {
        change = res?[0]?['price']?['priceChangePercent'] ?? 0.0;
      });
      print(res);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> initialize() async {
    address = await secureStorage.read('ethAddress') as String?;
    ContractService contractService = ContractService();

    print(widget.cryptoName);
    assetName = widget.cryptoName;
    //print(widget.cryptoName);
    var contractArray =
        await contractService.getContractData(widget.cryptoName);
    List<Map<String, dynamic>> contractList = contractArray != null
        ? List<Map<String, dynamic>>.from(contractArray)
        : [];
    Map<String, dynamic> contractValue = contractList[0];
    contractAddressHex = contractValue['address'];
    blockchain = contractValue['blockchain'];
    symbol = contractValue['symbol'];
    if (showDetails == null) {
      showDetails = BlockchainDataManager(
        //'0x50966810A133cDf7083BDE254954A8D61041d09B',
        address!,
        widget.cryptoName,
        blockchain,
      );
    }
    Future<Map<String, double>> fetchPriceData(String internalName) async {
      ApiService apiService = ApiService();
      return await apiService.getPriceAndChange(internalName);
    }

    balance = await showDetails!.getBalance(
        isToken: contractValue['isToken']); // Assign the balance value
    transactions = await showDetails!.getTransactions(
        isToken: contractValue['isToken']); // Assign the transactions list

    Map<String, double> priceData =
        await fetchPriceData(contractValue['internalName']);
    if (widget.symbol != 'DFOG') {
      setState(() {
        price = priceData['price'] ?? 0.0;
        change = priceData['change'] ?? 0.0;
      });
    } else {
      setState(() {
        price = priceData['price'] ?? 0.0;
      });
    }
    if (assetName == AppConfig.custName) {
      dynamic rate = await contractService.getBuyOrSaleRate(true);
      setState(() {
        price = double.parse(AppConfig.tokenRate);
      });
    }

    print("widget.symbol");
    print(widget.symbol);

    String path =
        "https://api.coingecko.com/api/v3/coins/binancecoin?sparkline=true";
    if (widget.symbol == "BNB") {
      path =
          "https://api.coingecko.com/api/v3/coins/binancecoin?sparkline=true";
    } else if (widget.symbol == "USDT") {
      path = "https://api.coingecko.com/api/v3/coins/tether?sparkline=true";
    } else {
      data.clear();
      final response = await http
          .get(Uri.parse('https://difogg.com/jhg7q/user/hourly_price'));
      if (response.statusCode == 200) {
        final res = await jsonDecode(response.body);
        print(res);
        num length = res?.length ?? 0;
        for (int i = 0; i < length; i++) {
          data.add(_CoinData("Price", res?[i]?['price']));
        }
        setState(() {
          data;
        });
      } else {
        throw Exception('Failed to load data');
      }

      return;
    }

    final response = await http.get(
      Uri.parse(
        path,
      ),
    );

    //var dataString = response.body;

    print("response123");

    var json = jsonDecode(response.body.toString());

    var market_data = json["market_data"];
    var sparkLine = market_data["sparkline_7d"];
    print(sparkLine.toString());

    var price2 = sparkLine["price"];

    print("length=${price2.length}");

    data.clear();

    for (int i = 112; i < price2.length; i++) {
      data.add(_CoinData("Price", price2[i]));
    }

    setState(() {
      data;
    });

    log(sparkLine.toString());
  }

  Future<bool> _checkIfSvgIconExists(String cryptoName) async {
    try {
      await rootBundle.load('assets/icons/$cryptoName.svg');
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: Scaffold(
        backgroundColor: AppConfig.myBackground,
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
                symbol == null
                    ? Text(
                        "Wallet",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: AppConfig.titleIconAndTextColor,
                        ),
                      )
                    : Text(
                        "Wallet - $symbol",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: AppConfig.titleIconAndTextColor,
                        ),
                      ),
              ],
            ),
          ),

          actions: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.history,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionsList(
                            transactions: transactions, address: address!),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    "\$ ${price.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: change < 0 ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(), // Pushes the change text to the right side
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      '${change > 0 ? '+' : ''}${change.toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: change < 0 ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 70.0,
                    height: 70.0,
                    child: /* assetName == "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56"
                          ? Image.asset("assets/icons/$assetName.png")
                          :*/
                        widget.symbol == AppConfig.custName
                            ? Image.asset("assets/images/app_logo.png")
                            : FutureBuilder<bool>(
                                future: _checkIfSvgIconExists(widget.symbol),
                                builder: (BuildContext context,
                                    AsyncSnapshot<bool> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasData &&
                                      snapshot.data!) {
                                    return SvgPicture.asset(
                                      'assets/icons/${widget.symbol}.svg',
                                      width: 70.0,
                                      height: 70.0,
                                      // Handle the case where the SVG is not found
                                      placeholderBuilder:
                                          (BuildContext context) =>
                                              SvgPicture.asset(
                                        'assets/icons/default.svg', // Path to your default SVG icon
                                        width: 70.0,
                                        height: 70.0,
                                      ),
                                    );
                                  } else {
                                    return SvgPicture.asset(
                                      'assets/icons/default.svg', // Default SVG icon
                                      width: 70.0,
                                      height: 70.0,
                                    );
                                  }
                                },
                              ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        balance,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      symbol == null
                          ? const CircularProgressIndicator(
                              strokeWidth: 2,
                            )
                          : Text(
                              '$symbol', // Use the balance variable here
                              style: const TextStyle(fontSize: 18.0),
                            ),
                    ],
                  ),
                  Text(
                    "≈ \$ ${(price * (double.tryParse(balance) ?? 0)).toStringAsFixed(2)}", // Use tryParse to handle invalid input
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32.0),
            Container(
              height: 200,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * .9,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                //Initialize the spark charts widget
                child: SfSparkLineChart.custom(
                  color:
                      change < 0 ? Colors.red.shade800 : AppConfig.primaryColor,
                  //Enable the trackball
                  trackball: const SparkChartTrackball(
                      color: Colors.white,
                      activationMode: SparkChartActivationMode.tap),
                  //Enable marker
                  marker: const SparkChartMarker(
                      displayMode: SparkChartMarkerDisplayMode.all),
                  //Enable data label
                  labelDisplayMode: SparkChartLabelDisplayMode.all,
                  xValueMapper: (int index) => data[index].name,
                  yValueMapper: (int index) => data[index].amount,
                  dataCount: data.length,
                  axisLineColor: Colors.white,
                  labelStyle: const TextStyle(color: Colors.transparent),
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 150,
                  decoration: BoxDecoration(
                      gradient: AppConfig.buttonGradient,
                      borderRadius: BorderRadius.circular(20)),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => sendAsset(
                              cryptoName: widget.cryptoName,
                              liveRate: price,
                              totalToken: balance),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent),
                    child: Text(
                      'Send',
                      style: TextStyle(
                          color: AppConfig.titleIconAndTextColor, fontSize: 16),
                    ),
                  ),
                )

                /*RoundButton(
                    icon: Icons.send,
                    label: 'Send',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => sendAsset(cryptoName: widget.cryptoName),
                        ),
                      );
                    },
                  )*/
                ,
                Container(
                  width: 150,
                  decoration: BoxDecoration(
                      gradient: AppConfig.buttonGradient,
                      borderRadius: BorderRadius.circular(20)),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CryptoWalletPage(
                            walletAddress: address!,
                            cyptotype: widget.cryptoName,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent),
                    child: Text(
                      'Receive',
                      style: TextStyle(
                          color: AppConfig.titleIconAndTextColor, fontSize: 16),
                    ),
                  ),
                )
                /*RoundButton(
                    icon: Icons.receipt,
                    label: 'Receive',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CryptoWalletPage(walletAddress: address!, cyptotype: widget.cryptoName,),
                        ),
                      );
                    },
                  ),*/
                /*RoundButton(
                    icon: Icons.swap_horiz,
                    label: 'Swap',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TokenSwap(cryptoName: widget.cryptoName),
                        ),
                      );
                    },
                  ),*/
              ],
            ),
            const SizedBox(height: 12.0),
            /*Align(
                alignment: Alignment.center,
                child:

                Container(

                  width: MediaQuery.of(context).size.width*.35,
                  margin: EdgeInsets.only(right: 16),

                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      //gradient: AppConfig.buttonGradient,borderRadius: BorderRadius.circular(20)

                  ),
                  child: ElevatedButton(
                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionsList(transactions: transactions, address: address!),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppConfig.primaryColor.withOpacity(.05), shadowColor: Colors.transparent),
                    child: Row(
                      children: [

                        Icon(Icons.history),
                        SizedBox(width: 16,),
                        Text('History',style: TextStyle(color: AppConfig.titleIconAndTextColor),),
                      ],
                    ),
                  ),
                )

              ),*/
          ],
        ),
      ),
    );
  }
}

class RoundButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Null Function() onTap;

  const RoundButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 27.0,
            backgroundColor: AppConfig.primaryColor,
            child: Icon(
              icon,
              color: AppConfig.textColor,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(label),
        ],
      ),
    );
  }
}

class _CoinData {
  _CoinData(this.name, this.amount);

  final String name;
  final double amount;
}
