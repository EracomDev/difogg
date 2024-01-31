import 'package:difog/screens/market_html.dart';
import 'package:difog/utils/app_config.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class Tester extends StatefulWidget {
  const Tester({super.key});

  @override
  State<Tester> createState() => _TesterState();
}

class _TesterState extends State<Tester> {
  void setData() {
    // Access the singleton instance of AppConfig
    AppConfig.instance.clientAddress = '111111111111111111111111111111';
    print(AppConfig.instance.clientAddress);
  }

  void getData() {
    // Access the singleton instance of AppConfig
    log("00000000000000000000000000000${AppConfig.instance.clientAddress}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  setData();
                },
                child: Text("Set")),
            ElevatedButton(
                onPressed: () {
                  getData();
                },
                child: Text("Get"))
          ],
        ),
      ),
    );
  }
}
