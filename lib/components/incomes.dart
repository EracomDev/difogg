// ignore_for_file: depend_on_referenced_packages, file_names

import 'dart:ui';

import 'package:difog/utils/card_design_new.dart';
import 'package:flutter/material.dart';
import 'package:difog/screens/transaction_income.dart';
import 'package:difog/utils/app_config.dart';

import '../utils/page_slider.dart';


class HeadingWithImage extends StatelessWidget {
  final String currency;
  final String name;
  final String value;
  final String imagePath;
  final String type;

  const HeadingWithImage({
    super.key,
    required this.currency,
    required this.name,
    required this.value,
    required this.imagePath,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return


    designNewCard(InkWell(
      child: Row(
        children: [

          Image.asset(
            imagePath,
            width: 40.0,
          ),

          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 14.0,
                    color:  Colors.white.withOpacity(.5),),
                ),
                const SizedBox(height: 8.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      " ${double.parse(value).toStringAsFixed(2)}",
                      style: TextStyle(
                          fontSize: 20.0, color: Colors.white),
                    ),
                    Text(
                      AppConfig.currency,
                      style: TextStyle(
                          fontSize: 8.0, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16.0),
          Column(

            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Icon(Icons.arrow_forward,color: Colors.white,size: 16,),

              SizedBox(height: 8,),

            ],
          ),
        ],
      ),

      onTap: (){
        Navigator.push(
          context,
          SlidePageRoute(
            page: TransactionIncome(type: type,title: name,),
          ),
        );



      },
    ),);

  }
}
