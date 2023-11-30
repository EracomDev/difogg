import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:web3dart/web3dart.dart';

import '../utils/app_config.dart';
import 'package:http/http.dart' as http;

class ContractService {
  final storage = new FlutterSecureStorage();
  Future<void> saveContracts(Map<String, List<Map<String, dynamic>>> contracts) async {
    String contractsStr = json.encode(contracts);
    await storage.write(key: 'contracts', value: contractsStr);

  }

  Future<void> updateContractStatus(
      String contractName, bool newStatus) async {
    try {
      final contracts = await contractList();
      if (contracts.containsKey(contractName)) {
        final contractsList = contracts[contractName];
        for (var contract in contractsList!) {
          contract['showStatus'] = newStatus;
        }
        await saveContracts(contracts);
      } else {
        print('Contract not found.');
      }
    } catch (e) {
      print('Error updating contract status: $e');
    }
  }


  Future<void> addContract(String contractName, Map<String, dynamic> contract) async {
    String? contractsStr = await storage.read(key: 'contracts');
    if (contractsStr == null) {
      contractsStr = json.encode({});
    }
    dynamic decodedData = json.decode(contractsStr);
    if (decodedData is! Map<String, dynamic>) {
      throw Exception('Invalid data format. Expected Map<String, dynamic>.');
    }
    Map<String, dynamic> contractsMap = decodedData;
    Map<String, List<Map<String, dynamic>>> contracts = contractsMap.map((key, value) {
      if (value is List<dynamic> && value.every((item) => item is Map)) {
        return MapEntry(key, value.map((item) => Map<String, dynamic>.from(item)).toList());
      } else {
        throw Exception('Invalid contract data format. Expected List<Map<String, dynamic>>.');
      }
    });
    contracts.putIfAbsent(contractName, () => []);
    // Check if the contract already exists in the list before adding
    if (!contracts[contractName]!.any((existingContract) => existingContract["address"] == contract["address"])) {
      contracts[contractName]?.add(contract);
      await saveContracts(contracts);
    } else {
      print('Contract with the same address already exists.');
    }
  }

  Future<Map<String, List<Map<String, dynamic>>>> contractList() async {
    String? contractsStr = await storage.read(key: 'contracts');
    final jsonData = json.decode(contractsStr!) as Map<String, dynamic>;

    final Map<String, List<Map<String, dynamic>>> contractData = {};

    jsonData.forEach((blockchain, contractsList) {
      final List<dynamic> contractsDynamicList = contractsList;
      final List<Map<String, dynamic>> contractsMapList =
      contractsDynamicList.cast<Map<String, dynamic>>();

      contractData[blockchain] = contractsMapList;
    });

    return contractData;
  }

  Future<Map<String, Map<String, dynamic>>> getContracts() async {
    String? contractsStr = await storage.read(key: 'contracts');
    return Map<String, Map<String, dynamic>>.from(json.decode(contractsStr!));
  }

  Future<List<Map<String, dynamic>>?> getContractData(String contractName) async {
    String? contractsStr = await storage.read(key: 'contracts');

    if (contractsStr == null) {
      throw Exception('No contracts found.');
    }
    dynamic decodedData = json.decode(contractsStr);
    if (decodedData is! Map<String, dynamic>) {
      throw Exception('Invalid data format. Expected Map<String, dynamic>.');
    }

    Map<String, dynamic> contractsMap = decodedData;
    print(contractName);
    print(contractsMap);


    if (!contractsMap.containsKey(contractName)) {
      throw Exception('Invalid contract name');
    }

    dynamic contractsData = contractsMap[contractName];

    if (contractsData is! List<dynamic>) {
      throw Exception('Invalid contract data format. Expected List<dynamic>.');
    }

    List<dynamic> contractList = contractsData;

    if(contractList.every((item) => item is Map)) {
      List<Map<String, dynamic>> contractDataList = contractList
          .map<Map<String, dynamic>>((dynamic item) => Map<String, dynamic>.from(item))
          .toList();

      return contractDataList;
    } else {
      throw Exception('Invalid data in contract. Expected each item to be a Map<String, dynamic>.');
    }
  }
  Future<bool> saveAbiToFile(String assetName, String abiData) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$assetName.json');

      // Write the ABI data to the file
      await file.writeAsString(abiData);

      return true;
    } catch (e) {
      print('Error saving ABI data: $e');
      return false;
    }
  }
  Future<String?> readAbiFromFile(String assetName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$assetName.json');

      if (await file.exists()) {
        // Read the ABI data from the file
        String abiData = await file.readAsString();
        return abiData;
      } else {
        // File does not exist, return null or handle it as needed
        return null;
      }
    } catch (e) {
      print('Error reading ABI data: $e');
      return null;
    }
  }
  Future<double> getBuyOrSaleRate(bool isBuyRate) async {
    try {
      final String rpcUrl = AppConfig.swapRpcUrl; // Replace with your RPC URL
      final String contract_ABI = AppConfig.swapContractAbi;
      final String contractAddress = AppConfig.swapContractAddress;

      final Web3Client client = Web3Client(rpcUrl, http.Client());
      final DeployedContract contract = DeployedContract(
        ContractAbi.fromJson(contract_ABI, 'BuySell'),
        // Replace with the correct ABI
        EthereumAddress.fromHex(contractAddress),
      );

      final String functionName = isBuyRate
          ? 'buyRatePerToken'
          : 'sellRatePerToken';

      final query = contract.function(functionName);
      final rateResult = await client.call(
          contract: contract, function: query, params: []);
      final BigInt rateHex = rateResult[0] as BigInt;
      final String rateHexString = rateHex.toRadixString(16);
      final BigInt rateBigInt = BigInt.parse(rateHexString, radix: 16);

      final double rateDouble = rateBigInt.toDouble();

      final queryRateDiv = contract.function('rateDiv');
      final rateDivResult = await client.call(
          contract: contract, function: queryRateDiv, params: []);
      final rateDiv = rateDivResult[0].toDouble();

      final double rate = rateDouble / rateDiv;

      return rate;
    }catch(e){
      //print(e);
      return 0;
    }
  }
}