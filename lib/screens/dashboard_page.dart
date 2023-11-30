import 'dart:convert';
import 'dart:developer';

import 'package:difog/utils/card_design_new.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:difog/screens/packages.dart';
import 'package:difog/screens/support.dart';
import 'package:difog/screens/transaction.dart';
import 'package:difog/screens/withdraw_page.dart';
import 'package:difog/services/api_data.dart';
import 'package:difog/utils/app_config.dart';
import 'package:difog/widgets/slider.dart';

import '../models/home_menu.dart';
import '../utils/page_slider.dart';
import '../widgets/my_chart.dart';
import 'fund_transfer.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  String u_id = "";
  String packageAmount = "0";
  String capping = "0";
  String earning = "0";
  String mainWallet = "0";
  var size;

  final List<HomeMenu> rechargeMenus = [
    /*HomeMenu(
      image: Image.asset(
        "assets/images/1.png",
        height: 24,
        width: 24,


      ),
      name: 'Deposit',
    ),*/
    HomeMenu(
      image: Image.asset(
        "assets/images/package.png",
        height: 24,
        width: 24,

      ),
      name: 'My Packages',
    ),
   /* HomeMenu(
      image: Image.asset(
        "assets/images/loan.png",
        height: 24,
        width: 24,

      ),
      // image: "assets/images/ic_addmoney.png",
      name: 'Add Fund',
    ),
    HomeMenu(
      image: Image.asset(
        "assets/images/money-transfer.png",
        height: 24,
        width: 24,

      ),
      // image: "assets/images/ic_addmoney.png",
      name: 'Transfer',
    ),*/
    HomeMenu(
      image: Image.asset(
        "assets/images/2.png",
        height: 24,
        width: 24,

      ),
      // image: "assets/images/ic_addmoney.png",
      name: 'Support',
    ), HomeMenu(
      image: Image.asset(
        "assets/images/6.png",
        height: 24,
        width: 24,

      ),
      // image: "assets/images/ic_addmoney.png",
      name: 'Withdraw',
    ),/*HomeMenu(
      image: Image.asset(
        "assets/images/convert.png",
        height: 24,
        width: 24,

      ),
      // image: "assets/images/ic_addmoney.png",
      name: 'Convert',
    ),*/HomeMenu(
      image: Image.asset(
        "assets/images/money-bag.png",
        height: 24,
        width: 24,

      ),
      // image: "assets/images/ic_addmoney.png",
      name: 'Payments',
    ),

  ];


  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;

    final TextStyle btnTextStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: const Color.fromARGB(255, 255, 255, 255),
    );
    const double iconWidth = 30;
    return Scaffold(


      body: Stack(
        children: [
          /*Positioned(
            left: -100,
            top: -40,

            child: Container(
              height: size.width*.75,
              width: size.width*.65,
              // color: Colors.yellow,
              decoration: BoxDecoration(
                shape: BoxShape.circle, color: AppConfig.primaryColor.withOpacity(.06),

                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(75, 75, 75, 1.0),
                    spreadRadius: 150, // Spread radius
                    blurRadius: 250, // Blur radius
                    offset: Offset(0, 0), // Offset from the image
                  ),
                ],
                //border: Border.all(style: BorderStyle.solid,width: 2,color: MyColors.primary.withOpacity(.6))
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
                shape: BoxShape.circle, color: AppConfig.primaryColor.withOpacity(.03),
                //border: Border.all(style: BorderStyle.solid,width: 2,color: MyColors.primary.withOpacity(.6))
              ),


            ),
          ),

          */

          Positioned(
            right: -80,
            top: 150,

            child: Container(
              height: size.width*.6,
              width: size.width*.6,
              // color: Colors.yellow,
              decoration: BoxDecoration(
                shape: BoxShape.circle, color:   Color(0xFFFF7043).withOpacity(.08)
                //border: Border.all(style: BorderStyle.solid,width: 2,color: MyColors.secondary.withOpacity(.6))
                ,

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

                shape: BoxShape.circle, color:  Color(0xFFFF7043).withOpacity(.08),
                //border: Border.all(style: BorderStyle.solid,width: 2,color: MyColors.primary.withOpacity(.6))
              ),


            ),
          ),


          Container(

            height: MediaQuery.of(context).size.height,

            child:

          SingleChildScrollView(
            child: Container(
              child: Stack(

                children: [

                  Column(children: [


                    Container(


                      /* decoration: BoxDecoration(


                          color:  MyColors.cardBackgroundHome,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          //boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3),blurRadius: 1,offset: Offset(1, 1))]
                        ),*/


                        //padding: EdgeInsets.only(left: 8,right: 8,top: 8),
                        //margin: EdgeInsets.symmetric(horizontal: 16),


                        child:Wrap(
                          children: [

                            GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,


                            crossAxisCount: 4,
                            //childAspectRatio: 1.33,

                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0,
                            children:rechargeMenus
                                .map(_rechargeHomeMenu)
                                .toList(),
                          ),]
                        )

                    ),


                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: MySlider()),
                    SizedBox(height: 20,),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [


                          Expanded(
                            flex: 1,
                            child:
                            designNewCard( Row(
                              children: [
                                Image.asset("assets/images/wallet.png", width: 30),
                                const SizedBox(width: 16),


                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Container(
                                      constraints: BoxConstraints(maxWidth: size.width*.32),
                                      child: Text(
                                        "Main Wallet",
                                        style: TextStyle(color:  Colors.white.withOpacity(.5),fontSize: 14,fontWeight: FontWeight.w300),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      "\$ $mainWallet",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )
                                  ],
                                )
                              ],
                            ),)

                          ),


                        ],
                      ),
                    ),

                    SizedBox(height: 16,),

                    Container(

                        width: double.infinity,

                        margin: EdgeInsets.symmetric(horizontal: 16),


                        child: Column(children: [
                          designNewCard(
                              MyChart(
                            amount:
                            "$packageAmount",
                            income:double.parse(capping) ??
                                0.0, // Use a default value if it's null
                            getIncome: double.parse(earning)??0.0,
                            // Use a default value if it's null
                          ))

                        ],)

                    ),

                    const SizedBox(height: 10),


                  ],),
                ],
              ),
            ),
          ),),
        ],
      ),
    );
  }

  Widget _rechargeHomeMenu(HomeMenu e) {
    return Container(

        child: InkWell(

          onTap: () {
            print("TapClicked");



            if(e.name=="My Packages"){


              Navigator.push(
                context,
                SlidePageRoute(
                  page: const Packages(),
                ),
              );
            } else  if(e.name=="Transfer"){


              Navigator.push(
                context,
                SlidePageRoute(
                  page: const FundTransfer(),
                ),
              );
            }else if(e.name=="Support"){


              Navigator.push(
                context,
                SlidePageRoute(
                  page: const Support(),
                ),
              );
            }else if(e.name=="Withdraw"){


              Navigator.push(
                context,
                SlidePageRoute(
                  page: Withdraw(main_wallet:mainWallet),
                ),
              );
            }else if(e.name=="Payments"){


              Navigator.push(
                context,
                SlidePageRoute(
                  page: Transaction(type: "all",title: "All",),
                ),
              );


            }
            //Navigator.pushNamed(context, MyRoots.productDetail);
          }, // Handle your callback
          child: Container(
            //margin:EdgeInsets.symmetric(horizontal: 8,vertical: 8,),
            padding: EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 4,
            ),
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                Container(child: e.image,

                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(

                    color:  Colors.grey.withOpacity(.2),
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    //boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3),blurRadius: 1,offset: Offset(1, 1))]
                  ),),

                // e.image,

                SizedBox(
                  height: 4,
                ),

                Text(
                  e.name,
                  style: TextStyle(color: Colors.white,fontSize:  size.width*.03,fontWeight: FontWeight.w300),
                ),

              ],
            ),
          ),
        )
      //padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
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

    String userId = prefs.get('u_id').toString();


    hitApi(userId);


  }

  hitApi(id){
    print("response=");
    //_makePayment();

    //_activePackage(id);



    showDialog(
        barrierDismissible: false,
        barrierColor:const  Color(0x56030303),
        context: context!,
        builder: (_) =>  Material(
          type: MaterialType.transparency,
          child: Center(
            // Aligns the container to center
            child:Column(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[

                CircularProgressIndicator(),
                SizedBox(height: 20,),
                Text("Please wait....",style: TextStyle(color: Colors.white),),

              ],
            ),
          ),
        ));

    callApi(id);


  }

  callApi(id) async {


    var requestBody = jsonEncode({

      "u_id":id,


    });

    print(requestBody);


    print("u_id="+id);

    Map<String, String> headersnew = {

      "Content-Type":"application/json; charset=utf-8",
      "xyz":"",

      //"Authorization":"gGpjrL14ksvhIUTnj2Y2xdjoe623YWbKGbWSSe0ewD0gLtFjRqvpPaxDa2JVaFeBRz5U89Eq5VCCZmGdsl7sZc2lyNclvurR4vmtec67IjL6R2e75DT9cuuXZrjNP1frCZ1pCUeAHSemYiSuDSN29ptwJKCmeFF7uUHS5CxJB3Ee1waEWvvtHFxFvoDa0HGMvt5YxLZFmiPWpWv6MANggsaNOnx9PAjTSsZtjLP2DCjgH2bHtBVJOGPz7prtvJpx"

    };

    // print(rootPathMain+apiPathMain+ApiData.preRequest);

    var response = await post(Uri.parse(ApiData.dashboard),
        headers: headersnew,
        body: requestBody);

    String body = response.body;
    print("response=1111${response.statusCode}");
    if(response.statusCode==200){
      print("response=${response.body}");
      Map<String, dynamic> json = jsonDecode(response.body.toString());
      log("json=$body");
      if(Navigator.canPop(context!)){

        Navigator.pop(context!);

      }
      fetchSuccess(json);
    } else {

      if(Navigator.canPop(context!)){
        Navigator.pop(context!);
      }


      ScaffoldMessenger.of(context!).showSnackBar(const SnackBar(
        content: Text('Oops! Something went wrong!'),
      ));
    }

  }

  Future<void> fetchSuccess(Map<String, dynamic> json) async {


    try{

      if(json['res']=="success"){

        packageAmount=json["package"].toString();
        capping=json["capping"].toString();
        earning=json["pkg_earning"].toString();
        mainWallet=json["wallets"]["main_wallet"].toString();

        setState(() {
          packageAmount;
        });

        //{"total_directs":"0","active_directs":"0","inactive_directs":"0","total_gen":"0"}


      } else {


        String message = json['message'].toString();

        ScaffoldMessenger.of(context!).showSnackBar(SnackBar(

          content: Text(message),

        ));

      }


    } catch(e){

      print(e.toString());

    }


  }


}
