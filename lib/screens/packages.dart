// ignore_for_file: file_names

import 'dart:convert';
import 'dart:developer';

import 'package:difog/utils/card_design_new.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:difog/screens/purchase_package.dart';
import 'package:difog/utils/app_config.dart';

import '../components/packages_div.dart';
import '../services/api_data.dart';
import '../widgets/success_or_failure_dialog.dart';

class Packages extends StatefulWidget {
  const Packages({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PackagesState createState() => _PackagesState();
}

class _PackagesState extends State<Packages> {

  List<PackagesDiv> data = [];
  final TextStyle packageText = TextStyle(
      color: const Color.fromARGB(255, 255, 255, 255),
      fontSize: 16,
      fontWeight: FontWeight.normal);
  String u_id = "";

  var size;

  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;


    return Scaffold(
      backgroundColor: AppConfig.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        //backgroundColor: AppConfig.background,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Packages",
          style: TextStyle(color: Colors.white),
        ),
      ),
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


          SafeArea(
            child: Container(

              height: size.height,
              width: size.width,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children:

                      data.map((e) =>  Container(
                        //padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          // color: MyColors.containerColor,
                            //gradient: AppConfig.containerGradient,
                            borderRadius: BorderRadius.circular(10)),
                        child:
                        designNewCard( Column(
                          children: [

                            if(e.topupStatus=="Achieved")
                              Text("Already Purchased",style: TextStyle(color: Colors.green),),

                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(100),
                                        border: Border.all(color: Color(0xFF454A55),width: 1),

                                      ),
                                      padding:
                                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                      child: Text(
                                        e.name,
                                        style: const TextStyle(
                                            color: Color.fromARGB(255, 255, 255, 255),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),

                                Spacer(),

                                if(e.topupStatus!="Achieved")

                                  InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        //color: AppConfig.primaryColor,
                                        gradient: AppConfig.buttonGradient,
                                        borderRadius: BorderRadius.circular(100),
                                        //border: Border.all(color: AppConfig.primaryColor)
                                      ),
                                      padding:
                                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                      child: Text(
                                        "Purchase",
                                        style: TextStyle(
                                            color: AppConfig.titleIconAndTextColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),

                                    onTap: (){

                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                          PurchasePackage(packageAmount: e.businessVolume,function: ()=>callApi(),)));
                                    },
                                  ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Package Amount",
                                        style: packageText,
                                      ),
                                      Text('${e.businessVolume} \$', style: packageText),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Income Restriction",
                                        style: packageText,
                                      ),
                                      Text('${e.capping} \$', style: packageText),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Daily Claim Bonus",
                                        style: packageText,
                                      ),
                                      Text("${e.roi}%", style: packageText),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ))

                       ,
                      )).toList()

                  ),
                ),
              ),
            ),
          ),
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

    u_id=userId;
    hitApi();


  }

  hitApi(){
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

    callApi();


  }

  callApi() async {


    var requestBody = jsonEncode({

      "u_id":u_id,


    });

    print(requestBody);


    print("u_id="+u_id);

    Map<String, String> headersnew = {

      "Content-Type":"application/json; charset=utf-8",
      "xyz":"",

      //"Authorization":"gGpjrL14ksvhIUTnj2Y2xdjoe623YWbKGbWSSe0ewD0gLtFjRqvpPaxDa2JVaFeBRz5U89Eq5VCCZmGdsl7sZc2lyNclvurR4vmtec67IjL6R2e75DT9cuuXZrjNP1frCZ1pCUeAHSemYiSuDSN29ptwJKCmeFF7uUHS5CxJB3Ee1waEWvvtHFxFvoDa0HGMvt5YxLZFmiPWpWv6MANggsaNOnx9PAjTSsZtjLP2DCjgH2bHtBVJOGPz7prtvJpx"

    };

    // print(rootPathMain+apiPathMain+ApiData.preRequest);

    var response = await post(Uri.parse(ApiData.packages),
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

      showDialog(context: context,
          builder: (BuildContext context){
            return AlertDialogBox(
                type: "failure",
                title: "Failed Alert",
                desc: 'Oops! Something went wrong!'

            );
          }
      );


    }

  }

  Future<void> fetchSuccess(Map<String, dynamic> json) async {


    try{

      if(json['res']=="success"){

        //{"total_directs":"0","active_directs":"0","inactive_directs":"0","total_gen":"0"}

        List<dynamic>dataList = json["data"];

        if(dataList.length>0){

          data.clear();

          int active = 0;

          for(int i = 0 ; i< dataList.length ; i++){
            var singleData = dataList[i];
            if(singleData["status"].toString()=="Achieved"){
              active = i;
            }

          }

          print("active");
          print(active);

          for(int i = 0; i< dataList.length; i++){


            var singleData = dataList[i];

            if(active==0){
              data.add(PackagesDiv(

                name: singleData["pin_type"].toString(),
                businessVolume: singleData["business_volumn"].toString(),
                capping: singleData["capping"].toString(),
                topupStatus: singleData["status"].toString(),
                roi: singleData["roi"].toString(),

              ));
            } else {
              data.add(PackagesDiv(

                name: singleData["pin_type"].toString(),
                businessVolume: singleData["business_volumn"].toString(),
                capping: singleData["capping"].toString(),
                topupStatus:i<=active?"Achieved":

                singleData["status"].toString(),
                roi: singleData["roi"].toString(),

              ));
            }


          }

          setState(() {
            data;
          });
        }


      } else {

        if(Navigator.canPop(context!)){

          Navigator.pop(context!);

        }

        String message = json['message'];

        showDialog(context: context,
            builder: (BuildContext context){
              return AlertDialogBox(
                  type: "failure",
                  title: "Failed Alert",
                  desc: message

              );
            }
        );

      }


    } catch(e){


      if(Navigator.canPop(context!)){
        Navigator.pop(context!);
      }

      print(e.toString());

    }


  }

}
