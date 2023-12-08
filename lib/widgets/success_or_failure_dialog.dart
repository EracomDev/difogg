

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:difog/services/api_data.dart';
import 'package:difog/utils/app_config.dart';




class AlertDialogBox extends StatefulWidget {


  final String title,desc, type;

  const AlertDialogBox({Key? key ,required this.title,required this.desc,required this.type
     }) : super(key: key);

  @override
  _AlertDialogBox createState() => _AlertDialogBox();
}

class _AlertDialogBox extends State<AlertDialogBox> {


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

        SingleChildScrollView(
          child :Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(

                shape: BoxShape.rectangle,
                color: AppConfig.primaryColor.withOpacity(.5),

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
                Text("${widget.title}",style: TextStyle(color : widget.type=="success"?Colors.green:Colors.red,fontSize: 22,fontWeight: FontWeight.w600),),
                const SizedBox(height: 15,),
                Text("${widget.desc}",style: TextStyle(color : Colors.white,fontSize: 16),textAlign: TextAlign.center,),
                const SizedBox(height: 16,),


                const SizedBox(height: 16,),

                Row(

                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: <Widget>[


                    Align(
                      alignment: Alignment.center,

                      child: InkWell(

                          onTap: (){

                            Navigator.of(context).pop();

                          },
                          child:

                          Container(

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppConfig.primaryColor

                            ),
                              padding: EdgeInsets.symmetric(horizontal: 30,vertical: 8),
                              child: Text("OK",style: TextStyle(color : Colors.white,fontSize: 18),))),
                    ),
                  ],
                ),
              ],
            ),
          ),)

      ],
    );
  }


}