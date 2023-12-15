import 'package:difog/utils/app_config.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/success_or_failure_dialog.dart';

class InviteFriendPage extends StatefulWidget {
  String userId;
  InviteFriendPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<InviteFriendPage> createState() => _InviteFriendPageState();
}

class _InviteFriendPageState extends State<InviteFriendPage> {
  late var size;

  String walletId = "";
  String linkUrl = "";
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppConfig.background,
      appBar: AppBar(

        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppConfig.background,
        title: const Text(
          "Invite Friends",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.normal,color: Colors.white),
        ),
        titleSpacing: 0,
        elevation: 0,
        //automaticallyImplyLeading: false,
        //brightness: Brightness.light,
        //brightness: Brightness.light,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                color: AppConfig.background,
                height: 200,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    elevation: 0,
                    color: AppConfig.primaryColor.withOpacity(.4),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      constraints: BoxConstraints(
                          minWidth: size.width * .7,
                          maxWidth: size.width * .90),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(

                        // color: Colors.white.withOpacity(.2),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(20)),
                        //border: Border.all(color: MyColors.textColor, width: 2)

                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "My Referral Id : ",
                                style: TextStyle(
                                     fontSize: 16),
                              ),

                              SizedBox(height: 4,),
                              
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.withOpacity(.2),
                                ),
                                
                                child: Row(
                                  children: [

                                    Text(
                                      widget.userId,
                                      style: const TextStyle(
                                         fontSize: 16),
                                    ),

                                    Spacer(),

                                    InkWell(child: Icon(Icons.copy,color: Colors.white,),onTap: (){

                                      Clipboard.setData(
                                          ClipboardData(text: widget.userId.toString()));

                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const AlertDialogBox(
                                                type: "success",
                                                title: "Success Alert",
                                                desc: 'Referral Id copied successfully');
                                          });

                                    },)
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 10,),


                          Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "My Referral Link : ",
                                style: TextStyle(
                                    fontSize: 16),
                              ),

                              SizedBox(height: 4,),

                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey.withOpacity(.2),
                                ),

                                child: Row(
                                  children: [

                                    Text(
                                      linkUrl,
                                      style: const TextStyle(
                                          fontSize: 16),
                                    ),

                                    Spacer(),

                                    InkWell(child: Icon(Icons.copy,color: Colors.white,),onTap: (){

                                      Clipboard.setData(
                                          ClipboardData(text: linkUrl.toString()));

                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const AlertDialogBox(
                                                type: "success",
                                                title: "Success Alert",
                                                desc: 'Referral link copied successfully');
                                          });

                                    },)
                                  ],
                                ),
                              ),
                            ],
                          ),


                          const SizedBox(
                            height: 20,
                          ),
                          /*Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppConfig.primaryColor.withOpacity(.5)),
                                color: Colors.grey.withOpacity(.2)),
                            child: QrImageView(

                              //data: "IDsdfsdghbvghgtyhbgsdt4gfgsdfg......",
                              //data: "https://apk.aavelend.eu/index?ref="+walletId,
                                data: linkUrl,
                                version: QrVersions.auto,
                                foregroundColor: Colors.white.withOpacity(.9),
                                // bgColorColor: MyColors.primary.withOpacity(.5),
                                size: 200.0,
                                gapless: true,
                                eyeStyle: const QrEyeStyle(
                                  eyeShape: QrEyeShape.circle,
                                  color: Colors.white,
                                ),
                                dataModuleStyle: const QrDataModuleStyle(
                                  dataModuleShape: QrDataModuleShape.circle,
                                  color: Colors.white,
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Use the scanner to bind the invitation relationship.",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),*/
                          const SizedBox(
                            height: 10,
                          ),

                          InkWell(
                            child: Container(
                              constraints:
                              BoxConstraints(minWidth: size.width * .3),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              decoration: BoxDecoration(
                                  color: AppConfig.primaryColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Text(
                                "Share Link",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onTap: () async {
                              final RenderBox box =
                              context.findRenderObject() as RenderBox;
                              String shareText =
                                  "Hi, Use ${AppConfig.appName} to refer your friends for Referral benefits. \n So don't delay. Join ${AppConfig.appName} today Here is the link: $linkUrl";

                              //final bytes = await rootBundle.load('assets/images/footer_banner.png');
                              // final tempDir = await getTemporaryDirectory();
                              // final file = await File('${tempDir.path}/image.jpg').create();
                              // file.writeAsBytesSync(list);

                              //var url = 'https://i.ytimg.com/vi/fq4N0hgOWzU/maxresdefault.jpg';
                              //      var response = await get(Uri.parse(bottomBanner));
                              // final documentDirectory = (await getExternalStorageDirectory())!.path;
                              // File imgFile = new File('$documentDirectory/flutter.png');
                              // imgFile.writeAsBytesSync(response.bodyBytes);
                              //final list = bytes.buffer.asUint8List();

                              // Share.shareFiles(['$documentDirectory/flutter.png'], text: '$shareText',subject: "Referral Link",);

                              await Share.share(shareText,
                                  subject: "Referral Link",
                                  sharePositionOrigin:
                                  box.localToGlobal(Offset.zero) &
                                  box.size);
                            },
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        " Share this code ${widget.userId} with your friends and earn DiFogg token.",
                        style: TextStyle(fontSize: 14),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState

    fetchPref();
    super.initState();
  }

  fetchPref() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();


    showDialog(
        barrierDismissible: false,
        barrierColor: const Color(0x56030303),
        context: context,
        builder: (_) => const Material(
          type: MaterialType.transparency,
          child: Center(
            // Aligns the container to center
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Please wait....",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ));


    String dynamicLink = 'https://difogg.com/?referral_id=${widget.userId}';

    //https://app.adrino.org/?referral_id=683510
    //https://app.adrino.org/?referral_id=683510


    if(kIsWeb){

      //print("username="+username);
      setState(() {
        linkUrl =  "${dynamicLink}";
      });

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

    }else {
      FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;



      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://difogg.page.link',
        link: Uri.parse(dynamicLink),
        androidParameters: AndroidParameters(
          packageName: 'com.app.difogg',
          minimumVersion: 0,
          fallbackUrl: Uri.parse(dynamicLink),
        ),
        iosParameters: const IOSParameters(
          bundleId: 'io.invertase.testing',
          minimumVersion: '0',
        ),
      );

      Uri url;
      if (true) {
        final ShortDynamicLink shortLink =
        await dynamicLinks.buildShortLink(parameters);
        url = shortLink.shortUrl;
      }

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      setState(() {
        linkUrl = url.toString();
      });
    }

    print(linkUrl);
  }
}
