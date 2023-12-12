import 'package:difog/utils/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:shoppig_flutter/ui/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/edit_user_profile.dart';



class CustomDialogBox extends StatefulWidget {



  final Function function;

  CustomDialogBox({Key? key,required this.function}) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();

}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context){
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin:const  EdgeInsets.only(top: 38),
          decoration: BoxDecoration(

              shape: BoxShape.rectangle,
              color: Colors.white,

              borderRadius: BorderRadius.circular(16),
              boxShadow: const [

                BoxShadow(color: Colors.black54,offset: Offset(0,4),
                  blurRadius: 10,
                  //https://twitter.com/zone_astronomy/status/1447864808808894470?t=JKgA51-MpMK4TUm8t1jxEg
                ),
              ]

          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              const SizedBox(height: 45,),

              //Image.asset("assets/images/dummy_person.png",height: 80,),

              Text("Update Profile",style:const  TextStyle(color : Colors.black,fontSize: 22,fontWeight: FontWeight.w600),),
              const SizedBox(height: 15,),
              Text("Profile update is mandatory to proceed further.",style: const TextStyle(color : Colors.black,fontSize: 16),textAlign: TextAlign.center,),
              const SizedBox(height: 22,),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: <Widget>[

                    /*Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                          style: ButtonStyle(

                            elevation:  MaterialStateProperty.all(0),

                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(

                                RoundedRectangleBorder(

                                  borderRadius: BorderRadius.circular(20),

                                )
                            )

                            ,),
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          child: const Text("No",style: TextStyle(color : Colors.white,fontSize: 14),)),
                    ),

                    const Spacer(

                    ),*/
                    Align(

                      alignment: Alignment.center,

                      child: ElevatedButton(

                          style: ButtonStyle(

                            elevation:  MaterialStateProperty.all(0),

                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),

                            backgroundColor: MaterialStateProperty.all<Color>( Colors.green),

                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(

                                RoundedRectangleBorder(

                                  borderRadius: BorderRadius.circular(20),

                                )
                            )

                            ,),

                          onPressed: (){

                            //Navigator.of(context).pop();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfile(function: widget.function,)),
                            );



                          },

                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text("Ok",style: const TextStyle(color : Colors.white,fontSize: 14),))),
                    ),


                  ],
                ),
              ),

            ],
          ),
        ),
        Positioned(
          left: 16,
          right: 16,

          child: Opacity ( opacity: 1,
            child :Container(
              padding: EdgeInsets.all(16),
                decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.grey.withOpacity(1),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 63, 63, 63)
                          .withOpacity(1), // Shadow color
                      blurRadius: 10.0, // Blur radius
                      spreadRadius: 2.0, // Spread radius
                      offset: const Offset(
                          2.0, 2.0), // Offset in the x and y direction
                    ),
                  ],



                ),



                
                child: Image.asset("assets/images/dummy_person.png",height: 60,)),
          ),
        )
      ],
    );
  }

}