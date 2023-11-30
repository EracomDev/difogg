import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:difog/screens/app_layout.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'settings.dart';


class TradingViewWidget extends StatelessWidget {
  const TradingViewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String contentBase64 =
    base64Encode(const Utf8Encoder().convert(kTradingViewWidget));
    return WebView(
      initialUrl: 'data:text/html;base64,$contentBase64',
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}

const kTradingViewWidget = '''
<!-- TradingView Widget BEGIN -->
<div class="tradingview-widget-container">
  <div class="tradingview-widget-container__widget"></div>
  <div class="tradingview-widget-copyright"><a href="https://in.tradingview.com/" rel="noopener nofollow" target="_blank"><span class="blue-text">Track all markets on TradingView</span></a></div>
  <script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-market-overview.js" async>
  {
  "colorTheme": "light",
  "dateRange": "12M",
  "showChart": true,
  "locale": "in",
  "width": "100%",
  "height": "100%",
  "largeChartUrl": "",
  "isTransparent": false,
  "showSymbolLogo": true,
  "showFloatingTooltip": false,
  "plotLineColorGrowing": "rgba(41, 98, 255, 1)",
  "plotLineColorFalling": "rgba(41, 98, 255, 1)",
  "gridLineColor": "rgba(240, 243, 250, 0)",
  "scaleFontColor": "rgba(106, 109, 120, 1)",
  "belowLineFillColorGrowing": "rgba(41, 98, 255, 0.12)",
  "belowLineFillColorFalling": "rgba(41, 98, 255, 0.12)",
  "belowLineFillColorGrowingBottom": "rgba(41, 98, 255, 0)",
  "belowLineFillColorFallingBottom": "rgba(41, 98, 255, 0)",
  "symbolActiveColor": "rgba(41, 98, 255, 0.12)",
  "tabs": [
    {
      "title": "Forex",
      "symbols": [
        {
          "s": "FX:EURUSD",
          "d": "EUR/USD"
        },
        {
          "s": "FX:GBPUSD",
          "d": "GBP/USD"
        },
        {
          "s": "FX:USDJPY",
          "d": "USD/JPY"
        },
        {
          "s": "FX:USDCHF",
          "d": "USD/CHF"
        },
        {
          "s": "FX:AUDUSD",
          "d": "AUD/USD"
        },
        {
          "s": "FX:USDCAD",
          "d": "USD/CAD"
        }
      ],
      "originalTitle": "Forex"
    },
    {
      "title": "Crypto",
      "symbols": [
        {
          "s": "BINANCE:BTCUSDT"
        },
        {
          "s": "BITSTAMP:BTCUSD"
        },
        {
          "s": "CRYPTO:BTCUSD"
        },
        {
          "s": "BINANCE:MATICUSDT.P"
        }
      ]
    }
  ]
}
  </script>
</div>
<!-- TradingView Widget END -->
''';
