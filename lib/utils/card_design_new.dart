import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_config.dart';

Widget designNewCard(child) {
  return Container(
    //padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      /*image: new DecorationImage(
        image: new AssetImage("assets/images/design4.png"),
        fit: BoxFit.fill,
      ),*/
      borderRadius: BorderRadius.circular(20),

      border: Border.all(color: AppConfig.myCardColor, width: 1),
      //border: Border.all(color: Color(0xFF020A2A),width: .5),
      color: AppConfig.myCardColor,
      // gradient: AppConfig.containerGradientNew,

      /*boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.01),
          spreadRadius: 5,
          blurRadius: 5,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],*/
    ),

    child: Container(
      alignment: Alignment.center,
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(20),
      //   color: AppConfig.myCardColor,
      // ),
      padding: const EdgeInsets.all(10),
      child: child,
    ),
  );
}
