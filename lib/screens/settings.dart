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

    size = MediaQuery.of(context).size;
    return AppLayout(
      child:  Scaffold(

        body:

        Stack(
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

            Column(
              children: [

               // SizedBox(height: 10,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                  width: MediaQuery.of(context).size.width,
                  child: Text("Settings",style: TextStyle(fontSize: 20),),),

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
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: Icon(Icons.password),
                          title: Text(
                            'Reset Password',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ResetPasswordPage()),
                            );
                          },
                        ),
                      ),
                      ListTileTheme(
                        dense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: Icon(Icons.help_outline),
                          title: Text(
                            'FAQ',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FAQPage()),
                            );
                          },

                        ),
                      ),
                      ListTileTheme(
                        dense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: Icon(Icons.support_agent),
                          title: Text(
                            'Support',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            // Handle About logic
                          },
                        ),
                      ),
                      ListTileTheme(
                        dense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: Icon(Icons.info_outline),
                          title: Text(
                            'About',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AboutPage()),
                            );
                          },
                        ),
                      ),

                      Divider(),

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
    );
  }

  Widget helpCenterItem(String platform, String iconPath, String link) {
    return ListTile(
      leading: SvgPicture.asset(
        iconPath,
        width: 30,
        height: 30,
      ),
      title: Text(platform),
      onTap: () {
        // Navigate to the respective help center support page
        // You can define your navigation logic here
      },
    );
  }
}

