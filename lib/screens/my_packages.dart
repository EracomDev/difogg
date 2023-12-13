import 'package:difog/utils/card_design_new.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utils/app_config.dart';

class MyPackages extends StatefulWidget {

  List<dynamic> data;
  MyPackages({super.key,required this.data});

  @override
  State<MyPackages> createState() => _MyPackagesState();
}

class _MyPackagesState extends State<MyPackages> {

  final TextStyle packageText = TextStyle(
      color: const Color.fromARGB(255, 255, 255, 255),
      fontSize: 16,
      fontWeight: FontWeight.normal);
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppConfig.background,
      appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: AppConfig.background,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "My Packages",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )),

      body: Container(



        child: SingleChildScrollView(
          child: Column(children: [

            if(widget.data.length>0)
              for(var item in widget.data)

               // item["order_amount"],
            //(item["capping"]),
            //e(item["earning"]),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),

                  child:
                
                  designNewCard(  Container(
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
                            Text(item["order_amount"]+ '\$', style: packageText),
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
                            Text('${(item["capping"])} \$', style: packageText),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Earned",
                              style: packageText,
                            ),
                            Text("${(item["earning"])} \$", style: packageText),
                          ],
                        ),

                        SizedBox(height: 10,),

                        LinearProgressIndicator(
                          backgroundColor: AppConfig.primaryColor.withOpacity(.4),

                          valueColor: AlwaysStoppedAnimation<Color>(AppConfig.primaryColor,),
                          value: double.parse((item["earning"]))/(double.parse((item["capping"]))),
                        ),
                      ],
                    ),
                  ))
              

               ,),

            if(widget.data.length==0)

              Center(
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Container(
                        height: 200,
                        child: Lottie.asset('assets/images/no_data.json',
                            fit: BoxFit.contain,repeat: false),
                      ),

                      //Image.asset("assets/images/no_data.png",height: 200,width: 200,),
                      Text("Data Not Found",style: TextStyle(fontSize: 18),
                      ),
                    ],
                  )
              ),
          ],),
        ),
      ),

    );

  }
}
