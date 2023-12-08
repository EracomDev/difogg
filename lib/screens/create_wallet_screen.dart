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
import 'package:lottie/lottie.dart';

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
    'assets/images/anim2.json',
    'assets/images/anim5.json',
    'assets/images/anim6.json',
    'assets/images/anim4.json',
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                // Color.fromRGBO(50, 46, 91, 1.0),
                // Color.fromRGBO(115, 105, 219, 1.0),
                // Color.fromRGBO(50, 46, 91, 1.0),

                AppConfig.myBackground,
                AppConfig.myBackground,
                AppConfig.myBackground,
              ]),

          //borderRadius: BorderRadius.circular(20)
        ),
        child: Scaffold(
          body: Center(
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  bottom: -50,
                  child: Container(
                    height: 1,
                    width: 1,
                    // color: Colors.yellow,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppConfig.primaryColor
                              .withOpacity(.30), // Shadow color
                          blurRadius: 1011.0, // Blur radius
                          spreadRadius: 250.0, // Spread radius
                          offset: const Offset(
                              5.0, 5.0), // Offset in the x and y direction
                        ),
                      ],
                      //border: Border.all(style: BorderStyle.solid,width: 2,color: MyColors.primary.withOpacity(.6))
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: -50,
                  child: Container(
                    height: 1,
                    width: 1,
                    // color: Colors.yellow,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppConfig.primaryColor
                              .withOpacity(.30), // Shadow color
                          blurRadius: 1011.0, // Blur radius
                          spreadRadius: 250.0, // Spread radius
                          offset: const Offset(
                              5.0, 5.0), // Offset in the x and y direction
                        ),
                      ],
                      //border: Border.all(style: BorderStyle.solid,width: 2,color: MyColors.primary.withOpacity(.6))
                    ),
                  ),
                ),
                Column(
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
                                // Expanded(
                                //   child: Image.asset(
                                //     images[index],
                                //     fit: BoxFit.contain,
                                //   ),
                                // ),
                                Expanded(
                                  child: Lottie.asset(images[index],
                                      fit: BoxFit.contain),
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
                    if (showLoader) const CircularProgressIndicator(),
                    if (!showLoader)
                      Container(
                        width: 200,
                        decoration: BoxDecoration(
                            // gradient: AppConfig.buttonGradient,
                            borderRadius: BorderRadius.circular(20)),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showLoader = true;
                            });

                            Future.delayed(const Duration(milliseconds: 400),
                                () async {
                              final wallet = await walletService.createWallet();
                              final tempData = [
                                ['mnemonic', wallet.mnemonic],
                                ['ethAddress', wallet.ethAddress],
                                ['tronAddress', wallet.tronAddress],
                                ['privateKey', wallet.privateKey],
                              ];
                              final dataArrayString = json.encode(tempData);
                              await secureStorage.write(
                                  'tempWallet', dataArrayString);

                              setState(() {
                                showLoader = false;
                              });

                              if (mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewMnemonics()),
                                );
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(15),
                              backgroundColor: AppConfig.primaryColor),
                          child: Text(
                            'Create new wallet',
                            style: TextStyle(
                                color: AppConfig.titleIconAndTextColor),
                          ),
                        ),
                      ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.restoreWallet);
                      },
                      child: const Text(
                        'Already having a wallet',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
