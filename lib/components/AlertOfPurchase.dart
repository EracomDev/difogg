import 'package:flutter/material.dart';
import 'package:difog/utils/app_config.dart';

class AlertOfPurchase extends StatefulWidget {
  final String title, desc, type;

  const AlertOfPurchase(
      {Key? key, required this.title, required this.desc, required this.type})
      : super(key: key);

  @override
  _AlertOfPurchase createState() => _AlertOfPurchase();
}

class _AlertOfPurchase extends State<AlertOfPurchase> {
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
                  height: 5,
                ),
                widget.type == "failure"
                    ? Image.asset(
                        "assets/images/error.png",
                        width: 100,
                      )
                    : Image.asset(
                        "assets/images/success.png",
                        width: 100,
                      ),
                const SizedBox(height: 10),
                Text(
                  widget.desc,
                  style: const TextStyle(color: Colors.black, fontSize: 15),
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
                      child: Container(
                        width: 150,
                        child: TextButton(
                          onPressed: () => {
                            Navigator.of(context).pop(),
                            Navigator.of(context).pop(),
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  AppConfig.primaryColor.withOpacity(1))),
                          child: const Text(
                            "OK",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ),
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
