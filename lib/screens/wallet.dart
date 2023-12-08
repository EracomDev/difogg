import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:difog/models/wallet.dart';
import '../utils/app_config.dart';
import 'app_layout.dart';
import '../services/wallet_data.dart';
import 'create_wallet_screen.dart';
import 'view_wallet.dart';

class CryptoWalletDashboard extends StatefulWidget {
  @override
  _CryptoWalletDashboardState createState() => _CryptoWalletDashboardState();
}

const List<Widget> Currency = <Widget>[
  Text('USD'),
  Text('DiFogg'),
];

class _CryptoWalletDashboardState extends State<CryptoWalletDashboard> {
  var size;
  DateTime? currentBackPressTime;
  final walletService = WalletService();
  final List<bool> _selectedCurrency = <bool>[true, false];

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return FutureBuilder<List<WalletData>>(
      future: walletService.getWallets(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppLayout(
            child: const SpinKitFadingFour(
              color: AppConfig.primaryColor,
              size: 50.0,
            ),
          );
        }
        //print(snapshot.data);
        if (snapshot.data == null ||
            snapshot.data!.isEmpty ||
            snapshot.data!.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: AppConfig.background,
                  title: const Text('No Wallet Found'),
                  content: const Text('Create a wallet now!'),
                  actions: [
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateWalletScreen()),
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
                child: const SpinKitFadingFour(
                  color: AppConfig.primaryColor,
                  size: 50.0,
                ),
              );
            }
            if (balanceSnapshot.hasError) {
              // print('Error fetching total balance: ${balanceSnapshot.error}');
              return const Text(' ');
            }
            final String totalBalance = balanceSnapshot.data ?? '0';
            return AppLayout(
              child: Scaffold(
                backgroundColor: AppConfig.myBackground,
                //appBar: Header(),
                body: Stack(
                  children: [
                    // Positioned(
                    //   right: -180,
                    //   top: 150,
                    //   child: Container(
                    //     height: size.width * .6,
                    //     width: size.width * .6,
                    //     // color: Colors.yellow,
                    //     decoration: BoxDecoration(
                    //       shape: BoxShape.circle,
                    //       color: const Color(0xFFFF7043).withOpacity(.08),
                    //       //border: Border.all(style: BorderStyle.solid,width: 2,color: MyColors.secondary.withOpacity(.6))
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: const Color.fromARGB(255, 0, 65, 90)
                    //               .withOpacity(1), // Shadow color
                    //           blurRadius: 1011.0, // Blur radius
                    //           spreadRadius: 100.0, // Spread radius
                    //           offset: const Offset(
                    //               5.0, 5.0), // Offset in the x and y direction
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Positioned(
                      left: MediaQuery.sizeOf(context).width * .5,
                      bottom: -110,
                      child: Container(
                        height: 1,
                        width: 1,
                        // color: Colors.yellow,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFF7043).withOpacity(.08),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 0, 65, 90)
                                  .withOpacity(1), // Shadow color
                              blurRadius: 1011.0, // Blur radius
                              spreadRadius: 150.0, // Spread radius
                              offset: const Offset(
                                  5.0, 5.0), // Offset in the x and y direction
                            ),
                          ],
                          //border: Border.all(style: BorderStyle.solid,width: 2,color: MyColors.primary.withOpacity(.6))
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.sizeOf(context).height,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.zero,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                           Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Total Balance",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                Text(
                                                  "\$ $totalBalance",
                                                 // "\$ 502,240.00",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 27,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              ]),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              const Text(
                                                "Currency",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey),
                                              ),
                                              ToggleButtons(
                                                borderColor:
                                                    AppConfig.primaryColor,
                                                onPressed: (int index) {
                                                  setState(() {
                                                    // The button that is tapped is set to true, and the others to false.
                                                    for (int i = 0;
                                                        i <
                                                            _selectedCurrency
                                                                .length;
                                                        i++) {
                                                      _selectedCurrency[i] =
                                                          i == index;
                                                    }
                                                  });
                                                },
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(8)),
                                                selectedBorderColor:
                                                    AppConfig.primaryColor,
                                                selectedColor: Colors.white,
                                                fillColor:
                                                    AppConfig.primaryColor,
                                                color: Colors.white,
                                                constraints:
                                                    const BoxConstraints(
                                                  minHeight: 25.0,
                                                  minWidth: 40.0,
                                                ),
                                                isSelected: _selectedCurrency,
                                                textStyle: const TextStyle(
                                                    fontSize: 10),
                                                children: Currency,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: const Text(
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
                                  children: wallets
                                      .map((wallet) => wallet.showWallet
                                          ? GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CryptoPage(
                                                      cryptoName:
                                                          wallet.cryptoName,
                                                      symbol: wallet.symbol,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: WalletData(
                                                cryptoName: wallet.cryptoName,
                                                symbol: wallet.symbol,
                                                icon: wallet.icon,
                                                price: wallet.price,
                                                change: wallet.change,
                                                balance: wallet.balance,
                                                isToken: wallet.isToken,
                                                onTap: () {},
                                              ),
                                            )
                                          : const SizedBox())
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
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
    return Container(
      //decoration: decoration,
      //margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Balance',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  balanceInUSD,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                /*image: new DecorationImage(
                  image: new AssetImage("assets/images/design4.png"),
                  fit: BoxFit.fill,
                ),*/
                borderRadius: BorderRadius.circular(16),

                border: Border.all(color: const Color(0xFF454A55), width: 1),
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
              child: const Text("USD"),
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
            )
          ],
        ),
      ),
    );
  }
}
