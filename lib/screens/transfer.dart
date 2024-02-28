// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:difog/screens/main_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:difog/screens/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/contract_service.dart';
import '../services/transfer_service.dart';
import '../utils/app_config.dart';
import '../widgets/check_password_dialog.dart';
import '../widgets/success_or_failure_dialog.dart';
import '../services/api_service.dart';
import '../services/blockchain_service.dart';
import '../utils/secure_storage.dart';
import '../utils/blockchains.dart';
import '../models/transaction_model.dart';

class sendAsset extends StatefulWidget {
  final String cryptoName;
  final double liveRate;
  final String totalToken;

  const sendAsset(
      {required this.cryptoName,
      required this.liveRate,
      required this.totalToken});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<sendAsset> {
  final _formKey = GlobalKey<FormState>();
  String asset = '';
  String addressToSend = '';
  String amount = '';
  String symbol = '';
  final addressController = TextEditingController();
  final amountController = TextEditingController();
  Future<String>? transactionResult;
  final SecureStorage secureStorage = SecureStorage();
  BlockchainDataManager? showDetails;
  final BlockchainData blockchainData =
      BlockchainData(); // Initialize blockchainData with a default value
  Map<String, dynamic> contractData = {};
  String contractAddressHex = '';
  String blockchain = '';
  String? address;
  String assetName = '';
  String balance = '';
  double price = 0.0;
  double usdtAmount = 0.0;
  bool loading = false;
  double change = 0.0; // Add a balance variable
  bool maxLoading = false;
  List<MyTransaction> transactions = []; // Declare transactions as a list

  @override
  void initState() {
    initialize();
    print("live rate ${widget.liveRate}");
    _loadContractData();
    super.initState();

    asset = widget.cryptoName;
    print("transfer=" + asset);
  }

  Future<void> initialize() async {
    try {
      setState(() {
        loading = true;
      });
      address = await secureStorage.read('ethAddress');
      ContractService contractService = ContractService();

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
      showDetails ??= BlockchainDataManager(
        address!,
        widget.cryptoName,
        blockchain,
      );
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
      setState(() {
        price = priceData['price'] ?? 0.0;
        change = priceData['change'] ?? 0.0;
        loading = false;
      });
      if (assetName == AppConfig.custName) {
        setState(() {
          balance;
          price = double.parse(AppConfig.tokenRate);
          loading = false;
        });
        setUsdtAmount(amount);
      }
      print("999999999999999999999999999999 $price");
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _scanQRCode() async {
    try {
      var qrResult = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                )),
      );

      if (qrResult != null) {
        setState(() {
          addressToSend = qrResult;
          addressController.text = qrResult;
        });
      }
    } catch (ex) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialogBox(
              type: "failure",
              title: "Failed Alert",
              desc: "Failed to scan qr code",
            );
          });
    }
  }

  Future<void> addMaxData() async {
    try {
      if (symbol == 'BNB') {
        setState(() {
          maxLoading = true;
        });
        // print("price $balance");
        String myAddress = await secureStorage.read('ethAddress') as String;
        double gasFee =
            await estimateGasFees(myAddress, addressController.text, balance);
        double bal = double.parse(balance);
        print("bal $bal");
        if (gasFee < bal) {
          // print("gasFee $gasFee");
          String newBalance = (double.parse(balance) - gasFee).toString();
          // print("newBalance $newBalance");
          setUsdtAmount(newBalance);
          setState(() {
            amount = newBalance;
            amountController.text = newBalance;
            maxLoading = false;
          });
        } else {
          setState(() {
            amount = "0";
            amountController.text = "0";
            maxLoading = false;
          });
        }
      } else if (symbol == 'USDT') {
        String newBal = (double.parse(balance) - 0.01).toString();
        setUsdtAmount(newBal);
        setState(() {
          amount = newBal;
          amountController.text = newBal;
        });
      } else {
        setUsdtAmount(balance);
        setState(() {
          amount = balance;
          amountController.text = balance;
        });
      }
    } catch (e) {
      setState(() {
        maxLoading = false;
      });
    }
  }

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      Navigator.pop(context, scanData.code);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    addressController.dispose();
    super.dispose();
  }

  void _loadContractData() async {
    ContractService contractService = ContractService();
    var contractArray =
        await contractService.getContractData(widget.cryptoName);
    List<Map<String, dynamic>> contractList = contractArray != null
        ? List<Map<String, dynamic>>.from(contractArray)
        : [];
    Map<String, dynamic> contractValue =
        contractList.isNotEmpty ? contractList[0] : {};
    setState(() {
      symbol = contractValue['symbol'];
    });
  }

  Future<void> pasteClipboardData() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    if (data?.text != null) {
      setState(() {
        addressToSend = data!.text!;
        addressController.text = addressToSend;
      });
    }
  }

  void copyTransactionHash(String transactionHash) {
    Clipboard.setData(ClipboardData(text: transactionHash));
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Transaction hash copied')));
  }

  void goToWallet() {
    // Add your implementation to navigate to the wallet screen
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MainPage()));
  }

  void setUsdtAmount(amount) {
    try {
      double amountInDouble = double.parse(amount);
      if (amount.isNotEmpty && price > 0) {
        double newAmt = (amountInDouble * price);
        setState(() {
          usdtAmount = newAmt;
        });
      } else {
        setState(() {
          usdtAmount = 0.00;
        });
      }
    } catch (e) {
      setState(() {
        usdtAmount = 0.00;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.myBackground,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppConfig.titleIconAndTextColor, //change your color here
        ),
        backgroundColor: AppConfig.myBackground,

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
              Text(
                "Asset Transfer",
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 16),
              if (transactionResult == null)
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: addressController,
                        onChanged: (value) {
                          setState(() {
                            addressToSend = value;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Recipient address',
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.paste,
                        color: Colors.white,
                      ),
                      onPressed: pasteClipboardData,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.qr_code,
                        color: Colors.white,
                      ),
                      onPressed:
                          _scanQRCode, // This function will handle the QR code scanning
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              if (transactionResult == null)
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: amountController,
                        onChanged: (value) {
                          setUsdtAmount(value);
                          setState(() {
                            amount = value;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                        symbol), // Show the crypto name on the right side of the amount box
                    const SizedBox(width: 16),
                    addressController.text.length == 42
                        ? maxLoading
                            ? const CircularProgressIndicator(
                                strokeWidth: 2,
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  addMaxData();
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.zero),
                                ),
                                child: const Text('MAX'),
                              )
                        : const Center() // Show the crypto name on the right side of the amount box
                  ],
                ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "≈ \$ ${usdtAmount.toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              if (transactionResult == null)
                loading
                    ? const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmPasswordBox(
                                    function: () {
                                      //print("fgfdgdg");

                                      setState(() {
                                        transactionResult = transferAsset(
                                            asset, addressToSend, amount);
                                      });
                                    },
                                  );
                                });
                          }
                        },
                        child: const Text('Send Asset'),
                      ),
              if (transactionResult != null)
                FutureBuilder<String>(
                  future: transactionResult,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                      return const Text(
                          'We regret to inform you that the transaction could not be completed. Please review your account balance and transaction fee.');
                    } else if (snapshot.hasData) {
                      return Column(
                        children: [
                          Text('Transaction Hash: ${snapshot.data}'),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () =>
                                    copyTransactionHash(snapshot.data!),
                                child: const Text(
                                  'Copy Transaction Hash',
                                  style: TextStyle(fontSize: 11),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: goToWallet,
                                child: const Text(
                                  'Go to Dashboard',
                                  style: TextStyle(fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      // this will be shown when the button has not been pressed yet
                      return Container();
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
