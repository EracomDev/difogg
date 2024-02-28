import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/wallet.dart';
import '../services/blockchain_service.dart';
import '../services/contract_service.dart';
import '../utils/app_config.dart';
import '../utils/secure_storage.dart';
import '../screens/view_wallet.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:difog/services/api_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletService {
  final SecureStorage secureStorage = SecureStorage();
  static Map<String, BlockchainDataManager?> balanceManagers = {};
  static String? address;
  List<WalletData> wallets = [];

  List<dynamic> data = [];

  // Move the address initialization to a constructor or a method
  ContractService contractService = ContractService();

  // Constructor to initialize the 'address' member
  WalletService() {
    _initializeAddress();
  }

  // Method to initialize the 'address' member asynchronously
  Future<void> _initializeAddress() async {
    address = await secureStorage.read('ethAddress') as String?;
    //print('adhd $address');
  }

  Future<List<WalletData>> getWallets(BuildContext context) async {
    final response = await http.get(
      //https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false
      //Uri.parse('https://api.coingecko.com/api/v3/simple/price?ids=binancecoin,matic-network,binance-usd,tether,dai,ethereum,polygon,&vs_currencies=usd&include_24hr_change=true&include_last_updated_at=true&include_volume=true',),
      Uri.parse(
        'https://api.coingecko.com/api/v3/simple/price?ids=binancecoin,binance-usd,tether,polygon,&vs_currencies=usd&include_24hr_change=true&include_last_updated_at=true&include_volume=true&sparkline=true',
      ),
    );
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    FlutterSecureStorage storage = FlutterSecureStorage();
    WalletService walletService = WalletService();
    await walletService._initializeAddress();
    String? contractsStr = await storage.read(key: 'contracts');
    Map<String, dynamic> contracts = json.decode(contractsStr!);
    print("responseData=" + responseData.toString());
    print(contracts);
    for (var entry in contracts.entries) {
      String contractName = entry.key;

      for (Map<String, dynamic> contract in entry.value) {
        if (contract['showStatus']) {
          try {
            var data = responseData[contract['internalName']];

            /*if(responseData[contract['internalName']]["usd"]!=null){
              var price2 = responseData[contract['internalName']]["usd"];

              print(price2);
            }*/

            print("dataValues");

            //if (data != null) {
            String cryptoName = contractName;

            print('add ${contract['blockchain']}');
            balanceManagers[cryptoName] = BlockchainDataManager(
              //'0x50966810A133cDf7083BDE254954A8D61041d09B',
              address!,
              cryptoName,
              contract['blockchain'],
            );
            IconData icon = Icons
                .attach_money; // You need to handle icons dynamically based on the contract name
            //ApiService apiService = ApiService();
            //Map<String, double> apidata = await apiService.getPriceAndChange(contract['internalName']);
            //double price = apidata['price'] ?? 0.0;
            //double change = apidata['change'] ?? 0.0;
            //String priceValue = price.toStringAsFixed(2);
            String priceValue = "";
            String change = "0.0";

            if (cryptoName == AppConfig.custName) {
              // priceValue = ((data != null
              //             ? double.tryParse(data['usd']!.toString())
              //             : null) ??
              //         (await contractService.getBuyOrSaleRate(true)) ??
              //         0.0)
              //     .toStringAsFixed(4);
              double buyRate = await callApi();
              priceValue = buyRate.toString();
            } else {
              priceValue =
                  responseData[contract['internalName']]["usd"].toString();
              change = responseData[contract['internalName']]["usd_24h_change"]
                  .toStringAsFixed(2);
            }

            WalletData wallet = WalletData(
              cryptoName: cryptoName,
              symbol: contract['symbol'],
              icon: icon,
              price: priceValue,
              isToken: contract['isToken'],
              change: '$change%',
              balance: await balanceManagers[cryptoName]!
                  .getBalance(isToken: contract['isToken']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CryptoPage(
                      cryptoName: cryptoName,
                      symbol: contract['symbol'],
                    ),
                  ),
                );
              },
            );

            print("addedCount");

            wallets.add(wallet);
            /*} else {
            // Handle the case when the response data is null or doesn't match the expected structure
            print('Invalid response data for $contractName');
          }*/
          } catch (e) {
            print(e.toString());
            // Handle any exceptions that occur during processing of the current contract entry
            //print('Error processing contract entry: $e');
          }
        }
      }
    }
    return wallets;
  }

  Future<dynamic> cryptoData(BuildContext context) async {
    final response = await http.get(
      Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&sparkline=false',
      ),
    );

    //var dataString = response.body;
    print("response123");

    List<dynamic> json = jsonDecode(response.body.toString());

    data.addAll(json);

    return data;
  }

  Future<String> WallatTotalBalance() async {
    double totalBalance = 0;
    for (WalletData wallet in wallets) {
      print("wallet");
      double balance = double.tryParse(wallet.balance) ?? 0;
      double price = double.tryParse(wallet.price) ?? 0;
      totalBalance += balance * price;
    }

    return totalBalance.toStringAsFixed(2);
  }

  Future<double> callApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String userId = prefs.get('u_id').toString();
    var requestBody = jsonEncode({
      "u_id": userId,
    });

    print(requestBody);

    print("u_id=" + userId);

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
      log("token json111111111111111=${json['token_rate']}");
      return double.parse(json['token_rate'].toString());
    } else {
      return 0.0;
    }
  }
}
