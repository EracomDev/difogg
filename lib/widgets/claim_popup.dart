import 'dart:convert';
import 'dart:developer';

import 'package:difog/utils/app_config.dart';
import 'package:difog/widgets/success_or_failure_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
//import 'package:shoppig_flutter/ui/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/edit_user_profile.dart';
import '../services/api_data.dart';



class ClaimDialogBox extends StatefulWidget {

  final String u_id;

  ClaimDialogBox({Key? key,required this.u_id}) : super(key: key);

  @override
  _ClaimDialogBox createState() => _ClaimDialogBox();

}

class _ClaimDialogBox extends State<ClaimDialogBox> {


  bool showLoader = false;
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

              Text("Claim Income",style:const  TextStyle(color : Colors.black,fontSize: 22,fontWeight: FontWeight.w600),),
              const SizedBox(height: 15,),
              Text("Claim your today's earning.",style: const TextStyle(color : Colors.black,fontSize: 16),textAlign: TextAlign.center,),
              const SizedBox(height: 22,),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: <Widget>[


                    Align(

                      alignment: Alignment.center,

                      child:
                      showLoader?

                      Container(
                        height: 30,width: 30,
                        child: CircularProgressIndicator(strokeWidth: 2,),):ElevatedButton(

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

                            setState(() {
                              showLoader=true;
                            });

                            callApi(widget.u_id);

                            //Navigator.of(context).pop();





                          },

                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text("Confirm",style: const TextStyle(color : Colors.white,fontSize: 14),))),
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




                child: Image.asset("assets/images/income.png",height: 60,)),
          ),
        )
      ],
    );
  }


  callApi(id) async {
    var requestBody = jsonEncode({
      "u_id": id,
      "session_key":"sbI8taE!nKQ%Fv&0EK2!xnlrV\$CwkP!3"
    });

    print(requestBody);

    print("u_id=" + id);

    Map<String, String> headersnew = {
      "Content-Type": "application/json; charset=utf-8",
      "xyz": "",

      //"Authorization":"gGpjrL14ksvhIUTnj2Y2xdjoe623YWbKGbWSSe0ewD0gLtFjRqvpPaxDa2JVaFeBRz5U89Eq5VCCZmGdsl7sZc2lyNclvurR4vmtec67IjL6R2e75DT9cuuXZrjNP1frCZ1pCUeAHSemYiSuDSN29ptwJKCmeFF7uUHS5CxJB3Ee1waEWvvtHFxFvoDa0HGMvt5YxLZFmiPWpWv6MANggsaNOnx9PAjTSsZtjLP2DCjgH2bHtBVJOGPz7prtvJpx"
    };

    // print(rootPathMain+apiPathMain+ApiData.preRequest);

    var response = await post(Uri.parse(ApiData.claimRoi),
        headers: headersnew, body: requestBody);

    String body = response.body;
    print("response=1111${response.statusCode}");
    if (response.statusCode == 200) {
      print("response=${response.body}");
      Map<String, dynamic> json = jsonDecode(response.body.toString());
      log("json=$body");

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

        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialogBox(
                  type: "success",
                  title: "Success Alert",
                  desc: 'Earning claimed successfully.');
            });

        //{"total_directs":"0","active_directs":"0","inactive_directs":"0","total_gen":"0"}
      } else {
        String message = json['message'].toString();

        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }

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