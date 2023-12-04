import 'dart:developer';
import 'dart:io';

import 'package:difog/utils/card_design_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:difog/models/wallet.dart';
import 'package:difog/utils/card_design.dart';
import '../components/header.dart';
import '../utils/app_config.dart';
import 'add_asset.dart';
import 'app_layout.dart';
import '../services/wallet_data.dart';
import 'asset_list.dart';
import 'create_wallet_screen.dart';
import 'view_wallet.dart';


class CryptoWalletDashboard extends StatefulWidget {
  @override
  _CryptoWalletDashboardState createState() => _CryptoWalletDashboardState();
}

class _CryptoWalletDashboardState extends State<CryptoWalletDashboard> {

  var size;
  DateTime? currentBackPressTime;
  final walletService = WalletService();
  Future<bool> _onWillPop() async {
    final DateTime now = DateTime.now();
    final difference = currentBackPressTime == null
        ? null
        : now.difference(currentBackPressTime!);
    currentBackPressTime = now;

    if (difference != null && difference <= Duration(seconds: 2)) {
      // Allow app exit
      exit(0);
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Press back again to exit')),
      );
      return false; // Prevent app exit
    }
  }

  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;
    return
      FutureBuilder<List<WalletData>>(
        future: walletService.getWallets(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AppLayout(
              child: SpinKitFadingFour(
                color: AppConfig.primaryColor,
                size: 50.0,
              ),
            );
          }
          //print(snapshot.data);
          if (snapshot.data == null || snapshot.data!.isEmpty || snapshot.data!.length==0) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: AppConfig.background,
                    title: Text('No Wallet Found'),
                    content: Text('Create a wallet now!'),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CreateWalletScreen()),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            });
          }

          final List<WalletData> wallets = snapshot.data ?? [];

          print(wallets.length);
          return FutureBuilder<String>(
            future: walletService.WallatTotalBalance(),
            builder: (context, balanceSnapshot) {
              if (balanceSnapshot.connectionState == ConnectionState.waiting) {
                return AppLayout(
                  child: SpinKitFadingFour(
                    color: AppConfig.primaryColor,
                    size: 50.0,
                  ),
                );
              }
              if (balanceSnapshot.hasError) {
                // print('Error fetching total balance: ${balanceSnapshot.error}');
                return Text(' ');
              }
              final String totalBalance = balanceSnapshot.data ?? '0';
              return AppLayout(
                child: Scaffold(
                  //appBar: Header(),
                  body: Stack(


                    children: [


                      Positioned(
                        left: -100,
                        top: -40,

                        child: Container(
                          height: size.width*.55,
                          width: size.width*.55,
                          // color: Colors.yellow,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, color: AppConfig.primaryColor.withOpacity(.08),
                            //border: Border.all(style: BorderStyle.solid,width: 2,color: MyColors.primary.withOpacity(.6))
                          ),


                        ),
                      ),

                      Positioned(
                        right: -80,
                        top: 150,

                        child: Container(
                          height: size.width*.6,
                          width: size.width*.6,
                          // color: Colors.yellow,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color:  Colors.deepOrange.withOpacity(.08)
                            //border: Border.all(style: BorderStyle.solid,width: 2,color: MyColors.secondary.withOpacity(.6))
                          ),


                        ),
                      ),

                      Positioned(
                        right: 4,
                        top: 20,

                        child: Container(
                          height: 50,
                          width: 50,
                          // color: Colors.yellow,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, color: AppConfig.primaryColor.withOpacity(.1),
                            //border: Border.all(style: BorderStyle.solid,width: 2,color: MyColors.primary.withOpacity(.6))
                          ),


                        ),
                      ),

                      Positioned(
                        left: 4,
                        bottom: 10,

                        child: Container(
                          height: size.width*.2,
                          width: size.width*.2,
                          // color: Colors.yellow,
                          decoration: BoxDecoration(

                            shape: BoxShape.circle, color: Colors.deepOrange.withOpacity(.08),
                            //border: Border.all(style: BorderStyle.solid,width: 2,color: MyColors.primary.withOpacity(.6))
                          ),


                        ),
                      ),

                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.zero,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [

                              SizedBox(height: 16,),
                              BalanceCard(
                                cryptoName: 'Total',
                                balanceInUSD: '\$$totalBalance',
                              ),
                              SizedBox(height: 16.0),

                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'My Portfolio',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),

                              Container(
                                height: 280,
                                child: ListView(
                                  //physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  children: wallets.map((wallet) => wallet.showWallet
                                      ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CryptoPage(cryptoName: wallet.cryptoName,symbol: wallet.symbol,),
                                        ),
                                      );
                                    },
                                    child: WalletData(
                                      cryptoName: wallet.cryptoName,
                                      symbol: wallet.symbol,
                                      icon: wallet.icon!,
                                      price: wallet.price!,
                                      change: wallet.change!,
                                      balance: wallet.balance!,
                                      isToken: wallet.isToken!,
                                      onTap: () {},
                                    ),
                                  )
                                      : SizedBox()).toList(),),
                              ),

                              /*...wallets.map(

                                      (wallet) {
                                    return wallet.showWallet
                                        ? GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CryptoPage(cryptoName: wallet.cryptoName,symbol: wallet.symbol,),
                                          ),
                                        );
                                      },
                                      child: WalletData(
                                        cryptoName: wallet.cryptoName,
                                        symbol: wallet.symbol,
                                        icon: wallet.icon!,
                                        price: wallet.price!,
                                        change: wallet.change!,
                                        balance: wallet.balance!,
                                        isToken: wallet.isToken!,
                                        onTap: () {},
                                      ),
                                    )
                                        : SizedBox();
                                  }).toList(),*/
                              SizedBox(height: 8.0), // Add some spacing below the wallets

                              /*FutureBuilder<dynamic>(
                                  future: walletService.cryptoData(context),
                                  builder: (context, snapshot) {



                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Text(' ');
                                    }
                                    if (snapshot.hasError) {
                                      // print('Error fetching total balance: ${balanceSnapshot.error}');
                                      return Text(' ');
                                    }

                                    var list = snapshot.data;


                                    print("fghdfghfdhfgdhdfg");
                                    log(list.toString());

                                    list.map((singleData){

                                      //print(singleData);

                                      return Container(
                                        //elevation: 2.0,
                                          padding: EdgeInsets.all(8),
                                          margin: EdgeInsets.symmetric(horizontal: 16),


                                          child:
                                          designNewCard( Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                        width: 48.0,
                                                        height: 35.0,
                                                        child:
                                                        //cryptoName == "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56"
                                                        Image.network(singleData["image"])
                                                    ),
                                                    SizedBox(width: 5.0),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          singleData["symbol"],
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(height: 4.0),
                                                        Text(
                                                          singleData["current_price"].toString(),
                                                          style: TextStyle(
                                                            fontSize: 18.0,
                                                          ),
                                                        ),
                                                        SizedBox(height: 4.0),
                                                        Text(
                                                          singleData["price_change_24h"].toString(),
                                                          style: TextStyle(
                                                            fontSize: 12.0,
                                                            fontWeight: FontWeight.normal,
                                                            //color: changeColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),

                                              ],
                                            ),
                                          ),)

                                      );
                                    });



                                    //for(var i = 0; i< list.length; i++)
                                    //for(var singleData in  list)

                                      //var singleData= list[i];
                                      //print("singleData");
                                      //print(singleData);




                                    return Text(' ');
                                  })*/


                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );


        },
      );

  }
}

class BalanceCard extends StatelessWidget {
  final String cryptoName;
  final String balanceInUSD;

  const BalanceCard({
    required this.cryptoName,
    required this.balanceInUSD,
  });

  @override
  Widget build(BuildContext context) {
    return

      Container(
      //decoration: decoration,
      //margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  'Total Balance',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),

                SizedBox(height: 8.0),

                Text(
                  balanceInUSD,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            Spacer(),

            Container(
              decoration: BoxDecoration(
                /*image: new DecorationImage(
                  image: new AssetImage("assets/images/design4.png"),
                  fit: BoxFit.fill,
                ),*/
                borderRadius: BorderRadius.circular(16),

                border: Border.all(color: Color(0xFF454A55),width: 1),
                //border: Border.all(color: Color(0xFF020A2A),width: .5),

                gradient: AppConfig.containerGradientNew,

                /*boxShadow: [
                 BoxShadow(
                   color: Colors.black.withOpacity(0.01),
                   spreadRadius: 5,
                   blurRadius: 5,
                   offset: Offset(0, 3), // changes position of shadow
                 ),
               ],*/

              ),
              child: Text("USD"),
            padding: EdgeInsets.fromLTRB(16, 6, 16, 6),)
          ],
        ),
      ),
    );
  }
}
