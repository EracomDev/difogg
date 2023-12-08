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
  final String letter;
  final Color bgColor;

  const HeadingWithImage({
    super.key,
    required this.currency,
    required this.name,
    required this.value,
    required this.imagePath,
    required this.type,
    required this.letter,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border.all(color: AppConfig.myCardColor, width: 0.4),
          color: AppConfig.myCardColor,
          borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        child: Row(
          children: [
            // Image.asset(
            //   imagePath,
            //   width: 40.0,
            // ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: AppConfig.myCardColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Center(
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            child: Center(child: Text(letter)),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.north_east,
                        color: AppConfig.primaryText,
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 14.0,
                      color: Colors.white.withOpacity(.5),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppConfig.currency,
                        style: const TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        " ${double.parse(value).toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // const SizedBox(width: 16.0),
            // const Column(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   children: [
            //     Icon(
            //       Icons.arrow_forward,
            //       color: Colors.white,
            //       size: 16,
            //     ),
            //     SizedBox(
            //       height: 8,
            //     ),
            //   ],
            // ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            SlidePageRoute(
              page: TransactionIncome(
                type: type,
                title: name,
              ),
            ),
          );
        },
      ),
    );
  }
}
