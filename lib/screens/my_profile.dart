import 'dart:convert';
import 'dart:developer';

import 'package:difog/utils/card_design_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_data.dart';
import '../utils/app_config.dart';
import '../widgets/success_or_failure_dialog.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  var size;
  String u_id = "";

  String id = "";
  String name = "";
  String mobile = "";
  String email = "";
  String country = "";
  String walletAddress = "";

  String sponsorId = "";
  String sponsorName = "";
  String sponsorMobile = "";

  var jsonData;



  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;
    return Scaffold(

      appBar: AppBar(
        backgroundColor: AppConfig.myBackground,
        iconTheme: IconThemeData(
          color: AppConfig.titleIconAndTextColor, //change your color here
        ),
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text(
                "My Profile",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: AppConfig.titleIconAndTextColor,
                ),
              ),
            ],
          ),
        ),
      ),

      body: Container(

        width: size.width,
        height: size.height,
        color: AppConfig.background,

        child: SingleChildScrollView(child: Container(

          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [


              Center(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.grey.withOpacity(1),
                    boxShadow: [

                      BoxShadow(
                        color: const Color.fromARGB(255, 63, 63, 63)
                            .withOpacity(1), // Shadow color
                        blurRadius: 10.0, // Blur radius
                        spreadRadius: 2.0, // Spread radius
                        offset: const Offset(2.0, 2.0), // Offset in the x and y direction
                      ),

                    ],

                  ),


                  child: Image.asset("assets/images/dummy_person.png",height: 80,),

                  alignment: Alignment.center,


                ),
              ),

              SizedBox(height: 20,),


              Align(

                  child: Text("My Info",style: TextStyle(fontSize: 22),textAlign: TextAlign.center,),

                alignment:Alignment.center

              ),

              SizedBox(height: 20,),

              Container(


                child:designNewCard(

                  Column(
                  children: [

                    SizedBox(height: 10,),

                    textField("Name",name),

                    SizedBox(height: 10,),

                    textField("Email",email),

                    SizedBox(height: 10,),

                    textField("Mobile",mobile),

                    SizedBox(height: 10,),

                    textField("Country",country),

                    SizedBox(height: 10,),

                    Container(
                      width: size.width,
                      child: Text("Wallet Address",style: TextStyle(fontSize: 14,color: Colors.grey.withOpacity(.8)),),),

                    SizedBox(height: 2,),

                    Row(
                      children: [
                        Container(
                          width: size.width*.7,

                          child: Text(walletAddress,style: TextStyle(fontSize: 12),maxLines:1,overflow: TextOverflow.ellipsis,),
                        ),

                        Spacer(),

                        InkWell(child: Icon(Icons.copy,color: Colors.white,),
                        onTap: (){

                          Clipboard.setData(ClipboardData(text: walletAddress));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Wallet address copied successfully.')),
                          );


                        },)
                      ],
                    ),

                    SizedBox(height: 10,),


                  ],
                ),)

              ),




              //SizedBox(height: 20,),


              Align(

                  child: Text("Sponsor Info",style: TextStyle(fontSize: 22),textAlign: TextAlign.center,),

                  alignment:Alignment.center

              ),


              SizedBox(height: 20,),

              designNewCard( Column(
                children: [
                  SizedBox(height: 10,),

                  textField("Sponsor Id",sponsorId),

                  SizedBox(height: 10,),

                  textField("Sponsor Name",sponsorName),

                  SizedBox(height: 10,),

                  textField("Sponsor Mobile",sponsorMobile),

                  SizedBox(height: 10,),
                ],
              ),)




          ],),


        ),),

      ),

    );
  }

  Widget textField(title, text){

    return Column(
      children: [

        Container(
            width: size.width,
            child: Text(title,style: TextStyle(fontSize: 14,color: Colors.grey.withOpacity(.8)),),),

        SizedBox(height: 2,),

        Container(
          width: size.width,
          /*padding: EdgeInsets.all(16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)
              ,color: Colors.grey.withOpacity(.1)
          ),*/
          child: Text(text,style: TextStyle(fontSize: 20),),
        ),

      ],
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
    u_id = userId;

    hitApi(u_id);

  }

  hitApi(id) {
    print("response=");
    //_makePayment();

    //_activePackage(id);

    showDialog(
        barrierDismissible: false,
        barrierColor: const Color(0x56030303),
        context: context!,
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

    callApi(id);
  }

  callApi(id) async {
    var requestBody = jsonEncode(
        {
          "u_id":u_id,
         }
    );

    print(requestBody);

    print("u_id=" + id);

    Map<String, String> headersnew = {
      "Content-Type": "application/json; charset=utf-8",
      "xyz": "",

      //"Authorization":"gGpjrL14ksvhIUTnj2Y2xdjoe623YWbKGbWSSe0ewD0gLtFjRqvpPaxDa2JVaFeBRz5U89Eq5VCCZmGdsl7sZc2lyNclvurR4vmtec67IjL6R2e75DT9cuuXZrjNP1frCZ1pCUeAHSemYiSuDSN29ptwJKCmeFF7uUHS5CxJB3Ee1waEWvvtHFxFvoDa0HGMvt5YxLZFmiPWpWv6MANggsaNOnx9PAjTSsZtjLP2DCjgH2bHtBVJOGPz7prtvJpx"
    };

    // print(rootPathMain+apiPathMain+ApiData.preRequest);

    var response = await post(Uri.parse(ApiData.userDetail),
        headers: headersnew, body: requestBody);

    String body = response.body;
    print("response=1111${response.statusCode}");
    if (response.statusCode == 200) {
      print("response=${response.body}");
      Map<String, dynamic> json = jsonDecode(response.body.toString());
      log("json=$body");
      if (Navigator.canPop(context!)) {
        Navigator.pop(context!);
      }
      fetchSuccess(json);
    } else {
      if (Navigator.canPop(context!)) {
        Navigator.pop(context!);
      }

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialogBox(
                type: "failure",
                title: "Failed Alert",
                desc: 'Oops! Something went wrong!');
          });
    }
  }

  Future<void> fetchSuccess(Map<String, dynamic> json) async {

    try {
      if (json['res'] == "success") {

        jsonData = json;

        setState(() {
          jsonData;
        });

        id = json["myaccount_info"]["username"].toString();
        name = json["myaccount_info"]["name"].toString();
        mobile = json["myaccount_info"]["mobile"].toString();
        email = json["myaccount_info"]["email"].toString();
        country = json["myaccount_info"]["country"].toString();
        walletAddress = json["myaccount_info"]["userwallet"].toString();

        sponsorId = json["myaccount_info"]["sponsor_username"].toString();
        sponsorName = json["myaccount_info"]["sponsor_name"].toString();
        sponsorMobile = json["myaccount_info"]["sponsor_mobile"].toString();


      } else {

        String message = json['message'].toString();
        showDialog(
            context: context,
            builder: (BuildContext context) {

              return AlertDialogBox(
                  type: "failure", title: "Failed Alert", desc: message);

            });

      }
    } catch (e) {

      print(e.toString());

    }
  }

}
