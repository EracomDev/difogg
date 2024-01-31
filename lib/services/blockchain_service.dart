import 'dart:convert';
import 'package:difog/utils/app_config.dart';
import 'package:web3dart/web3dart.dart';
import '../utils/blockchains.dart';
import 'package:http/http.dart' as http;
import 'package:difog/models/transaction_model.dart';

import 'contract_service.dart';

class BlockchainDataManager {
  final String address;
  final String contractName;
  final String chainName;

  BlockchainDataManager(this.address, this.contractName, this.chainName);
  Future<String> getBalance({bool isToken = true}) async {
    print("11111111111111111 ${address}");
    print("22222222222222222 ${contractName}");
    print("33333333333333333 ${chainName}");
    BlockchainData blockchainData = BlockchainData();
    Map<String, dynamic> chainData = blockchainData.getChainData(chainName);
    var rpcUrl = chainData['rpcUrl'];
    final httpClient = http.Client();
    final client = Web3Client(rpcUrl, httpClient);
    EtherAmount balanceInWei;
    if (isToken) {
      ContractService contractService = ContractService();
      var contractArray = await contractService.getContractData(contractName);
      //print(contractArray);
      List<Map<String, dynamic>> contractList = contractArray != null
          ? List<Map<String, dynamic>>.from(contractArray)
          : [];
      Map<String, dynamic> contractValue = contractList[0];
      String contractAddressHex = contractValue['address'];
      String? contractAbi =
          await ContractService().readAbiFromFile(contractName);
      EthereumAddress contractAddress =
          EthereumAddress.fromHex(contractAddressHex);
      // Get balance
      final contract = DeployedContract(
        ContractAbi.fromJson(contractAbi!, ''),
        contractAddress,
      );
      final balanceFunction = contract.function('balanceOf');
      final balance = await client.call(
        contract: contract,
        function: balanceFunction,
        params: [EthereumAddress.fromHex(address)],
      );
      balanceInWei = EtherAmount.inWei(BigInt.parse(balance[0].toString()));
    } else {
      balanceInWei = await client.getBalance(EthereumAddress.fromHex(address));
    }
    double balanceInDecimal;
    if (contractName == AppConfig.custName) {
      balanceInDecimal = balanceInWei.getInWei /
          BigInt.from(10).pow(AppConfig.custTokenDecimal);
    } else {
      balanceInDecimal = balanceInWei.getInWei / BigInt.from(10).pow(18);
    }
    final formattedBalance = balanceInDecimal.toStringAsFixed(4);
    print(formattedBalance);
    return formattedBalance;
  }

  Future<List<MyTransaction>> getTransactions({bool isToken = true}) async {
    BlockchainData blockchainData = BlockchainData();
    Map<String, dynamic> chainData = blockchainData.getChainData(chainName);
    var bscScanApi = chainData['apiUrl'];
    String path = '';
    if (isToken) {
      ContractService contractService = ContractService();
      var contractArray = await contractService.getContractData(contractName);
      List<Map<String, dynamic>> contractList = contractArray != null
          ? List<Map<String, dynamic>>.from(contractArray)
          : [];
      Map<String, dynamic> contractValue = contractList[0];
      String contractAddressHex = contractValue['address'];
      EthereumAddress contractAddress =
          EthereumAddress.fromHex(contractAddressHex);
      path = '$bscScanApi/api?module=account' +
          '&action=tokentx' +
          '&contractaddress=${contractAddress.hex}' +
          '&address=$address' +
          '&page=1' +
          '&offset=10' +
          '&startblock=0' +
          '&endblock=999999999' +
          '&sort=desc' +
          '&apikey=YX41WESZ9TBPQHYQ2B98M1KSTJMZM9TU3E';
    } else {
      path = '$bscScanApi/api?module=account' +
          '&action=txlist' +
          '&address=$address' +
          '&page=1' +
          '&offset=10' +
          '&startblock=0' +
          '&endblock=999999999' +
          '&sort=desc' +
          '&apikey=YX41WESZ9TBPQHYQ2B98M1KSTJMZM9TU3E';
    }
    //print(path);
    var response = await http.get(Uri.parse(path));
    if (response.statusCode == 200) {
      List<MyTransaction> transactions = [];
      var data = jsonDecode(response.body);
      if (data['status'] == '1') {
        var result = data['result'];
        for (var transactionData in result) {
          transactions.add(MyTransaction.fromJson(transactionData));
        }
      }
      return transactions;
    } else {
      throw Exception('Failed to fetch transactions');
    }
  }

  Future<List<dynamic>> getBalanceAndTransactions() async {
    String balance = '100'; // Replace with the actual balance
    List<MyTransaction> transactions = await getTransactions();
    return [balance, transactions];
  }
}

class ContractDetails {
  final String name;
  final int decimals;
  final String abi;

  ContractDetails(
      {required this.name, required this.decimals, required this.abi});
}

Future<ContractDetails> getContractDetails(
    String contractAddress, String blockchain) async {
  try {
    var blockchainData = BlockchainData();
    var chainData = blockchainData.getChainData(
        blockchain); // Replace chainName with the actual chain name.
    String apiUrl = chainData['apiUrl'];
    String rpcUrl = chainData['rpcUrl'];
    final String bscScanApiKey = 'YX41WESZ9TBPQHYQ2B98M1KSTJMZM9TU3E';

    // Construct the URL for BscScan's API
    final String url =
        '$apiUrl/api?module=contract&action=getabi&address=$contractAddress&apikey=$bscScanApiKey';

    // Send GET request to BscScan
    final response = await http.get(Uri.parse(url));
    // Check for successful response
    if (response.statusCode != 200) {
      throw Exception('Failed to load ABI');
    }

    // Parse JSON response to get the ABI
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    final dynamic abiResult = jsonResponse['result'];

    if (abiResult is String) {
      final String abiString = abiResult;
      //final erc20Abi = jsonDecode(abiString); // Parse the ABI string to JSON
      // Use the web3dart library to fetch the name and decimals
      final httpClient = http.Client();
      final ethClient = Web3Client(rpcUrl, httpClient);

      final contract = DeployedContract(
        ContractAbi.fromJson(abiString, 'ERC20'),
        EthereumAddress.fromHex(contractAddress),
      );

      final nameFunction = contract.function('symbol');
      final decimalsFunction = contract.function('decimals');
      final nameResponse = await ethClient.call(
        contract: contract,
        function: nameFunction,
        params: [],
      );
      final decimalsResponse = await ethClient.call(
        contract: contract,
        function: decimalsFunction,
        params: [],
      );

      final String name = nameResponse[0] as String;
      final BigInt decimalsBigInt = decimalsResponse[0] as BigInt;
      final int decimals = decimalsBigInt.toInt();

      httpClient.close();

      return ContractDetails(
        name: name,
        decimals: decimals,
        abi: abiString,
      );
    } else {
      throw Exception('Invalid ABI format');
    }
  } catch (e) {
    return ContractDetails(
      name: '',
      decimals: 0,
      abi: '',
    );
  }
}

void main() async {
  String myAddress = '0x50966810A133cDf7083BDE254954A8D61041d09B';
  BlockchainData blockchainData = BlockchainData();
  BlockchainDataManager blockchainDataManager = BlockchainDataManager(
    myAddress,
    'DAI',
    'polygonMainnet',
  );

  String balance = await blockchainDataManager.getBalance(isToken: true);
  //List<MyTransaction> transactions = result[1];
  print(balance);
  //runApp(MyApp(transactions: transactions, address: myAddress));
}
