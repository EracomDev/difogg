import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:difog/utils/card_design.dart';
import '../utils/app_config.dart';
import 'confirm_mnemonic.dart';

class MnemonicsPage extends StatelessWidget {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final String mnemonicKey = 'mnemonic';

  Future<List<List<String>>?> _retrieveDataArray() async {
    final dataArrayString = await secureStorage.read(key: 'tempWallet');
    if (dataArrayString != null) {
      final dataArray = json.decode(dataArrayString);
      final List<List<String>> typedDataArray = (dataArray as List<dynamic>)
          .map<List<String>>(
            (dynamic item) => List<String>.from(item),
          )
          .toList();
      return typedDataArray;
    } else {
      return null;
    }
  }

  void _copyMnemonicToClipboard(BuildContext context, String mnemonic) {
    Clipboard.setData(ClipboardData(text: mnemonic));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Image.asset(
            'assets/images/success.png',
            width: 70,
            height: 70,
          ),
          content: const Text(
            'Mnemonic copied to clipboard',
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: TextButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(AppConfig.btnBg)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // void _copyMnemonicToClipboard(BuildContext context, String mnemonic) {
  //   Clipboard.setData(ClipboardData(text: mnemonic));

  //   final overlay = Overlay.of(context);
  //   OverlayEntry overlayEntry;

  //   overlayEntry = OverlayEntry(
  //     builder: (context) => Positioned(
  //       top: MediaQuery.of(context).size.height * 0.5 -
  //           20, // Adjust the position as needed
  //       left: 0,
  //       right: 0,
  //       child: Material(
  //         color: Colors.transparent,
  //         child: Container(
  //           alignment: Alignment.center,
  //           child: Container(
  //             padding: EdgeInsets.all(16),
  //             decoration: BoxDecoration(
  //               color: AppConfig.primaryColor,
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //             child: Text(
  //               'Mnemonic copied to clipboard',
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 16,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );

  //   overlay.insert(overlayEntry);

  //   // Wait for a short duration and then remove the overlay
  //   Future.delayed(Duration(seconds: 2), () {
  //     overlayEntry.remove();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.myBackground,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppConfig.titleIconAndTextColor, //change your color here
        ),
        backgroundColor: AppConfig.myBackground,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text(
                "Show Mnemonics",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: AppConfig.titleIconAndTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder<List<List<String>>?>(
          future: _retrieveDataArray(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<List<String>>? dataArray = snapshot.data;
              final String? mnemonic = dataArray![0][1];
              final List<String> mnemonicWords = dataArray![0][1].split(' ');
              //print(dataArray);

              return Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Please save the mnemonics:',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(
                        mnemonicWords.length,
                        (index) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          width: MediaQuery.of(context).size.width *
                              .28, // Adjust the width as desired
                          height: 40, // Adjust the height as desired
                          decoration: BoxDecoration(
                              //color: MyColors.cardBackground,

                              borderRadius: BorderRadius.circular(20),
                              color: AppConfig.myCardColor),
                          child: Center(
                            child: Text(
                              '${index + 1}. ${mnemonicWords[index]}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              gradient: AppConfig.buttonGradient,
                              borderRadius: BorderRadius.circular(20)),
                          child: ElevatedButton(
                            onPressed: () {
                              _copyMnemonicToClipboard(context, mnemonic!);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent),
                            child: Text(
                              'Copy Mnemonic',
                              style: TextStyle(
                                  color: AppConfig.titleIconAndTextColor),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              gradient: AppConfig.buttonGradient,
                              borderRadius: BorderRadius.circular(20)),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ConfirmMnemonics()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent),
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                  color: AppConfig.titleIconAndTextColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              //print('Error retrieving mnemonic: ${snapshot.error}');
              return const Text('Error retrieving mnemonic');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

class ConfirmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppConfig.titleIconAndTextColor, //change your color here
        ),
        backgroundColor: AppConfig.titleBarColor,

        //systemOverlayStyle:SystemUiOverlayStyle(statusBarColor: MyColors.secondaryColor,statusBarBrightness: Brightness.light,statusBarIconBrightness: Brightness.light),

        elevation: 0,

        automaticallyImplyLeading: true,
        //brightness: Brightness.light,

        //brightness: Brightness.light,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text(
                "Confirmation Page",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: AppConfig.titleIconAndTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'Mnemonics confirmed!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ViewMnemonics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MnemonicsPage(),
    );
  }
}
