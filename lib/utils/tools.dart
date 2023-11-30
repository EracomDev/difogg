import 'package:flutter/material.dart';

import 'app_config.dart';

Future<void> messageDialog(BuildContext context, String errorMessage) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppConfig.background,
        title: Text('Alert!'),
        content: Text(errorMessage),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
