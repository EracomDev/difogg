import 'package:difog/screens/transaction.dart';
import 'package:difog/utils/card_design_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:difog/services/api_data.dart';
import 'dart:developer';

import 'package:difog/utils/app_config.dart';

import '../utils/page_slider.dart';
import '../utils/secure_storage.dart';
import '../widgets/success_or_failure_dialog.dart';

class Withdraw extends StatefulWidget {
  String main_wallet;
  Withdraw({super.key, required this.main_wallet});

  @override
  State<Withdraw> createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  var amountController = TextEditingController();
  var addressController = TextEditingController();
  var passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String ethAddress = "";
  String savedPass= "";
  @override
  void initState() {
    super.initState();
    selectedValue = dropdownData[0]['type']!;

    fetchInitData();
  }

  fetchInitData() async {
    final SecureStorage secureStorage = SecureStorage();

    final address = await secureStorage.read('ethAddress');

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String userId = prefs.get('u_id').toString();
    print(userId);
    print(address);

    var password = _getSavedPassword();
    savedPass= "";
    password.then((value) {

      savedPass=value.toString();

    });

    ethAddress = address.toString();

    setState(() {
      addressController.text = ethAddress;
    });
  }

  List<Map<String, dynamic>> dropdownData = [
    {"name": "Select Wallet", "type": "0"},
    {"name": "Main Wallet", "type": "main_wallet"},
  ];
  String selectedValue = "";
  double usdtAmount = 0;

  Future<dynamic> fetchData() {
    return Future(() => {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.background,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppConfig.background,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Withdraw",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: designNewCard(Container(
                        child: Row(
                          children: [
                            Image.asset("assets/images/wallet.png", width: 40),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  //constraints: BoxConstraints(maxWidth: size.width*.32),
                                  child: Text(
                                    "Withdrawal Balance",
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(.5),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  "\$ ${widget.main_wallet}",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            )
                          ],
                        ),
                      )),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "   Transaction fee 5%",
                  style: TextStyle(color: AppConfig.primaryText, fontSize: 12),
                ),
                const SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          labelStyle: const TextStyle(
                              color: Colors.white, fontSize: 14),
                          filled: true,
                          fillColor: AppConfig.myCardColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 20.0,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Amount cannot be empty';
                          } else {
                            // Convert the value to a numeric type (e.g., double or int) before comparison
                            double? numericValue = double.tryParse(value);
                            if (numericValue == null || numericValue <= 0) {
                              return 'Invalid amount';
                            }
                            return null;
                          }
                        },
                        onChanged: (value) {
                          //checkUSDT();
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: addressController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        readOnly: true,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                        decoration: InputDecoration(
                          labelText: 'Address',
                          labelStyle: const TextStyle(
                              color: Colors.white, fontSize: 14),
                          filled: true,
                          fillColor: AppConfig.myCardColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 20.0,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Address cannot be empty';
                          } else {
                            // Convert the value to a numeric type (e.g., double or int) before comparison

                            return null;
                          }
                        },
                        onChanged: (value) {
                          //checkUSDT();
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: passwordController,

                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(
                              color: Colors.white, fontSize: 14),
                          filled: true,
                          fillColor: AppConfig.myCardColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 20.0,
                          ),
                        ),
                        validator: (value) {


                          if (value == null || value.isEmpty) {
                            return 'password cannot be empty';
                          }
                          else if(savedPass!=passwordController.text.toString()){

                            return 'password does not match';

                          }

                          else {
                            // Convert the value to a numeric type (e.g., double or int) before comparison



                            return null;
                          }
                        },
                        onChanged: (value) {
                          //checkUSDT();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                selectedValue == "token_wallet"
                    ? Text(
                        "USDT Amount : $usdtAmount",
                        style: const TextStyle(color: AppConfig.primaryColor),
                      )
                    : const Center(),
                const SizedBox(height: 20),
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: AppConfig.buttonGradient,
                              borderRadius: BorderRadius.circular(20)),
                          child: ElevatedButton(
                            onPressed: () {

                              if(_formKey.currentState!.validate()){

                                print("yesssss...");
                                Withdraw();


                              }

                              //Withdraw();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent),
                            child: Text(
                              'Withdraw Your Balance',
                              style: TextStyle(
                                  color: AppConfig.titleIconAndTextColor),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
                Center(
                    child: TextButton(
                        child: const Text(
                          "View Withdraw History",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppConfig.primaryText),
                        ),
                        onPressed: () {

                          Navigator.push(
                            context,
                            SlidePageRoute(
                              page: Transaction(
                                type: "withdrawal",
                                title: "Withdrawal",
                              ),
                            ),
                          );

                        }))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> _getSavedPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('password');
  }

  Future<void> Withdraw() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('u_id');
    print(amountController.text);
    print(selectedValue);
    print(ApiData.withdraw);

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      var url = Uri.parse(ApiData.withdraw);
      var body = jsonEncode({
        'u_id': userId,
        'selected_wallet': selectedValue,
        'amount': amountController.text,
        'session_key': "sbI8taE!nKQ%Fv&0EK2!xnlrV\$CwkP!3",
        'wallet_address': ethAddress
      });

      print(body);

      try {
        var response = await post(url, body: body);
        print(response.body);
        if (response.statusCode == 200) {
          print(response.body);
          var responseBody = await jsonDecode(response.body);
          if (responseBody['res'] == "success") {
            setState(() {
              isLoading = false;
            });
            _showAlert(context, responseBody['message']);
          } else {
            setState(() {
              isLoading = false;
            });

            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialogBox(
                      type: "success",
                      title: "Success Alert",
                      desc: (responseBody?['message'])
                          .toString()
                          .replaceAll('<p>', '')
                          .replaceAll('</p>', ''));
                });
          }
        } else {
          setState(() {
            isLoading = false;
          });
          // ignore: use_build_context_synchronously

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AlertDialogBox(
                  type: "failure",
                  title: "Failed Alert",
                  desc: "Failed.",
                );
              });
        }
      } catch (error) {
        setState(() {
          isLoading = false;
        });
        print('An error occurred: $error');
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showAlert(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          icon: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              color: Colors.green,
            ),
            child: const Icon(
              Icons.done,
              color: Color.fromARGB(255, 255, 255, 255),
              size: 40.0,
            ),
          ),
          title: const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              textAlign: TextAlign.center,
              'Success',
              style: TextStyle(
                  fontSize: 30, color: Color.fromARGB(255, 78, 78, 78)),
            ),
          ),
          content: Column(
            children: [
              Container(
                  child: Text(
                msg,
                style: const TextStyle(color: Colors.black),
              )),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ],
          ),
          actions: [
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  fetchData();
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class CustomAlertDialog extends StatelessWidget {
  final Widget icon;
  final Widget title;
  final Widget content;
  final List<Widget> actions;

  const CustomAlertDialog({
    Key? key,
    required this.icon,
    required this.title,
    required this.content,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: -40.0,
            child: icon,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                title,
                const SizedBox(height: 8.0),
                content,
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
