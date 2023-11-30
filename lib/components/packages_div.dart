// ignore_for_file: depend_on_referenced_packages, file_names

import 'package:flutter/material.dart';
import 'package:difog/utils/app_config.dart';


class PackagesDiv extends StatelessWidget {
  final String name;
  final String businessVolume;
  final String capping;

  final String topupStatus;
  final String roi;


  const PackagesDiv({
    super.key,
    required this.name,
    required this.businessVolume,
    required this.capping,

    required this.topupStatus,
    required this.roi,

  });
  @override
  Widget build(BuildContext context) {
    final TextStyle packageText = TextStyle(
        color: const Color.fromARGB(255, 255, 255, 255),
        fontSize: 16,
        fontWeight: FontWeight.bold);

    return  Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        // color: MyColors.containerColor,
          gradient: LinearGradient(colors: [
            Color.fromRGBO(51, 47, 48, 1.0),
            //Color.fromRGBO(19, 19, 19, 1.0)
            Color.fromRGBO(19, 19, 19, 1.0)
          ]),
          borderRadius: BorderRadius.circular(10)),
      child: Stack(children: [
        Positioned.fill(
          top: 0,
          child: Opacity(
            opacity: 0.3, // Adjust opacity here
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10) // Adjust color here
              ),
            ),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                      color: AppConfig.primaryColor,
                      borderRadius: BorderRadius.circular(100)),
                  padding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Text(
                    name,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Business Volume",
                        style: packageText,
                      ),
                      Text(businessVolume, style: packageText),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Capping",
                        style: packageText,
                      ),
                      Text("\$ $capping", style: packageText),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ROI",
                        style: packageText,
                      ),
                      Text("$roi %", style: packageText),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ]),
    );
  }
}
