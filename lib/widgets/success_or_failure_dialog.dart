import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:difog/services/api_data.dart';
import 'package:difog/utils/app_config.dart';

class AlertDialogBox extends StatefulWidget {
  final String title, desc, type;

  const AlertDialogBox(
      {Key? key, required this.title, required this.desc, required this.type})
      : super(key: key);

  @override
  _AlertDialogBox createState() => _AlertDialogBox();
}

class _AlertDialogBox extends State<AlertDialogBox> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context, size),
    );
  }

  contentBox(context, size) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppConfig.background, offset: const Offset(0, 4),
                    blurRadius: 10,
                    //https://twitter.com/zone_astronomy/status/1447864808808894470?t=JKgA51-MpMK4TUm8t1jxEg
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.title,
                  style: const TextStyle(
                      // color: widget.type == "success"
                      //     ? AppConfig.primaryText
                      //     : Colors.red,
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  widget.desc,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 88, 88, 88), fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Colors.grey.withOpacity(.30))),
                        child: const Text(
                          "OK",
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ),
                      // child: InkWell(
                      //     onTap: () {
                      //       Navigator.of(context).pop();
                      //     },
                      //     child: Container(
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(16),
                      //         ),
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 30, vertical: 8),
                      //         child: const Text(
                      //           "OK",
                      //           style: TextStyle(
                      //               color: Colors.black, fontSize: 18),
                      //         ))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
