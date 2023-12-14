import 'package:difog/screens/my_profile.dart';
import 'package:difog/screens/phrases_secret_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:difog/screens/password_reset.dart';
import 'package:difog/screens/wallet_list.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/app_layout.dart';
import '../utils/app_config.dart';
import 'about.dart';
import 'faq.dart';

class HelpCenter extends StatelessWidget {
  var size;
  @override
  Widget build(BuildContext context) {
    const TextStyle settingText = TextStyle(
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
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppConfig.primaryColor.withOpacity(.20),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.lock_outline,
                                  color: AppConfig.primaryText,
                                ),
                              ),
                            ),
                            trailing: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey.withOpacity(.20),
                              ),
                              child: const Center(
                                  child: Icon(
                                Icons.chevron_right,
                                color: Colors.grey,
                              )),
                            ),
                            title: const Text('Reset Password',
                                style: settingText),
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
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.purple.withOpacity(.3),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            trailing: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey.withOpacity(.20),
                              ),
                              child: const Center(
                                  child: Icon(
                                Icons.chevron_right,
                                color: Colors.grey,
                              )),
                            ),
                            title: const Text('My Profile', style: settingText),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyProfile()),
                              );
                            },
                          ),
                        ),

                        ListTileTheme(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.orange.withOpacity(.3),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.lock_outline,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                            trailing: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey.withOpacity(.20),
                              ),
                              child: const Center(
                                  child: Icon(
                                Icons.chevron_right,
                                color: Colors.grey,
                              )),
                            ),
                            title: const Text('Secret Phrases',
                                style: settingText),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PhrasesAndSecret()),
                              );
                            },
                          ),
                        ),

                        ListTileTheme(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.yellow.withOpacity(.20),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.help_outline,
                                  color: Colors.yellow,
                                ),
                              ),
                            ),
                            trailing: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey.withOpacity(.20),
                              ),
                              child: const Center(
                                  child: Icon(
                                Icons.chevron_right,
                                color: Colors.grey,
                              )),
                            ),
                            title: const Text('FAQ', style: settingText),
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
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.green.withOpacity(.20),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.support_agent,
                                  color: Color.fromARGB(255, 22, 255, 80),
                                ),
                              ),
                            ),
                            trailing: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey.withOpacity(.20),
                              ),
                              child: const Center(
                                  child: Icon(
                                Icons.chevron_right,
                                color: Colors.grey,
                              )),
                            ),
                            title: const Text('Support', style: settingText),
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
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey.withOpacity(.20),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.info_outline,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            trailing: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey.withOpacity(.20),
                              ),
                              child: const Center(
                                  child: Icon(
                                Icons.chevron_right,
                                color: Colors.grey,
                              )),
                            ),
                            title: const Text('About', style: settingText),
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
                          thickness: 0.2,
                        ),
                        // helpCenterItem(
                        //   'Twitter',
                        //   'assets/images/twitter.png',
                        //   'twitter_help_center.html',
                        // ),
                        helpCenterItem(
                          'Telegram',
                          'assets/images/telegram.png',
                          'https://t.me/DiFoggOfficial',
                        ),
                        // helpCenterItem(
                        //   'Facebook',
                        //   'assets/images/facebook.png',
                        //   'facebook_help_center.html',
                        // ),
                        // helpCenterItem(
                        //   'Reddit',
                        //   'assets/images/reddit.png',
                        //   'reddit_help_center.html',
                        // ),
                        // helpCenterItem(
                        //   'YouTube',
                        //   'assets/images/youtube.png',
                        //   'youtube_help_center.html',
                        // ),
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

  Widget helpCenterItem(String platform, String imagePath, String link) {
    return ListTile(
      leading: Image.asset(
        imagePath,
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
      onTap: () async {
        try {
          final Uri url = Uri.parse(link);
          if (!await launchUrl(url)) {
            throw Exception('Could not launch $url');
          }
        } catch (e) {
          print(e);
        }
      },
    );
  }

  void openTelegramLink(link) async {
    try {
      final Uri url = Uri.parse('https://flutter.dev');
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      print(e);
    }
  }
}
