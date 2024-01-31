import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:difog/screens/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/contract_service.dart';
import '../services/transfer_service.dart';
import '../utils/app_config.dart';
import '../widgets/check_password_dialog.dart';
import '../widgets/success_or_failure_dialog.dart';


class sendAsset extends StatefulWidget {
  final String cryptoName;
  const sendAsset({required this.cryptoName});

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
  Future<String>? transactionResult;

  @override
  void initState() {
    _loadContractData();
    super.initState();


    asset = widget.cryptoName;
    print("transfer="+asset);
  }

  Future<void> _scanQRCode() async {
    try {
      var qrResult = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QRView(
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

      showDialog(context: context,
          builder: (BuildContext context){
            return AlertDialogBox(
              type: "failure",
              title: "Failed Alert",
              desc: "Failed to scan qr code",

            );
          }
      );


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
    var contractArray = await contractService.getContractData(widget.cryptoName);
    List<Map<String, dynamic>> contractList = contractArray != null ? List<Map<String, dynamic>>.from(contractArray) : [];
    Map<String, dynamic> contractValue = contractList.isNotEmpty ? contractList[0] : {};
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Transaction hash copied')));
  }

  void goToWallet() {
    // Add your implementation to navigate to the wallet screen
    Navigator.push(context, MaterialPageRoute(builder: (context) => CryptoWalletDashboard()));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


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


              Text("Asset Transfer",
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
              SizedBox(height: 16),
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
                        decoration: InputDecoration(
                          labelText: 'Recipient address',
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.paste,color: Colors.white,),
                      onPressed: pasteClipboardData,
                    ),
                    IconButton(
                      icon: Icon(Icons.qr_code,color: Colors.white,),
                      onPressed: _scanQRCode, // This function will handle the QR code scanning
                    ),
                  ],
                ),
              SizedBox(height: 16),
              if (transactionResult == null)
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            amount = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(symbol), // Show the crypto name on the right side of the amount box
                  ],
                ),
              SizedBox(height: 16),
              if (transactionResult == null)
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {

                            return ConfirmPasswordBox(
                              function: (){


                                //print("fgfdgdg");

                                setState(() {
                                  transactionResult = transferAsset(asset, addressToSend, amount);
                                });

                              },);
                          });


                    }
                  },
                  child: Text('Send Asset'),
                ),
              if (transactionResult != null)
                FutureBuilder<String>(
                  future: transactionResult,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      //return Text('Error: ${snapshot.error}');
                      return Text('We regret to inform you that the transaction could not be completed. Please review your account balance and transaction fee.');
                    } else if (snapshot.hasData) {
                      return Column(
                        children: [
                          Text('Transaction Hash: ${snapshot.data}'),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () => copyTransactionHash(snapshot.data!),
                                child: Text('Copy Transaction Hash'),
                              ),
                              ElevatedButton(
                                onPressed: goToWallet,
                                child: Text('Go to Wallet'),
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
