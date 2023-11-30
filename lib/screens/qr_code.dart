import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/services.dart';

import '../utils/app_config.dart';


class CryptoWalletPage extends StatelessWidget {
  final String walletAddress;
  final cyptotype;

  CryptoWalletPage({required this.walletAddress, required this.cyptotype});

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: walletAddress));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Wallet address copied to clipboard')),
    );
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
                Text("Crypto Wallet",
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

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Scan Wallet Address',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              BarcodeWidget(
                barcode: Barcode.qrCode(),
                color: Colors.white,
                data: walletAddress,
                width: 200.0,
                height: 200.0,
              ),
              SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SelectableText(
                  walletAddress,
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => _copyToClipboard(context),
                icon: Icon(Icons.copy),
                label: Text('Copy Address'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Payment Instructions:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1. Open your crypto wallet app.',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '2. Scan the QR code or copy the wallet address.',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '3. Paste the wallet address in the recipient field.',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '4. Enter the amount of $cyptotype you want to send.',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '5. Review the transaction details.',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '6. Confirm and send the payment.',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '7. You can receive any Ethereum Virtual Machine(EVM) supported coin or Token on this address.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
