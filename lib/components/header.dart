import 'package:flutter/material.dart';
import '../utils/app_config.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        AppConfig.appName,
        style: TextStyle(
          color: AppConfig.textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0), // Adjust the value as needed
        child: Image.asset(
          AppConfig.appLogo,
          color: AppConfig.textColor,
          width: 30,
          height: 15,
        ),
      ),
      backgroundColor: AppConfig.primaryColor,
      elevation: 0,
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          color: AppConfig.textColor,
          onPressed: () {
            // Add notification button functionality here
          },
        ),
      ],
    );
  }
}
