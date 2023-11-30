import 'package:flutter/material.dart';
import 'package:difog/screens/app_layout.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/app_config.dart';

class MyColors {
  static const Color bgColor = Colors.white;
}

class MarketHTML extends StatefulWidget {
  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MarketHTML> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: Scaffold(
        backgroundColor: MyColors.bgColor,

        body: Stack(
          children: [
            WebView(
              initialUrl: 'https://sendcryp.com/graph/',
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (String url) {
                setState(() {
                  _isLoading = false;
                });
              },
            ),
            if (_isLoading)
              Container(
                color: MyColors.bgColor,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

