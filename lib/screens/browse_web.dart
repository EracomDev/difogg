import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_injected_web3/flutter_injected_web3.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import '../utils/app_config.dart';
import '../utils/blockchains.dart';
import '../utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'app_layout.dart';


class WebBrowser extends StatelessWidget {
  late final BlockchainData blockchainData;
  late final Map<String, dynamic> chainData;
  late final String rpc;
  late final int chainId;
  late final String url; // Added URL variable

  // Updated constructor to accept URL parameter
  WebBrowser({Key? key, required this.url}) : super(key: key) {
    blockchainData = BlockchainData();
    chainData = blockchainData.getChainData(AppConfig.ChainName); // Replace chainName with the actual chain name.
    rpc = chainData['rpcUrl'];
    chainId = chainData['chainId'];
  }

  @override
  Widget build(BuildContext context) {
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


                Text("Browser",
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
        body: InjectedWebview(
          addEthereumChain: changeNetwork,
          requestAccounts: getAccount,
          signTransaction: (controller, data, chainId) => signTransaction(context, controller, data, chainId),
          signPersonalMessage: signPersonelMessage,
          isDebug: true,
          initialUrlRequest: URLRequest(url: Uri.parse(url)), // Use the passed URL
          chainId: chainId,
          rpc: rpc,
        ),
      ),
    );
  }

  Future<String> changeNetwork(
      InAppWebViewController controller, JsAddEthereumChain data, int chainId) async {
    try {
      rpc = "https://rpc.ankr.com/eth";
      chainId = int.parse(data.chainId!);
    } catch (e) {
      debugPrint("$e");
    }
    return rpc;
  }

  Future<IncomingAccountsModel> getAccount(
      InAppWebViewController _, String ___, int __) async {
    final SecureStorage secureStorage = SecureStorage();
    final address = await secureStorage.read('ethAddress');
    //print(address);
    return IncomingAccountsModel(
      address: address.toString(),
      chainId: chainId,
      rpcUrl: rpc,
    );
  }

  Future<String> signTransaction(BuildContext context, InAppWebViewController _, JsTransactionObject data, int chainId) async {
    try {
      final SecureStorage secureStorage = SecureStorage();
      final privateKey = await secureStorage.read('privateKey');

      final httpClient = http.Client();
      final client = Web3Client(rpc, httpClient);

      final credentials = EthPrivateKey.fromHex(privateKey!);

      final address = await credentials.extractAddress();
      final nonce = await client.getTransactionCount(address);

      final transaction = Transaction(
        to: EthereumAddress.fromHex(data.to!),
        value: EtherAmount.inWei(BigInt.parse(data.value!)),
        gasPrice: EtherAmount.inWei(BigInt.parse("10000000000")),
        maxGas: int.parse(data.gas!),
        nonce: nonce,
        data: data.data != null ? hexToBytes(data.data!) : null,
      );

      bool confirmTransaction = false;

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppConfig.background,
            title: Text("Confirm Transaction"),
            content: Text("Do you want to sign and send the transaction?"),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("Confirm"),
                onPressed: () {
                  confirmTransaction = true;
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      if (confirmTransaction) {
        final signedTransaction = await client.signTransaction(credentials, transaction, chainId: chainId);
        final hash = await client.sendRawTransaction(signedTransaction);
        return hash;
      }
    } catch (e) {
      debugPrint("$e");
    }
    return "";
  }

  Future<String> signPersonelMessage(
      InAppWebViewController _,
      String data,
      int chainId,
      ) async {
      try {
        final SecureStorage secureStorage = SecureStorage();
        final privateKey = await secureStorage.read('privateKey');
        Credentials fromHex = EthPrivateKey.fromHex(privateKey!);
        final sig = await fromHex.signPersonalMessage(hexToBytes(data));
        //debugPrint("SignedTx ${sig}");
        return bytesToHex(sig, include0x: true);
      } catch (e) {
        debugPrint("$e");
      }
    return "";
  }
}
