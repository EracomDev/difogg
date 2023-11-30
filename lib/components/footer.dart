import 'package:flutter/material.dart';
import '../routes.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Routes.browser);
            },
            child: _buildFooterItem(Icons.web, 'Web'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Routes.wallet);
            },
            child: _buildFooterItem(Icons.account_balance_wallet, 'Wallet'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Routes.market);
            },
            child: _buildFooterItem(Icons.trending_up, 'Market'),
          ),
          GestureDetector(
            onTap: () {
              // Add the onTap action for HelpCenter
              Navigator.pushNamed(context, Routes.helpCenter);
            },
            child: _buildFooterItem(Icons.settings, 'Settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterItem(IconData iconData, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          iconData,
          color: Colors.black, // Set the icon color to white
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.black, // Set the label text color to white
          ),
        ),
      ],
    );
  }
}
