import 'package:flutter/material.dart';
import 'package:difog/screens/browser.dart';
import 'package:difog/screens/main_page.dart';
import 'package:difog/screens/market_crypto.dart';
import 'package:difog/screens/market_html.dart';
import 'package:difog/screens/wallet_restore.dart';
import 'screens/wallet.dart';
import 'screens/settings.dart'; // Import the HelpCenter screen

class Routes {
  static const String browser = '/browser';
  static const String market = '/market';
  static const String wallet = '/wallet';
  static const String helpCenter = '/helpCenter'; // Add the helpCenter route
  static const String restoreWallet = '/restoreWallet'; // Add the helpCenter route
  static const String createWallet = '/restoreWallet'; // Add the helpCenter route

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case browser:
        return MaterialPageRoute(builder: (_) => BrowserPage());
      case market:
        return MaterialPageRoute(builder: (_) => MarketHTML());
      case wallet:
        return MaterialPageRoute(builder: (_) => MainPage());
      case helpCenter: // Add the case for helpCenter route
        return MaterialPageRoute(builder: (_) => HelpCenter());
      case restoreWallet: // Add the case for helpCenter route
        return MaterialPageRoute(builder: (_) => RestoreWallet());
      default:
        return null;
    }
  }
}

class NotFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Page not found'),
      ),
    );
  }
}
