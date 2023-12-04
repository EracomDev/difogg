import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:difog/screens/view_mnemonic.dart';
import 'package:difog/screens/wallet_restore.dart';
import '../routes.dart';
import '../screens/app_layout.dart';
import '../services/wallet_service.dart';
import '../utils/app_config.dart';
import '../utils/secure_storage.dart';
import '../screens/app_layout.dart';
import '../screens/coming_soon.dart';


class CreateWalletScreen extends StatefulWidget {
  @override
  _CreateWalletScreenState createState() => _CreateWalletScreenState();
}

class _CreateWalletScreenState extends State<CreateWalletScreen> {
  final WalletService walletService = WalletService();
  final SecureStorage secureStorage = SecureStorage();
  String? mnemonic;
  String? ethAddress;
  String? tronAddress;
  String? privateKey;

  bool showLoader = false;

  // Add your images, titles, and slogans here.
  List<String> images = [

    'assets/images/image1.png',
    'assets/images/image2.png',
    'assets/images/image3.png',
    'assets/images/wallet4.png',

  ];


  List<String> titles = [

    'Your Wallet, Your Control',
    'Secure and Private',
    'Real-Time Tracking',
    'Access Anywhere, Anytime',

  ];

  List<String> slogans = [

    'Own your digital assets with our fully decentralized wallet',
    'We prioritize your privacy - your keys, your coins',
    'Stay updated with real-time tracking of your digital assets',
    'Available on multiple platforms for access whenever you need it',

  ];


  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: Container(

        decoration: BoxDecoration(gradient:

        LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [


              Color.fromRGBO(50, 46, 91, 1.0),
              Color.fromRGBO(115, 105, 219, 1.0),
              Color.fromRGBO(50, 46, 91, 1.0),
              //Color.fromRGBO(113, 185, 117, 1.0),
              //Color.fromRGBO(78, 138, 71, 1.0),
              //Color.fromRGBO(40, 79, 37, 1.0),
              //Color.fromRGBO(24, 24, 24, 1.0)
            ]),

            //borderRadius: BorderRadius.circular(20)

        ),

        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: PageView.builder(
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            const SizedBox(height: 30),

                            Expanded(
                              child: Image.asset(
                                images[index],
                                fit: BoxFit.contain,
                              ),
                            ),

                            Text(
                              titles[index],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              slogans[index],
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 20),

                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                if(showLoader) const CircularProgressIndicator(),

                if(!showLoader)


                  Container(
                    width: 200,
                    decoration: BoxDecoration(gradient:

                    AppConfig.buttonGradient,borderRadius: BorderRadius.circular(20)

                    ),
                    child: ElevatedButton(
                      onPressed: (){

                        setState(() {
                          showLoader = true;
                        });

                        Future.delayed(const Duration(milliseconds: 400),() async {

                          final wallet = await walletService.createWallet();
                          final tempData = [
                            ['mnemonic', wallet.mnemonic],
                            ['ethAddress', wallet.ethAddress],
                            ['tronAddress', wallet.tronAddress],
                            ['privateKey', wallet.privateKey],
                          ];
                          final dataArrayString = json.encode(tempData);
                          await secureStorage.write('tempWallet', dataArrayString);

                          setState(() {
                            showLoader = false;
                          });

                          if(mounted){

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ViewMnemonics()),
                            );

                          }

                        });

                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                      child: Text('Create new wallet',style: TextStyle(color: AppConfig.titleIconAndTextColor),),
                    ),
                  ),



                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.restoreWallet);
                  },
                  child: Text(
                    'Already having a wallet',style: TextStyle(color: Colors.white),
                  ),
                ),

                SizedBox(height: 20,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

