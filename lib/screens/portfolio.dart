import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:difog/utils/app_config.dart';

import '../components/incomes.dart';
import '../services/api_data.dart';
import '../utils/card_design_new.dart';

class PortFolio extends StatefulWidget {
  const PortFolio({super.key});

  @override
  State<PortFolio> createState() => _PortFolioState();
}

class _PortFolioState extends State<PortFolio> {
  var size;

  Map<String, dynamic> jsonData={};

  final TextStyle heading = TextStyle(
      color: AppConfig.titleIconAndTextColor,
      fontSize: 16,
      fontWeight: FontWeight.w500);
  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;
    return Scaffold(
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


          Container(child:

          SingleChildScrollView(child:

          Container(

            padding: EdgeInsets.symmetric(horizontal: 16),

            child: Column(children: [
              SizedBox(height: 10,),
              SizedBox(
                width: size.width,
                child: Text(
                  "Wallets",
                  style: heading,
                  textAlign: TextAlign.start,
                ),
              ),

              SizedBox(height: 4,),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child:

                        designNewCard( Container(
                          /*decoration: BoxDecoration(
                                // color: MyColors.containerColor,
                                gradient: AppConfig.containerGradient,

                                borderRadius: BorderRadius.circular(10)
                                , boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 5,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],

                              ),*/


                          //padding: const EdgeInsets.all(10),
                          child: Row(
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
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text( jsonData["wallets"]==null?"0.0":jsonData["wallets"]["main_wallet"].toString(),
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),

                                      Text(
                                        AppConfig.currency,
                                        style: TextStyle(
                                            fontSize: 8.0, color: Colors.white),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),)


                    ,
                  ),
                 /* const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        // color: MyColors.containerColor,
                          gradient: AppConfig.containerGradient,
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Image.asset("assets/images/wallet.png", width: 30),
                          const SizedBox(width: 5),


                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Container(
                                constraints: BoxConstraints(maxWidth: size.width*.32),
                                child: const Text(
                                  "Fund Wallet",
                                  style: TextStyle(color: Colors.white,fontSize: 12),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text( "0.00",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 13),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),*/


                ],
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: size.width,
                child: Text(
                  "Incomes",
                  style: heading,
                  textAlign: TextAlign.start,
                ),
              ),

              SizedBox(height: 4,),

              HeadingWithImage(
                currency: "",
                name: 'Level Income',
                value: jsonData["incomes"]==null?"0.0":jsonData["incomes"]["level"].toString(),
                imagePath: 'assets/images/wave.png',
                type: 'level',
              ),
              /*HeadingWithImage(
                    currency: "",
                    name: 'WM Point',
                    value: controller.fullDashboardData?['incomes']['wm_point'] ?? "0",
                    imagePath: 'assets/images/wave2.png',
                  ),*/
              HeadingWithImage(
                currency: "",
                name: 'Daily Bonus',
                value: jsonData["incomes"]==null?"0.0":jsonData["incomes"]["daily"].toString(),
                imagePath: 'assets/images/wave3.png',
                type: 'daily',
              ),

              HeadingWithImage(
                currency: "",
                name: 'Salary',
                value: jsonData["incomes"]==null?"0.0":jsonData["incomes"]["salary"].toString(),
                imagePath: 'assets/images/wave.png',
                type: 'salary',
              ),

              HeadingWithImage(
                currency: "",
                name: 'Free Income',
                value: jsonData["incomes"]==null?"0.0":jsonData["incomes"]["free"].toString(),
                imagePath: 'assets/images/wave3.png',
                type: 'free',
              ),

              SizedBox(
                width: size.width,
                child: Text(
                  "Team",
                  style: heading,
                  textAlign: TextAlign.start,
                ),
              ),

              SizedBox(height: 4,),

              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child:
                    designNewCard(Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Active Directs",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color:  Colors.white.withOpacity(.5),),
                            ),

                            Text(
                              jsonData["teams"]==null?"0.0":jsonData["teams"]["active_directs"].toString(),
                              style: TextStyle(
                                  fontSize: 20, color: Colors.white),
                            )
                          ],
                        ),

                        const SizedBox(height: 10),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Inactive Directs",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color:  Colors.white.withOpacity(.5),),
                            ),
                            //const Spacer(),
                            Text(
                              jsonData["teams"]==null?"0.0":jsonData["teams"]["inactive_directs"].toString(),

                              style: TextStyle(
                                  fontSize: 20, color: Colors.white),
                            )
                          ],
                        ),

                      ],
                    ),)

                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child:
                    designNewCard(Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(

                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Directs",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color:  Colors.white.withOpacity(.5),),
                            ),

                            Text(
                              jsonData["teams"]==null?"0.0":jsonData["teams"]["total_directs"].toString(),
                              style: TextStyle(
                                  fontSize: 20, color: Colors.white),
                            )

                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(

                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Generation ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color:  Colors.white.withOpacity(.5),),
                            ),

                            Text(
                              jsonData["teams"]==null?"0.0":jsonData["teams"]["total_gen"].toString(),
                              style: TextStyle(
                                  fontSize: 20, color: Colors.white),
                            )
                          ],
                        ),
                      ],
                    ),)

                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],),
          ),),),
        ],
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

      jsonData=json;

      setState(() {
        jsonData;
      });
      //fetchSuccess(json);
    } else {

      if(Navigator.canPop(context!)){
        Navigator.pop(context!);
      }


      ScaffoldMessenger.of(context!).showSnackBar(const SnackBar(
        content: Text('Oops! Something went wrong!'),
      ));
    }

  }


  /*Future<void> fetchSuccess(Map<String, dynamic> json) async {


    try{

      if(json['res']=="success"){

        packageAmount=json["package"].toString();
        mainWallet=json["wallets"]["main_wallet"].toString();

        setState(() {
          packageAmount;
        });




      } else {



        String message = json['message'];

        ScaffoldMessenger.of(context!).showSnackBar(SnackBar(

          content: Text(message),

        ));

      }


    } catch(e){




      print(e.toString());

    }


  }*/

}
