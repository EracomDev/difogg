import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:difog/screens/qr_code.dart';
import 'package:difog/screens/transfer.dart';
import 'package:difog/utils/app_config.dart';
import '../services/api_service.dart';
import '../services/contract_service.dart';
import '../utils/secure_storage.dart';
import '../services/blockchain_service.dart';
import '../utils/blockchains.dart';
import 'app_layout.dart';
import 'coming_soon.dart';
import 'custom_swap.dart';
import 'transaction_list.dart';
import '../models/transaction_model.dart';


class CryptoPage extends StatefulWidget {
  final String cryptoName;
  final String symbol;

  const CryptoPage({required this.cryptoName,required this.symbol});
  @override
  _CryptoPageState createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {

  final SecureStorage secureStorage = SecureStorage();
  BlockchainDataManager? showDetails;
  final BlockchainData blockchainData = BlockchainData(); // Initialize blockchainData with a default value
  Map<String, dynamic> contractData = {};
  String contractAddressHex = '';
  String blockchain = '';
  String? address;
  String? symbol;
  String assetName='';
  String balance = '';
  double price = 0.0;
  double change = 0.0;// Add a balance variable
  List<MyTransaction> transactions = []; // Declare transactions as a list
  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    address = await secureStorage.read('ethAddress') as String?;
    ContractService contractService = ContractService();

    print(widget.cryptoName);
    assetName=widget.cryptoName;
    //print(widget.cryptoName);
    var contractArray = await contractService.getContractData(widget.cryptoName);
    List<Map<String, dynamic>> contractList = contractArray != null ? List<Map<String, dynamic>>.from(contractArray) : [];
    Map<String, dynamic> contractValue = contractList[0];
    contractAddressHex = contractValue['address'];
    blockchain = contractValue['blockchain'];
    symbol = contractValue['symbol'];
    if (showDetails == null) {
      showDetails = BlockchainDataManager(
        //'0x50966810A133cDf7083BDE254954A8D61041d09B',
        address!,
        widget.cryptoName,
        blockchain,
      );
    }
    Future<Map<String, double>> fetchPriceData(String internalName) async {
      ApiService apiService = ApiService();
      return await apiService.getPriceAndChange(internalName);
    }

    balance = await showDetails!.getBalance(isToken: contractValue['isToken']); // Assign the balance value
    transactions = await showDetails!.getTransactions(isToken: contractValue['isToken']); // Assign the transactions list

    Map<String, double> priceData = await fetchPriceData(contractValue['internalName']);
    setState(() {
    price = priceData['price'] ?? 0.0;
    change = priceData['change'] ?? 0.0;
    });
    if (assetName == AppConfig.custName) {
      dynamic rate = await contractService.getBuyOrSaleRate(true);
      setState(() {
        price = rate;
      });
    }
  }
  Future<bool> _checkIfSvgIconExists(String cryptoName) async {
    try {
      await rootBundle.load('assets/icons/$cryptoName.svg');
      return true;
    } catch (_) {
      return false;
    }
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

                  symbol==null?

                  Text("Wallet",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: AppConfig.titleIconAndTextColor,
                    ),
                  ):
                  Text("Wallet - ${symbol}",
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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(
                      '${price.toStringAsFixed(4)}',
                      style: TextStyle(
                        color: change < 0 ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(), // Pushes the change text to the right side
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        '${change > 0 ? '+' : ''}${change.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: change < 0 ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

              ),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 70.0,
                      height: 70.0,
                      child:/* assetName == "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56"
                          ? Image.asset("assets/icons/$assetName.png")
                          :*/
                       widget.symbol == "ERA"
                          ? Image.asset("assets/images/logo.png")
                          :
                      FutureBuilder<bool>(
                        future: _checkIfSvgIconExists(widget.symbol),
                        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasData && snapshot.data!) {
                            return SvgPicture.asset(
                              'assets/icons/${widget.symbol}.svg',
                              width: 70.0,
                              height: 70.0,
                              // Handle the case where the SVG is not found
                              placeholderBuilder: (BuildContext context) => SvgPicture.asset(
                                'assets/icons/default.svg', // Path to your default SVG icon
                                width: 70.0,
                                height: 70.0,
                              ),
                            );
                          } else {
                            return SvgPicture.asset(
                              'assets/icons/default.svg', // Default SVG icon
                              width: 70.0,
                              height: 70.0,
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      balance,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    symbol==null?Container(
                      child: CircularProgressIndicator(),
                    ):

                    Text(
                      '${symbol}', // Use the balance variable here
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [



                  RoundButton(
                    icon: Icons.send,
                    label: 'Send',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => sendAsset(cryptoName: widget.cryptoName),
                        ),
                      );
                    },
                  ),
                  RoundButton(
                    icon: Icons.receipt,
                    label: 'Receive',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CryptoWalletPage(walletAddress: address!, cyptotype: widget.cryptoName,),
                        ),
                      );
                    },
                  ),
                  RoundButton(
                    icon: Icons.swap_horiz,
                    label: 'Swap',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TokenSwap(cryptoName: widget.cryptoName),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 12.0),
              Align(
                alignment: Alignment.center,
                child:

                Container(

                  width: MediaQuery.of(context).size.width*.35,
                  margin: EdgeInsets.only(right: 16),

                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      //gradient: AppConfig.buttonGradient,borderRadius: BorderRadius.circular(20)

                  ),
                  child: ElevatedButton(
                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionsList(transactions: transactions, address: address!),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppConfig.primaryColor.withOpacity(.05), shadowColor: Colors.transparent),
                    child: Row(
                      children: [

                        Icon(Icons.history),
                        SizedBox(width: 16,),
                        Text('History',style: TextStyle(color: AppConfig.titleIconAndTextColor),),
                      ],
                    ),
                  ),
                )

              ),
            ],
          ),
        ),
    );
  }
}

class RoundButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Null Function() onTap;

  const RoundButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [

          CircleAvatar(
            radius: 27.0,
            backgroundColor: AppConfig.primaryColor,
            child: Icon(
              icon,
              color: AppConfig.textColor,
            ),
          ),

          SizedBox(height: 8.0),

          Text(label),

        ],
      ),
    );
  }
}
