import 'package:flutter/material.dart';

import '../utils/app_config.dart';

class TicketDetail extends StatefulWidget {
  Map<String, dynamic> data;
  TicketDetail({super.key, required this.data});

  @override
  State<TicketDetail> createState() => _TicketDetailState();
}

class _TicketDetailState extends State<TicketDetail> {
  var size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppConfig.background,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppConfig.background,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Support Details",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            constraints:
                                BoxConstraints(maxWidth: size.width * .5),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: AppConfig.primaryText.withOpacity(.6),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                    bottomLeft: Radius.circular(16))),
                            child: Text(widget.data["message"].toString()),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Image.asset(
                            "assets/images/dummy_person.png",
                            height: 40,
                            width: 40,
                          )
                        ],
                      ),
                      Text(
                        widget.data["timestamp"].toString(),
                        style: const TextStyle(fontSize: 10),
                      )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/app_logo.png",
                            height: 40,
                            width: 40,
                          ),
                          widget.data["reply"].toString() == "null"
                              ? const Text("Not Replied")
                              : Container(
                                  constraints:
                                      BoxConstraints(maxWidth: size.width * .5),
                                  child: Text(widget.data["reply"].toString()),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color:
                                          AppConfig.primaryText.withOpacity(.6),
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16),
                                          bottomRight: Radius.circular(16))),
                                ),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                      Text(
                        widget.data["approved_date"] ?? "".toString(),
                        style: const TextStyle(fontSize: 10),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
