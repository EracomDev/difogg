import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:difog/screens/portfolio.dart';
import 'package:difog/screens/settings.dart';
import 'package:difog/utils/app_config.dart';

import '../widgets/complete_profile_popup.dart';
import '../widgets/success_or_failure_dialog.dart';
import 'browser.dart';
import 'create_wallet_screen.dart';
import 'dashboard_page.dart';
import 'edit_user_profile.dart';
import 'market_html.dart';
import 'wallet.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var size;

  int pageIndex = 0;
  String title = AppConfig.appName;
  Widget selectedWidget = Center(
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
                    SizedBox(
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



                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile()),
                        );*/
                      },
                    ),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
              ],
            ),
            bottomNavigationBar:

            Container(
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
                  /*BottomNavigationBarItem(
                icon: Icon(Icons.timeline_outlined),
                label: 'Market',
              ),*/
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_balance_outlined),
                    label: 'Portfolio',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  )
                ],
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 11,
                ),
                selectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 11,
                    color: const Color.fromARGB(255, 255, 255, 255)),
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

            /*Container(


        child:  Container(
          padding: const EdgeInsets.all(6),
          margin: EdgeInsets.all(6),
          decoration: BoxDecoration(

              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.grey.withOpacity(.08)

          ),
          child: GNav(

            //rippleColor: Colors.grey[300]!,
            //hoverColor: Colors.grey[100]!,
            //backgroundColor: Colors.grey,

              gap: 8,
              activeColor:  Color(0xFFFFFFFF),
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.transparent,
              tabBackgroundGradient: AppConfig.buttonGradient,

              color: Colors.grey[400],

              tabs: const [

                GButton(

                  icon: Icons.web,
                  text: 'Dashboard',

                ),

                GButton(

                  icon: Icons.wallet,
                  text: 'Wallet',

                ),

                GButton(
                  icon: Icons.trending_up,
                  text: 'PortFolio',
                ),

                GButton(
                  icon: CupertinoIcons.phone_circle,
                  text: 'Help',
                ),

              ],
              selectedIndex: pageIndex,
              onTabChange: _onItemTapped

          ),
        ),
      ),*/

            body: Stack(
              children: [
                /*Positioned(
          top: -150,
          left: -190,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
                boxShadow: const [


                  BoxShadow(
                    color: Color.fromRGBO(40, 36, 39, 1),
                    spreadRadius: 80, // Spread radius
                    blurRadius: 20, // Blur radius
                    offset: Offset(0, 0), // Offset from the image
                  ),


                ],
                color: const Color.fromARGB(255, 0, 0, 0),
                borderRadius: BorderRadius.circular(250)),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(44, 0, 120, 1.0),
                      spreadRadius: 20, // Spread radius
                      blurRadius: 250, // Blur radius
                      offset: Offset(0, 0), // Offset from the image
                    ),
                  ],
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(150)),
            ),
          ),
        ),
        Positioned(
          bottom: -250,
          right: -150,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(40, 36, 39, 1),
                    spreadRadius: 80, // Spread radius
                    blurRadius: 20, // Blur radius
                    offset: Offset(0, 0), // Offset from the image
                  ),
                ],
                color: Colors.black,
                borderRadius: BorderRadius.circular(250)),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(44, 0, 120, 1.0), // Shadow color
                      spreadRadius: 20, // Spread radius
                      blurRadius: 50, // Blur radius
                      offset: Offset(0, 0), // Offset from the image
                    ),
                  ],
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(150)),
            ),
          ),
        ),*/

                SafeArea(child: selectedWidget),
              ],
            )));
  }

  void _onItemTapped(int index) {
    setState(() {
      pageIndex = index;

      if (pageIndex == 0) {
        title = 'Dashboard';
        selectedWidget = DashboardPage();
      } else if (pageIndex == 1) {
        title = AppConfig.appName;

        selectedWidget = CryptoWalletDashboard();
      } else if (pageIndex == 2) {
        title = 'PortFolio';
        //selectedWidget = MarketHTML();
        selectedWidget = PortFolio();
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
  }

  initialData() {
    setState(() {
      title = 'Wallet';
      selectedWidget = DashboardPage();
    });
  }
}
