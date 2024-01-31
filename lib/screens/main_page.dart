// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:difog/screens/invite_friends.dart';
import 'package:flutter/material.dart';
import 'package:difog/screens/portfolio.dart';
import 'package:difog/screens/settings.dart';
import 'package:difog/utils/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'crypto_wallet_page.dart';
import 'dashboard_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var size;

  int pageIndex = 0;
  String title = AppConfig.appName;
  Widget selectedWidget = const Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          color: AppConfig.primaryColor,
        ),
        SizedBox(
          height: 10,
        ),
        Text("Please wait..."),
      ],
    ),
  );

  DateTime? currentBackPressTime;

  Future<bool> _onWillPop() async {
    if (pageIndex != 0) {
      _onItemTapped(0);
      return false;
    } else {
      final DateTime now = DateTime.now();
      final difference = currentBackPressTime == null
          ? null
          : now.difference(currentBackPressTime!);
      currentBackPressTime = now;

      if (difference != null && difference <= const Duration(seconds: 2)) {
        // Allow app exit
        exit(0);
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Press back again to exit')),
        );
        return false; // Prevent app exit
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: AppConfig.titleIconAndTextColor, //change your color here
              ),
              //backgroundColor: AppConfig.titleBarColor,
              backgroundColor: AppConfig.myBackground,

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
                    Image.asset(
                      AppConfig.appLogo,
                      width: 90,
                      height: 40,
                    ),
                    const SizedBox(
                      width: 16,
                    ),

                    /*Text("${title}",
                style: TextStyle(
                  //fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppConfig.titleIconAndTextColor,
                ),
              ),*/
                  ],
                ),
              ),
              actions: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        String username =
                            prefs.getString("username").toString();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  InviteFriendPage(userId: username)),
                        );
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                ),
              ],
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppConfig.myBackground,
                // border: Border(
                //   top: BorderSide(
                //       color: Color.fromARGB(255, 255, 255, 255), width: 1.0),
                // ),
                // gradient: AppConfig.containerGradientNew,
              ),
              child: BottomNavigationBar(
                unselectedItemColor: const Color.fromARGB(255, 138, 136, 136),
                currentIndex: pageIndex,
                type: BottomNavigationBarType.fixed,
                backgroundColor: AppConfig.myBackground,
                iconSize: 25,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard_outlined),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.wallet,
                    ),
                    label: 'Wallet',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_balance_outlined),
                    label: 'Portfolio',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  )
                ],
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 11,
                ),
                selectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 11,
                    color: Color.fromARGB(255, 255, 255, 255)),
                selectedItemColor: Colors.white,
                selectedIconTheme: const IconThemeData(
                  size: 25,
                  color: Colors.white,
                ),
                onTap: (index) {
                  _onItemTapped(index);
                },
              ),
            ),
            body: Stack(
              children: [
                SafeArea(child: selectedWidget),
              ],
            )));
  }

  void _onItemTapped(int index) {
    setState(() {
      pageIndex = index;

      if (pageIndex == 0) {
        title = 'Dashboard';
        selectedWidget = const DashboardPage();
      } else if (pageIndex == 1) {
        title = AppConfig.appName;

        selectedWidget = const WalletPage(); //CryptoWalletDashboard();
      } else if (pageIndex == 2) {
        title = 'PortFolio';
        //selectedWidget = MarketHTML();
        selectedWidget = const PortFolio();
        print("accountProfile");
      } else if (pageIndex == 3) {
        title = 'Help';
        selectedWidget = HelpCenter();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    initialData();
    super.initState();
    _checkIfShowDialog();
  }

  initialData() {
    setState(() {
      title = 'Wallet';
      selectedWidget = const DashboardPage();
    });
  }

  Future<void> _checkIfShowDialog() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('showPop', true);
  }
}
