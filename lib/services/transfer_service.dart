import 'dart:math';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import '../utils/blockchains.dart';
import '../utils/secure_storage.dart';
import 'contract_service.dart';

Future<String> transferAsset(String asset, String addressToSend, String amount) async {
  final blockchainData = BlockchainData();
  //final contractData = blockchainData.getContractData(asset); // Replace chainName with the actual chain name.
  // Replace chainName with the actual chain name.
  String transactionHash;
  ContractService contractService = ContractService();
  var contractArray = await contractService.getContractData(asset);
  List<Map<String, dynamic>> contractList = contractArray != null ? List<Map<String, dynamic>>.from(contractArray) : [];
  Map<String, dynamic> contractValue = contractList[0];
  final chainData = blockchainData.getChainData(contractValue['blockchain']);
  if (contractValue['isToken'] == false) {
    transactionHash = await sendCoin(chainData['rpcUrl'], addressToSend, amount,chainData['chainId']);
  } else {
    String? contractAbi = await ContractService().readAbiFromFile(asset);
    transactionHash = await transferToken(chainData['rpcUrl'], contractAbi!, contractValue['address'], addressToSend, chainData['chainId'], amount);
  }
  return transactionHash;
}

Future<String> sendCoin(String rpcUrl, String addressToSend, String amount, int chainId) async {
  final SecureStorage secureStorage = SecureStorage();
  final privateKey = await secureStorage.read('privateKey');
  final client = Web3Client(rpcUrl, Client());
  final credentials = EthPrivateKey.fromHex(privateKey!);
  final address = EthereumAddress.fromHex(addressToSend);

  // Convert amount to BigInt directly
  final amountInWei = BigInt.parse(amount) * BigInt.from(pow(10, 18));
  final value = EtherAmount.inWei(amountInWei);

  final transaction = Transaction(
    to: address,
    value: value,
  );

  try {
    final transactionHash = await client.sendTransaction(credentials, transaction, chainId: chainId);
    return transactionHash;
  } catch (e) {
    throw Exception('Failed to send transaction: $e');
  }
}


Future<String> transferToken(String rpcUrl, String abi, String contractAddress, String toAddress, int chainId, String amount) async {
  final SecureStorage secureStorage = SecureStorage();
  final privateKey = await secureStorage.read('privateKey');
  final credentials = EthPrivateKey.fromHex(privateKey!);
  final client = Web3Client(rpcUrl, Client());
  final contract = DeployedContract(
    ContractAbi.fromJson(abi, ''),
    EthereumAddress.fromHex(contractAddress),
  );

  var count = 18;

  final decimals = contract.function('decimals');


  try{
    final result = await client.call(contract: contract, function: decimals, params: []);

    print(result[0].toString());
    count=int.parse(result[0].toString());

  } catch(e){

    throw Exception('Unable to read decimal of token.');
  }


  final transferFunction = contract.function('transfer');

  // Convert amount to BigInt directly
  String convertedAmount = (double.parse(amount)*100).toStringAsFixed(0);

  print(convertedAmount);
  final value = BigInt.parse(convertedAmount) * BigInt.from(pow(10, count-2));

  final parameters = [EthereumAddress.fromHex(toAddress), value];
  final transaction = Transaction.callContract(
    contract: contract,
    function: transferFunction,
    parameters: parameters,
  );

  try {
    final result = await client.sendTransaction(credentials, transaction, chainId: chainId);
    return result;
  } catch (e) {
    throw Exception('Failed to transfer token: $e');
  }

  throw Exception('Failed to transfer token:');
}
