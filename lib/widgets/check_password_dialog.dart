

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


import '../utils/app_config.dart';
import 'success_or_failure_dialog.dart';




class ConfirmPasswordBox extends StatefulWidget {



  final Function function;
  const ConfirmPasswordBox({Key? key ,required this.function,}) : super(key: key);

  @override
  _ConfirmPasswordBox createState() => _ConfirmPasswordBox();
}

class _ConfirmPasswordBox extends State<ConfirmPasswordBox> {

  bool isShowingProgress  = false;
  String password= "";

  final formkey = GlobalKey<FormState>();

  var secureStorage;

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
                    const Text("Confirm password!",style: TextStyle(color : Colors.white,fontSize: 22,fontWeight: FontWeight.w600),),
                    const SizedBox(height: 15,),


                    SizedBox(
                      width: size.width*.66,
                      child: TextFormField(

                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(


                          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),

                          labelText: "Enter password",

                          border: OutlineInputBorder(

                            borderRadius: BorderRadius.circular(10.0),

                          ),



                        ),
                        validator: (value){

                          if(value!.isEmpty){

                            return "Password field cannot be empty";

                          }

                          password = value.toString();

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

                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: <Widget>[
                        /*Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                              onPressed: (){
                                Navigator.of(context).pop();

                              },
                              child: Text("Cancel",style: TextStyle(color: AppConfig.primaryColor,fontSize: 18),)),
                        ),
                        const Expanded(
                          child: Text(
                              ""
                          ),
                        ),*/

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

                              onPressed: () async {

                                String? savedPassword = await _getSavedPassword();



                                if (password != savedPassword) {

                                  FocusScope.of(context).requestFocus(FocusNode());

                                  if(Navigator.canPop(context)){
                                    Navigator.pop(context);
                                  }
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const AlertDialogBox(
                                            type: "failure",
                                            title: "Failed Alert",
                                            desc: 'Password does not match.');
                                      });



                                } else {

                                  FocusScope.of(context).requestFocus(FocusNode());
                                  if(Navigator.canPop(context)){
                                    Navigator.pop(context);
                                  }

                                  widget.function();

                                }




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



  Future<String?> _getSavedPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    secureStorage = const FlutterSecureStorage();
    return prefs.getString('password');
  }


}