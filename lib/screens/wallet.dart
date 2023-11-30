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

                              /*Container(
                                height: 150,
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
                              ),*/

                              ...wallets.map(

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
                              }).toList(),
                              SizedBox(height: 8.0), // Add some spacing below the wallets
                              /*TextButton(
                                onPressed: () {
                                  // Navigate to the screen to add a new asset
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => AssetList()),
                                  );
                                },
                                child: Row(
                                  children: [

                                    Icon(Icons.add,color: Colors.white,),
                                    Text('Add New Asset',style: TextStyle(color: Colors.white),),
                                  ],
                                ),
                              ),*/
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
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                Text(
                  'Total Balance',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),

                Spacer(),

                Image.asset("assets/images/wave.png",width: 80,height: 40,),

              ],
            ),

            SizedBox(height: 16.0),

            Text(
              balanceInUSD,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
