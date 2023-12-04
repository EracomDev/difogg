import 'package:difog/utils/card_design_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:difog/utils/app_config.dart';
class WalletModel {
  final String mnemonic;
  final String ethAddress;
  final String tronAddress;
  final String privateKey;
  WalletModel({required this.tronAddress, required this.mnemonic, required this.ethAddress, required this.privateKey});
}

class WalletData extends StatelessWidget {
  final String cryptoName;
  final String symbol;
  final IconData icon;
  final String price;
  final String change;
  final String balance;
  final bool showWallet;
  final bool isToken;
  final Null Function() onTap;
  const WalletData({
    required this.cryptoName,
    required this.symbol,
    required this.icon,
    required this.price,
    required this.change,
    required this.balance,
    required this.isToken,
    this.showWallet = true,
    required this.onTap,
  });
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
    final isPositiveChange = change.startsWith('-');
    final changeColor = isPositiveChange ? Colors.red : Colors.green;

    //print(cryptoName);
    print(symbol);
    //print(icon);

    return Container(
      //elevation: 2.0,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 8),



      child:
      designNewCard(Container(

        width: 180,
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 48.0,
                    height: 35.0,
                    child:
                    //cryptoName == "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56"
                    symbol == "BUSD"
                        ? Image.asset("assets/icons/$symbol.png")
                        :
                    symbol == "ERA"?
                    Image.asset("assets/images/logo_old.png")
                        :
                    FutureBuilder<bool>(
                      future: _checkIfSvgIconExists(symbol),
                      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasData && snapshot.data!) {
                          return SvgPicture.asset(
                            'assets/icons/$symbol.svg',
                            width: 20.0,
                            height: 20.0,
                            // Handle the case where the SVG is not found
                            placeholderBuilder: (BuildContext context) => SvgPicture.asset(
                              'assets/icons/default.svg', // Path to your default SVG icon
                              width: 20.0,
                              height: 20.0,
                            ),
                          );
                        } else {
                          return SvgPicture.asset(
                            'assets/icons/default.svg', // Default SVG icon
                            width: 20.0,
                            height: 20.0,
                          );
                        }
                      },
                    ),
                  ),

                  Column(
                    children: [
                      Text(
                        symbol,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),


                      Text(
                        symbol,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),



                ],
              ),


              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  SizedBox(height: 40,),
                  Text(
                    '$balance',
                    style: TextStyle(
                      fontSize: 18.0,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 4.0),
                  Text(
                    change,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.normal,
                      color: changeColor,
                    ),
                  ),

                  SizedBox(height: 40,),
                  
                  Image.asset('assets/images/wave.png',height: 60,width: 120,color:  changeColor,fit: BoxFit.fill,)

                ],
              ),
            ],
          ),
        ),
      ),)

    );
  }
}
