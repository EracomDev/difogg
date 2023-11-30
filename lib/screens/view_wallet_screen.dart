import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/app_config.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: MnemonicConfirmationPage(),
    );
  }
}

class MnemonicConfirmationPage extends StatefulWidget {
  @override
  _MnemonicConfirmationPageState createState() =>
      _MnemonicConfirmationPageState();
}

class _MnemonicConfirmationPageState extends State<MnemonicConfirmationPage> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  List<String> mnemonics = [];
  List<int> randomNumbers = [];
  List<int?> selectedNumbers = [];

  @override
  void initState() {
    super.initState();
    generateRandomNumbers();
    fetchMnemonic();
  }

  void generateRandomNumbers() {
    // Generate 4 random numbers between 0 and 7 (inclusive)
    var random = Random();
    randomNumbers = List.generate(4, (_) => random.nextInt(8));
  }

  Future<void> fetchMnemonic() async {
    final mnemonic = await secureStorage.read(key: 'mnemonic');
    if (mnemonic != null) {
      setState(() {
        mnemonics = mnemonic.split(' ');
      });
    }
  }

  Widget buildMnemonicItem(int index) {
    return ListTile(
      title: Text(mnemonics[randomNumbers[index]]),
      trailing: DropdownButton<int>(
        value: selectedNumbers[index],
        hint: Text('Select Number'),
        items: List.generate(12, (i) {
          return DropdownMenuItem<int>(
            value: i + 1,
            child: Text((i + 1).toString()),
          );
        }),
        onChanged: (int? selectedNumber) {
          setState(() {
            selectedNumbers[index] = selectedNumber;
          });
        },
      ),
    );
  }

  bool isConfirmationComplete() {
    return selectedNumbers.every((number) => number != null);
  }

  void confirmMnemonic() {
    if (isConfirmationComplete()) {
      bool allCorrect = true;
      for (var i = 0; i < mnemonics.length; i++) {
        if (mnemonics[randomNumbers[i]] != null &&
            mnemonics[randomNumbers[i]] != selectedNumbers[i].toString()) {
          allCorrect = false;
          break;
        }
      }
      if (allCorrect) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: AppConfig.background,
            title: Text('Confirmation'),
            content: Text('All selected mnemonics are correct!'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: AppConfig.background,
            title: Text('Confirmation'),
            content: Text('Incorrect mnemonic selected!'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppConfig.background,
          title: Text('Confirmation'),
          content: Text('Please select all mnemonics!'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }


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


              Text("Mnemonic Confirmation",
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
      body: ListView.builder(
        itemCount: randomNumbers.length,
        itemBuilder: (context, index) {
          return buildMnemonicItem(index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: confirmMnemonic,
        child: Icon(Icons.check),
      ),
    );
  }
}
