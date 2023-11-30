import 'package:flutter/material.dart';
import 'package:difog/screens/app_layout.dart';
import 'package:difog/utils/app_config.dart';
import 'package:difog/utils/tools.dart';
import 'package:web3dart/contracts.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

import '../services/contract_service.dart';
import '../utils/blockchains.dart';
import '../utils/secure_storage.dart';


class TokenSwap extends StatefulWidget {
  String cryptoName;
  TokenSwap({required this.cryptoName}) {
    if (cryptoName == AppConfig.custName) {
      cryptoName = AppConfig.defaultSwap;
    }
  }
  @override
  _TokenSwapState createState() => _TokenSwapState();
}

class _TokenSwapState extends State<TokenSwap> {
  double _tokenAmount = 0;
  double _usdAmount = 0;
  double _currentExchangeRate = 1; // Replace with the actual exchange rate
  bool _isConvertingToToken = true;
  final SecureStorage secureStorage = SecureStorage();
  String rpcUrl = ""; // Replace with your RPC URL// Replace with the actual contract address
  final String contract_ABI =AppConfig.swapContractAbi;
  String BEP20_ABI='';
  final String custToken_ABI=AppConfig.custTokenAbi;
  late final String privateKey; // Replace with your private key
  late Web3Client client;
  late EthereumAddress contractAddr;
  late EthereumAddress ExchangeToken;
  late EthereumAddress allowanceFor;
  late EthereumAddress custToken;
  late Credentials credentials;
  late final String myAddress;// State of the switch
  String blockchain = '';
  String? symbol;
  late int chainId;
  late DeployedContract contract;

  bool isValidCryptoName(String name) {
    final validAddresses = AppConfig.validAddresses;
    return validAddresses.contains(name);
  }

  @override
  void initState() {
    super.initState();
    initializeAsyncData();
  }

  Future<void> initializeAsyncData() async {
    ContractService contractService = ContractService();
    final blockchainData = BlockchainData();
    var contractArray = await contractService.getContractData(widget.cryptoName);
    List<Map<String, dynamic>> contractList = contractArray != null ? List<Map<String, dynamic>>.from(contractArray) : [];
    Map<String, dynamic> exchangeTokenData = contractList[0];
    blockchain = exchangeTokenData['blockchain'];
    symbol = exchangeTokenData['symbol'];
    final chainData = blockchainData.getChainData(exchangeTokenData['blockchain']);
    rpcUrl=chainData['rpcUrl'];
    chainId=chainData['chainId'];
    client = Web3Client(rpcUrl, http.Client());
    BEP20_ABI = (await ContractService().readAbiFromFile(widget.cryptoName)!)!;
    contractAddr = EthereumAddress.fromHex(AppConfig.swapContractAddress);
    ExchangeToken = EthereumAddress.fromHex(exchangeTokenData['address']);
    custToken = EthereumAddress.fromHex(AppConfig.custToken);
    myAddress = (await secureStorage.read('ethAddress') as String?)!;
    //print(myAddress);
    privateKey = (await secureStorage.read('privateKey') as String?)!;
    credentials = EthPrivateKey.fromHex(privateKey);
    // Initialize your contract ABI
    final contractABI = ContractAbi.fromJson(contract_ABI, 'BuySell'); // Replace ABI with your contract's ABI
    contract = DeployedContract(contractABI, contractAddr);
    // Fetch and update the current exchange rate
    final query = contract.function((_isConvertingToToken) ? 'buyRatePerToken' : 'sellRatePerToken');
    final buyRateResult = await client.call(contract: contract, function: query, params: []);
    final buyRateHex = buyRateResult[0] as BigInt;
    setState(() {
      _currentExchangeRate = buyRateHex.toInt() / 1000;
    });
  }

  Future<void> increaseAllowance() async {
    try {
      // Load the BEP20 token's contract
      allowanceFor=(_isConvertingToToken) ? ExchangeToken : custToken;
      final tokenContract = DeployedContract(
        // Load the BEP20 token's ABI here
        ContractAbi.fromJson((_isConvertingToToken) ? BEP20_ABI : custToken_ABI, "BEP20Token"),
        allowanceFor,  // The address of the BEP20 token you're interacting with
      );

      // Access the 'approve' function from the ABI
      final approveFunction = tokenContract.function('increaseAllowance');
      // Set the parameters: smart contract address and the amount of allowance to increase
      final response = await client.sendTransaction(
          credentials,
          Transaction.callContract(
            contract: tokenContract,
            function: approveFunction,
            parameters: [contractAddr, BigInt.from(_tokenAmount * 1e18)],
            // set your max gas limit// replace with the correct chain ID for your network
          ),
          chainId: chainId
      );

      //print("Transaction Hash: ${response}");
      // Await for the transaction receipt for confirmation
      final receipt = await client.getTransactionReceipt(response);
     // print("Token allowance increased successfully: $receipt");
    } catch (error) {
      messageDialog(context, "Error: $error");
    }
  }
  Future<void> _swapTokens() async {
    try {
      await increaseAllowance();
      await Future.delayed(Duration(seconds: 2));
      final contract = DeployedContract(
        ContractAbi.fromJson(contract_ABI, "BuySell"),
        // Replace ABI with the contract's ABI
        contractAddr,
      );
      final contractFunction = contract.function(
          (_isConvertingToToken) ? "buy" : "sale");
      final trans = await client.sendTransaction(
          credentials,
          Transaction.callContract(
            contract: contract,
            function: contractFunction,
            parameters: [BigInt.from(_tokenAmount * 1e18), ExchangeToken],
          ),
          chainId: chainId
      );
      // Wait for transaction receipt
      var res = await client.getTransactionReceipt(trans);
      print("Transaction completed successfully! $res");
      messageDialog(context, "Transaction completed successfully!");
    }catch(e){
      messageDialog(context, "Tx Error: $e");
    }
  }
  Future<void> _showConfirmationPopup() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevents closing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppConfig.background,
          title: Text('Confirm Swap'),
          content: Text('Are you sure you want to perform the swap?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Swap'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _swapTokens(); // Call the swap function here
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    bool isValidCrypto = isValidCryptoName(widget.cryptoName);

      return AppLayout(
        child: Scaffold(


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


                  Text("Token Swap",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: AppConfig.titleIconAndTextColor,
                    ),
                  ),
                ],
              ),

            ),

          ),
          body:
          isValidCrypto?

          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: _updateUSDAmount,
                    decoration: InputDecoration(
                      labelText: 'Enter ${AppConfig.custName} amount to ${_isConvertingToToken ? 'buy' : 'sell'}',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Switch(
                    value: _isConvertingToToken,
                    onChanged: (value) async {
                      setState(() {
                        _isConvertingToToken = value;
                      });
                      final query = contract.function(_isConvertingToToken ? 'buyRatePerToken' : 'sellRatePerToken');
                      final rateResult = await client.call(contract: contract, function: query, params: []);
                      final rateHex = rateResult[0] as BigInt;
                      setState(() {
                        _currentExchangeRate = rateHex.toInt() / 1000;
                      });
                      // Call _updateUSDAmount here as well
                      _updateUSDAmount(_tokenAmount.toString());
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    _isConvertingToToken
                        ? 'Estimated payment: ${(_usdAmount).toStringAsFixed(4)} ${symbol}'
                        : 'Estimated receive: ${(_usdAmount).toStringAsFixed(4)} ${symbol}',
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _showConfirmationPopup,
                    child: Text('Swap'),
                  ),
                ],
              ),
            ),
          ):Center(
            child: Text('Here you can swap only USDT-BEP20 or BUSD-BEP20'),
          ),
        ),
      );

  }
  void _updateUSDAmount(String tokenAmount) {
    setState(() {
      _tokenAmount = double.tryParse(tokenAmount) ?? 0;
      _usdAmount = _tokenAmount * _currentExchangeRate;
    });
  }

}
