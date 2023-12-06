import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:difog/screens/password_reset.dart';
import 'package:difog/screens/wallet_list.dart';

import '../screens/app_layout.dart';
import '../utils/app_config.dart';
import 'about.dart';
import 'faq.dart';

class HelpCenter extends StatelessWidget {
  var size;
  @override
  Widget build(BuildContext context) {
    final TextStyle settingText = const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );
    size = MediaQuery.of(context).size;
    return AppLayout(
      child: Scaffold(
        body: Container(
          color: AppConfig.myBackground,
          height: MediaQuery.sizeOf(context).height,
          child: Stack(
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
              Column(
                children: [
                  // SizedBox(height: 10,),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    child: const Text(
                      "Settings",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),

                  Expanded(
                    child: ListView(
                      children: [
                        /*ListTileTheme(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            leading: Icon(Icons.wallet),
                            title: Text(
                              'My Wallets',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => WalletList()),
                              );
                            },
                          ),
                        ),*/
                        ListTileTheme(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: ListTile(
                            leading: const Icon(Icons.lock_outline),
                            trailing: const Icon(Icons.chevron_right),
                            title: Text('Reset Password', style: settingText),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResetPasswordPage()),
                              );
                            },
                          ),
                        ),
                        ListTileTheme(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: ListTile(
                            leading: const Icon(Icons.help_outline),
                            trailing: const Icon(Icons.chevron_right),
                            title: Text('FAQ', style: settingText),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FAQPage()),
                              );
                            },
                          ),
                        ),
                        ListTileTheme(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: ListTile(
                            leading: const Icon(Icons.support_agent),
                            trailing: const Icon(Icons.chevron_right),
                            title: Text('Support', style: settingText),
                            onTap: () {
                              // Handle About logic
                            },
                          ),
                        ),
                        ListTileTheme(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: ListTile(
                            leading: const Icon(Icons.info_outline),
                            trailing: const Icon(Icons.chevron_right),
                            title: Text('About', style: settingText),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AboutPage()),
                              );
                            },
                          ),
                        ),
                        const Divider(
                          color: AppConfig.primaryColor,
                          thickness: 0.3,
                        ),
                        helpCenterItem(
                          'Twitter',
                          'assets/icons/twitter.svg',
                          'twitter_help_center.html',
                        ),
                        helpCenterItem(
                          'Telegram',
                          'assets/icons/telegram.svg',
                          'telegram_help_center.html',
                        ),
                        helpCenterItem(
                          'Facebook',
                          'assets/icons/facebook.svg',
                          'facebook_help_center.html',
                        ),
                        helpCenterItem(
                          'Reddit',
                          'assets/icons/reddit.svg',
                          'reddit_help_center.html',
                        ),
                        helpCenterItem(
                          'YouTube',
                          'assets/icons/youtube.svg',
                          'youtube_help_center.html',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget helpCenterItem(String platform, String iconPath, String link) {
    return ListTile(
      leading: SvgPicture.asset(
        iconPath,
        width: 30,
        height: 30,
      ),
      title: Text(
        platform,
        style: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
      ),
      onTap: () {
        // Navigate to the respective help center support page
        // You can define your navigation logic here
      },
    );
  }
}
