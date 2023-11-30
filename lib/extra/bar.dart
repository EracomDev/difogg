import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/wallet.dart';
import '../services/blockchain_service.dart';
import '../services/contract_service.dart';
import '../utils/app_config.dart';
import '../utils/secure_storage.dart';
import '../screens/view_wallet.dart';
import 'package:http/http.dart' as http;

class WalletService {
  final SecureStorage secureStorage = SecureStorage();
  static Map<String, BlockchainDataManager?> balanceManagers = {};
  static String? address;
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

  static Future<List<WalletData>> getWallets(BuildContext context) async {
    final response = await http.get(
      Uri.parse(
        'https://api.coingecko.com/api/v3/simple/price?ids=binancecoin,matic-network,binance-usd,tether,dai,ethereum,polygon,&vs_currencies=usd&include_24hr_change=true&include_last_updated_at=true&include_volume=true',
      ),
    );

    final Map<String, dynamic> responseData = jsonDecode(response.body);

    List<WalletData> wallets = [];
    FlutterSecureStorage storage = FlutterSecureStorage();
    WalletService walletService = WalletService();
    await walletService._initializeAddress();
    String? contractsStr = await storage.read(key: 'contracts');

    Map<String, dynamic> contracts = json.decode(contractsStr!);

    print("contracts");
    print(contracts);

    for (var entry in contracts.entries) {
      String contractName = entry.key;
      for (Map<String, dynamic> contract in entry.value) {
        try {
        var data = responseData[contract['internalName']];
        if (data != null) {
          String cryptoName = contractName;
          //print('add $address');
          balanceManagers[cryptoName] = BlockchainDataManager(
            //'0x50966810A133cDf7083BDE254954A8D61041d09B',
            address!,
            cryptoName,
            contract['blockchain'],
          );

          IconData icon = Icons.attach_money; // You need to handle icons dynamically based on the contract name
          //print("balanceof"+await balanceManagers[cryptoName]!.getBalance(isToken: true));
          WalletData wallet = WalletData(
            cryptoName: cryptoName,
            symbol: cryptoName,
            icon: icon,
            isToken:  contract['isToken'],
            price: '\$' + double.parse(data['usd'].toString()).toStringAsFixed(2),
            change: double.parse(data['usd_24h_change'].toString()).toStringAsFixed(2) + '%',
            balance: await balanceManagers[cryptoName]!.getBalance(isToken: true),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CryptoPage(cryptoName: cryptoName,symbol: "",),
                ),
              );
            },
          );
          wallets.add(wallet);
        } else {
          // Handle the case when the response data is null or doesn't match the expected structure
          //print('Invalid response data for $contractName');
        }
        } catch (e) {
          // Handle any exceptions that occur during processing of the current contract entry
          //print('Error processing contract entry: $e');
        }
      }
    }
    return wallets;
  }

// Other methods in the class...
}
