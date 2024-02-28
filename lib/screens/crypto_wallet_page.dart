import 'package:difog/screens/view_wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/wallet.dart';
import '../services/wallet_data.dart';
import '../utils/app_config.dart';
import 'create_wallet_screen.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

const List<Widget> Currency = <Widget>[
  Text('USD'),
  Text('DiFogg'),
];

class _WalletPageState extends State<WalletPage> {
  final walletService = WalletService();
  String change = "0";
  String totalBalance = "0";

  List<WalletData> walletData = [];

  bool isLoading = true;

  final List<bool> _selectedCurrency = <bool>[true, false];
  String mainWalletToShow = "0";
  String currencySign = "\$";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.background,
      body: Container(
        child: Stack(
          children: [
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
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Total Balance",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              mainWalletToShow,
                                              //"\$ 502,240.00",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 27,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              currencySign,
                                              style:
                                                  const TextStyle(fontSize: 11),
                                            )
                                          ],
                                        )
                                      ]),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text(
                                        "Currency",
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.grey),
                                      ),
                                      ToggleButtons(
                                        borderColor: AppConfig.primaryColor,
                                        onPressed: (int index) {
                                          setState(() {
                                            // The button that is tapped is set to true, and the others to false.
                                            for (int i = 0;
                                                i < _selectedCurrency.length;
                                                i++) {
                                              _selectedCurrency[i] = i == index;
                                            }

                                            if (index == 0) {
                                              mainWalletToShow = totalBalance;
                                              currencySign = "\$";
                                            } else {
                                              mainWalletToShow = (double.parse(
                                                          totalBalance) /
                                                      double.parse(
                                                          AppConfig.tokenRate))
                                                  .toStringAsFixed(2);
                                              currencySign = "Difogg";
                                            }

                                            print(index);
                                          });
                                        },
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                        selectedBorderColor:
                                            AppConfig.primaryColor,
                                        selectedColor: Colors.white,
                                        fillColor: AppConfig.primaryColor,
                                        color: Colors.white,
                                        constraints: const BoxConstraints(
                                          minHeight: 25.0,
                                          minWidth: 40.0,
                                        ),
                                        isSelected: _selectedCurrency,
                                        textStyle:
                                            const TextStyle(fontSize: 10),
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
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: const Text(
                          'My Portfolio',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 280,
                        child: ListView(
                          //physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: walletData
                              .map((wallet) => wallet.showWallet
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CryptoPage(
                                              cryptoName: wallet.cryptoName,
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
                                        change: wallet.symbol == "DFOG"
                                            ? "$change%"
                                            : wallet.change,
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
            if (isLoading)
              Center(
                child: Container(
                  height: 40,
                  width: 40,
                  child: const SpinKitFadingFour(
                    color: AppConfig.primaryColor,
                    size: 50.0,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    dayGraphAPI();
    fetchData();
    super.initState();
  }

  Future<void> dayGraphAPI() async {
    final response =
        await http.get(Uri.parse('https://difogg.com/jhg7q/user/day_price'));
    if (response.statusCode == 200) {
      final res = await jsonDecode(response.body);
      setState(() {
        change = double.parse(res[0]['price']['priceChangePercent'].toString())
            .toStringAsFixed(2);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  fetchData() async {
    walletService.getWallets(context).then((value) {
      walletData.addAll(value);

      walletService.WallatTotalBalance().then((value) {
        setState(() {
          isLoading = false;
          mainWalletToShow = value;
          totalBalance = value;
        });
      });

      if (walletData.isEmpty) {
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
                  MaterialPageRoute(builder: (context) => CreateWalletScreen()),
                );
              },
            ),
          ],
        );
      }
    });

    //walletData.addAll(;)
  }
}
