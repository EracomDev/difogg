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

Future<String> sendCoin(String rpcUrl, String addressToSend, String amount,int ChainId) async {
  final SecureStorage secureStorage = SecureStorage();
  final privateKey = await secureStorage.read('privateKey');
  final client = Web3Client(rpcUrl, Client());
  final credentials = EthPrivateKey.fromHex(privateKey!);
  final address = EthereumAddress.fromHex(addressToSend); // Recipient's address
  final amountInWei = (double.parse(amount) * pow(10, 18)).toInt();
  final value = EtherAmount.inWei(BigInt.from(amountInWei));
  final transaction = Transaction(
    to: address,
    value: value,
  );
  try {
    final transactionHash = await client.sendTransaction(credentials, transaction, chainId: ChainId);
    return transactionHash;
  } catch (e) {
    //////print(e);
    throw Exception('Failed to send transaction: $e');
  }
}

Future<String> transferToken(String rpcUrl, String Abi, String ContractAddress, String toAddress, int ChainId, String amount) async {
  final SecureStorage secureStorage = SecureStorage();
  final privateKey = await secureStorage.read('privateKey');
  final credentials = EthPrivateKey.fromHex(privateKey!);
  final client = Web3Client(rpcUrl, Client());
  final contract = DeployedContract(
    ContractAbi.fromJson(Abi, ''),
    EthereumAddress.fromHex(ContractAddress),
  );

  final transferFunction = contract.function('transfer');
  final value = BigInt.parse((double.parse(amount) * pow(10, 18)).toStringAsFixed(0));
  final parameters = [EthereumAddress.fromHex(toAddress), value];
  final transaction = Transaction.callContract(
    contract: contract,
    function: transferFunction,
    parameters: parameters,
  );
  try {
    final result = await client.sendTransaction(credentials, transaction, chainId: ChainId);
    return result;
  } catch (e) {
    throw Exception('Failed to transfer token: $e');
  }
}