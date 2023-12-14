import 'package:difog/utils/card_design_new.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utils/app_config.dart';

class MyPackages extends StatefulWidget {
  List<dynamic> data;
  MyPackages({super.key, required this.data});

  @override
  State<MyPackages> createState() => _MyPackagesState();
}

class _MyPackagesState extends State<MyPackages> {
  final TextStyle packageText = const TextStyle(
      color: Color.fromARGB(255, 255, 255, 255),
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
      body: Stack(
        children: [
          Positioned(
            right: 0,
            top: 200,
            child: Container(
              height: 1,
              width: 1,
              // color: Colors.yellow,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                //border: Border.all(style: BorderStyle.solid,width: 2,color: MyColors.secondary.withOpacity(.6))
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 0, 65, 90)
                        .withOpacity(1), // Shadow color
                    blurRadius: 1011.0, // Blur radius
                    spreadRadius: 150.0, // Spread radius
                    offset: const Offset(
                        5.0, 5.0), // Offset in the x and y direction
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              height: 1,
              width: 1,
              // color: Colors.yellow,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                //border: Border.all(style: BorderStyle.solid,width: 2,color: MyColors.secondary.withOpacity(.6))
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 0, 65, 90)
                        .withOpacity(1), // Shadow color
                    blurRadius: 1011.0, // Blur radius
                    spreadRadius: 150.0, // Spread radius
                    offset: const Offset(
                        5.0, 5.0), // Offset in the x and y direction
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (widget.data.length > 0)
                    for (var item in widget.data)

                      // item["order_amount"],
                      //(item["capping"]),
                      //e(item["earning"]),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: designNewCard(Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Package Amount",
                                    style: packageText,
                                  ),
                                  Text(item["order_amount"] + '\$',
                                      style: packageText),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Income Restriction",
                                    style: packageText,
                                  ),
                                  Text('${(item["capping"])} \$',
                                      style: packageText),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Earned",
                                    style: packageText,
                                  ),
                                  Text("${(item["earning"])} \$",
                                      style: packageText),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              LinearProgressIndicator(
                                borderRadius: BorderRadius.circular(50),
                                minHeight: 15,
                                backgroundColor:
                                    AppConfig.primaryColor.withOpacity(.1),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppConfig.primaryColor,
                                ),
                                value: double.parse((item["earning"])) /
                                    (double.parse((item["capping"]))),
                              ),
                            ],
                          ),
                        )),
                      ),
                  if (widget.data.length == 0)
                    Center(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 200,
                          child: Lottie.asset('assets/images/no_data.json',
                              fit: BoxFit.contain, repeat: false),
                        ),

                        //Image.asset("assets/images/no_data.png",height: 200,width: 200,),
                        const Text(
                          "Data Not Found",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
