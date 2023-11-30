

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:difog/services/api_data.dart';
import 'package:difog/utils/app_config.dart';




class OtpDialogBox extends StatefulWidget {


  final String userId,otp_type,amount,transferUsername,selected_wallet,withdrawal_type;
  final Function function;
  const OtpDialogBox({Key? key ,required this.userId,required this.function
    ,required this.otp_type ,required this.selected_wallet
    ,required this.amount,required this.transferUsername,required this.withdrawal_type }) : super(key: key);

  @override
  _OtpDialogBox createState() => _OtpDialogBox();
}

class _OtpDialogBox extends State<OtpDialogBox> {

  bool isShowingProgress  = false;

  String otp = "";
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery
        .of(context)
        .size;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context,size),
    );
  }

  contentBox(context,size){
    return Stack(
      children: <Widget>[

        Form(

            key: formkey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child:


            SingleChildScrollView(
              child :Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(

                    shape: BoxShape.rectangle,
                    color: AppConfig.background,

                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [

                      BoxShadow(color: AppConfig.background,offset: const Offset(0,4),
                        blurRadius: 10
                        ,
                        //https://twitter.com/zone_astronomy/status/1447864808808894470?t=JKgA51-MpMK4TUm8t1jxEg
                      ),
                    ]
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text("Confirm Otp!",style: TextStyle(color : Colors.white,fontSize: 22,fontWeight: FontWeight.w600),),
                    const SizedBox(height: 15,),
                    const Text("An Otp has been send to your email id. Please check otp and enter.",style: TextStyle(color : Colors.white,fontSize: 16),textAlign: TextAlign.center,),
                    const SizedBox(height: 16,),

                    SizedBox(
                      width: size.width*.66,
                      child: TextFormField(

                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(


                          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),

                          labelText: "Enter Otp",

                          border: OutlineInputBorder(

                            borderRadius: BorderRadius.circular(10.0),

                          ),



                        ),
                        validator: (value){

                          if(value!.isEmpty){

                            return "Otp field cannot be empty";

                          }

                          otp = value.toString();

                          return null;

                        },

                        // onChanged: (value){
                        //   name = value;
                        //   setState(() {
                        //
                        //   });
                        // },

                      ),
                    ),

                    const SizedBox(height: 16,),

                    Row(

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                              onPressed: (){
                                Navigator.of(context).pop();

                              },
                              child: const Text("Cancel",style: TextStyle(color: AppConfig.primaryColor,fontSize: 18),)),
                        ),
                        const Expanded(
                          child: Text(
                              ""
                          ),
                        ),

                        isShowingProgress? Column(

                          children: const <Widget>[
                            SizedBox(height: 10,),
                            CircularProgressIndicator(),

                            SizedBox(height: 20,),
                            Text("Please wait...."),
                          ],
                        ):

                        Align(
                          alignment: Alignment.bottomRight,

                          child: ElevatedButton(

                              onPressed: (){

                                FocusScope.of(context).requestFocus(FocusNode());

                                _forgotPassword();

                                //Navigator.of(context).pop();
                              },
                              child: Text("Confirm",style: TextStyle(color : AppConfig.background,fontSize: 18),)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),)
        )
        /* Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: Opacity ( opacity: 1,
            child :CircleAvatar(
              backgroundColor: Colors.white,
              radius: Constants.avatarRadius,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                //child: Image.asset("assets/images/image_jualary.jpg"),
                child:Icon(CupertinoIcons.power, size: 40,color: Colors.black,),
              ),
            ),
          ),
        )*/
      ],
    );
  }

  _forgotPassword() async {
    print("response=");

    setState(() {
      isShowingProgress = true;
    });


    print("response=2");

    var requestBody ;

    String api = "";



    Map<String, String> headersnew ={
      "content-type": "application/json",
      "xyz":"",

    };


    Response response;


    print("otp_type=${widget.otp_type}");

    /*if(widget.otp_type!="transfer"){

      return;
    }*/

    if(widget.otp_type=="transfer"){
      requestBody = {


        'u_id': widget.userId,
        "selected_wallet": widget.selected_wallet,
        "tx_username": widget.transferUsername,
        "amount": widget.amount,
        "otp_input":otp,


      };

      api=ApiData.transferFund;


    } else if(widget.otp_type=="withdrawal"){
      requestBody = {


        'u_id': widget.userId,
        "selected_wallet": widget.selected_wallet,
        "payment_address": widget.transferUsername,
        "amount": widget.amount,
        "otp_input":otp,
        "withdraw_type":widget.withdrawal_type,


      };

      api=ApiData.withdraw;
    }



    print("$requestBody");

    //print("path="+widget.rootPath+widget.apiPath+ApiData.forgetPassword);
    print(ApiData.transferFund);
    response = await http.post(Uri.parse(api),



        //headers: headersnew,
        body: requestBody);

    log("obj="+requestBody.toString());

    String body = response.body;
    print("response=1111${response.statusCode}");
    if(response.statusCode==200){
      print("response=${response.statusCode}");
      Map<String, dynamic> json = jsonDecode(response.body.toString());
      log("json=$body");
      forgotPasswordRes(json);

    } else {

      setState(() {
        isShowingProgress = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Oops! Something went wrong!'),
      ));

    }

  }

  Future<void> forgotPasswordRes(Map<String, dynamic> json) async {


    try{

      setState(() {
        isShowingProgress = false;
      });

      if(json['res']=="success"){


        widget.function(json["message"],"success");



      } else {

        String otp = json["error_otp"].toString();
        if(otp!="" && otp!="null"){

          otp=otp.replaceAll("<p>", "").replaceAll("</p>", "");
          //String message = json['message'];
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(otp),
          ));

          //widget.function(json["message"],"fail");

          //return;
        }

        String message = json['message'];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));

        widget.function(json["message"],"fail");

      }

    } catch(e){

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Oops! Something went wrong!'),
      ));

      setState(() {
        isShowingProgress = false;
      });
      print(e.toString());

    }

  }


}