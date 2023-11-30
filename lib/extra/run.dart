import 'package:flutter/material.dart';
import 'package:web3dart/contracts.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

import '../utils/app_config.dart';
import '../utils/secure_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Token Swap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TokenSwap(),
    );
  }
}

class TokenSwap extends StatefulWidget {
  @override
  _TokenSwapState createState() => _TokenSwapState();
}

class _TokenSwapState extends State<TokenSwap> {
  double _tokenAmount = 0;
  double _usdAmount = 0;
  double _currentExchangeRate = 1; // Replace with the actual exchange rate
  bool _isConvertingToToken = true;
  final SecureStorage secureStorage = SecureStorage();
  final String rpcUrl = "https://data-seed-prebsc-1-s1.binance.org:8545/"; // Replace with your RPC URL// Replace with the actual contract address
  final String contract_ABI ='[{"inputs":[{"internalType":"address","name":"_buytoken","type":"address"},{"internalType":"address","name":"_saletoken","type":"address"}],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"buyer","type":"address"},{"indexed":true,"internalType":"uint256","name":"spent","type":"uint256"},{"indexed":true,"internalType":"uint256","name":"recieved","type":"uint256"}],"name":"Buy","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"buyer","type":"address"},{"indexed":true,"internalType":"uint256","name":"spent","type":"uint256"},{"indexed":true,"internalType":"uint256","name":"recieved","type":"uint256"}],"name":"Sale","type":"event"},{"inputs":[],"name":"Buystatus","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"Sellstatus","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"amnt","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"address","name":"token","type":"address"}],"name":"buy","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"buyRatePerToken","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"rate","type":"uint256"},{"internalType":"uint256","name":"div","type":"uint256"}],"name":"buygetrate","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"buytoken","outputs":[{"internalType":"contract BEP20","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"contract BEP20","name":"_buytoken","type":"address"},{"internalType":"contract BEP20","name":"_saletoken","type":"address"}],"name":"changeToken","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"rateDiv","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"contract BEP20","name":"b_token","type":"address"}],"name":"sale","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"rate","type":"uint256"},{"internalType":"uint256","name":"div","type":"uint256"}],"name":"salegetrate","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"saletoken","outputs":[{"internalType":"contract BEP20","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"sellRatePerToken","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_status","type":"uint256"}],"name":"setBuyStatus","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_status","type":"uint256"}],"name":"setSellStatus","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address payable","name":"_contributors","type":"address"},{"internalType":"uint256","name":"_balances","type":"uint256"},{"internalType":"contract BEP20","name":"token","type":"address"}],"name":"shareSingleContribution","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"contract BEP20","name":"BUSD","type":"address"},{"internalType":"address","name":"userAddress","type":"address"},{"internalType":"uint256","name":"amt","type":"uint256"}],"name":"withdraw","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"}]';
  final String BEP20_ABI='[{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"spender","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Transfer","type":"event"},{"constant":true,"inputs":[],"name":"_decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"_name","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"_symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"spender","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"burn","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"subtractedValue","type":"uint256"}],"name":"decreaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getOwner","outputs":[{"internalType":"address","name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"addedValue","type":"uint256"}],"name":"increaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"mint","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"renounceOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"sender","type":"address"},{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"}]';
  final String custToken_ABI='[{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"spender","type":"address"},{"name":"value","type":"uint256"}],"name":"approve","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"sender","type":"address"},{"name":"recipient","type":"address"},{"name":"amount","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"spender","type":"address"},{"name":"addedValue","type":"uint256"}],"name":"increaseAllowance","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"account","type":"address"}],"name":"balanceOf","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"spender","type":"address"},{"name":"subtractedValue","type":"uint256"}],"name":"decreaseAllowance","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"},{"name":"amount","type":"uint256"}],"name":"transfer","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"owner","type":"address"},{"name":"spender","type":"address"}],"name":"allowance","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"}]';
  late final String privateKey; // Replace with your private key

  late Web3Client client;
  late EthereumAddress contractAddr;
  late EthereumAddress ExchangeToken;
  late EthereumAddress allowanceFor;
  late EthereumAddress custToken;
  late Credentials credentials;
  late final String myAddress;// State of the switch

  @override
  void initState() {
    super.initState();
    initializeAsyncData();
  }

  Future<void> initializeAsyncData() async {
    client = Web3Client(rpcUrl, http.Client());
    contractAddr = EthereumAddress.fromHex('0x05933562831083724726bf2f4Cf14FfdE41B3C0A');
    ExchangeToken = EthereumAddress.fromHex('0x5f6Cc322C1849cfC769fA4c4D9e2E274e8c78A55');
    custToken = EthereumAddress.fromHex('0xa30C22b19fCd4A7209d9E55e15D890a350c6Ae4F');
    myAddress = (await secureStorage.read('ethAddress') as String?)!;
    privateKey = (await secureStorage.read('privateKey') as String?)!;
    credentials = EthPrivateKey.fromHex(privateKey);
    // Initialize your contract ABI
    final contractABI = ContractAbi.fromJson(contract_ABI, 'BuySell'); // Replace ABI with your contract's ABI
    final contract = DeployedContract(contractABI, contractAddr);
    // Fetch and update the current exchange rate
    final query = contract.function((_isConvertingToToken) ? 'buyRatePerToken' : 'sellRatePerToken');
    final buyRateResult = await client.call(contract: contract, function: query, params: []);
    final buyRateHex = buyRateResult[0] as BigInt;
    setState(() {
      _currentExchangeRate = buyRateHex.toInt() / 100;
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
      print("Token Contract: ${tokenContract.address}");
      // Access the 'approve' function from the ABI
      final approveFunction = tokenContract.function('increaseAllowance');
      print("Function Name: ${approveFunction.name}");
      // Set the parameters: smart contract address and the amount of allowance to increase
      final response = await client.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: tokenContract,
          function: approveFunction,
          parameters: [contractAddr, BigInt.from(_tokenAmount * 1e18)],
          // set your max gas limit// replace with the correct chain ID for your network
        ),
          chainId: 97
      );

      print("Transaction Hash: ${response}");

      // Await for the transaction receipt for confirmation
      final receipt = await client.getTransactionReceipt(response);
      print("Token allowance increased successfully: $receipt");
    } catch (error) {
      print("Error encountered: $error");
    }
  }


  Future<void> _swapTokens() async {
    await increaseAllowance();
    final contract = DeployedContract(
      ContractAbi.fromJson(contract_ABI, "BuySell"), // Replace ABI with the contract's ABI
      contractAddr,
    );

    final contractFunction = contract.function((_isConvertingToToken) ? "buy" : "sale");
    final trans = await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: contractFunction,
        parameters: [BigInt.from(_tokenAmount * 1e18),ExchangeToken],
      ),
        chainId: 97
    );


    // Wait for transaction receipt
    await client.getTransactionReceipt(trans);
    print("Tokens bought successfully!");
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Token Swap'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (_isConvertingToToken) ? _updateTokenAmount : _updateUSDAmount,
                decoration: InputDecoration(
                  labelText: (_isConvertingToToken) ? 'Enter USD amount' : 'Enter Token amount',
                  border: OutlineInputBorder(),
                ),
              ),
              Switch(
                value: _isConvertingToToken,
                onChanged: (value) {
                  setState(() {
                    _isConvertingToToken = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Text((_isConvertingToToken) ? 'Estimated Token Amount: $_tokenAmount' : 'Estimated USD Amount: $_usdAmount'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _showConfirmationPopup,
                child: Text('Swap'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateTokenAmount(String usdAmount) {
    setState(() {
      _usdAmount = double.tryParse(usdAmount) ?? 0;
      _tokenAmount = _usdAmount / _currentExchangeRate;
    });
  }

  void _updateUSDAmount(String tokenAmount) {
    setState(() {
      _tokenAmount = double.tryParse(tokenAmount) ?? 0;
      _usdAmount = _tokenAmount * _currentExchangeRate;
    });
  }
}
