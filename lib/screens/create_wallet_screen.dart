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
    'assets/images/wallet1.png',
    'assets/images/wallet2.png',
    'assets/images/wallet3.png',
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
                        children: [
                          Expanded(
                            child: Image.asset(
                              images[index],
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            titles[index],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            slogans[index],
                            textAlign: TextAlign.center,
                          ),
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

                      Future.delayed(const Duration(milliseconds: 400),() async{

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
                child: const Text(
                  'I already have a wallet',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

