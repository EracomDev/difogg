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

import '../utils/secure_storage.dart';

class Withdraw extends StatefulWidget {

  String main_wallet;
  Withdraw({super.key,required this.main_wallet});

  @override
  State<Withdraw> createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {

  var amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String ethAddress = "";
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

    ethAddress = address.toString();

    setState(() {
      ethAddress;
    });


  }


  List<Map<String, dynamic>> dropdownData = [
    {"name": "Select Wallet", "type": "0"},
    {"name": "Main Wallet", "type": "main_wallet"},
  ];
  String selectedValue = "";
  double usdtAmount = 0;

  Future<dynamic> fetchData(){

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
          style: TextStyle(color: Colors.white),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: designNewCard(Container(
                        
                        child:

                        Row(
                          children: [
                            Image.asset("assets/images/wallet.png", width: 30),
                            const SizedBox(width: 16),


                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Container(
                                  //constraints: BoxConstraints(maxWidth: size.width*.32),
                                  child: Text(
                                    "Main Wallet",
                                    style: TextStyle(color:  Colors.white.withOpacity(.5),fontSize: 14,fontWeight: FontWeight.w300),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  "${widget.main_wallet} \$",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )
                              ],
                            )
                          ],
                        ),

                      )),
                    ),
                    /*const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppConfig.cardBackground,
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Image.asset("assets/images/wallet.png", width: 25),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Withdrawal Amount",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                    ),
                                  ),
                                  Text(
                                    "${AppConfig.currency} 00",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),*/
                  ],
                ),
                // Container(
                //   margin: const EdgeInsets.only(top: 10),
                //   decoration: BoxDecoration(
                //       color: MyColors.containerColor,
                //       borderRadius: BorderRadius.circular(10)),
                //   padding: const EdgeInsets.all(15),
                //   child: Row(
                //     children: [
                //       Image.asset("assets/images/wallet.png", width: 50),
                //       const SizedBox(width: 5),
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           const Text(
                //             "Total Withdrawal Amount",
                //             style: TextStyle(color: Colors.white, fontSize: 16),
                //           ),
                //           Text(
                //             "\$ ${(dashboardData?['total_withdrawal']).toString()}",
                //             style: const TextStyle(
                //                 color: Colors.white, fontSize: 16),
                //           )
                //         ],
                //       )
                //     ],
                //   ),
                // ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedValue,

                        icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.white,size: 18,),
                        decoration:  InputDecoration(
                          filled: true,
                          fillColor: AppConfig.textFieldColor,
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            borderSide: BorderSide(
                              color: AppConfig.textFieldColor,
                              width: 1.0,
                            ),
                          ),
                        ),
                        dropdownColor: AppConfig.background,
                        items: dropdownData.map((data) {
                          return DropdownMenuItem<String>(
                            value: data['type']!,
                            child: Text(
                              data['name']!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty || value == "0") {
                            return "Please select Wallet";
                          } else {
                            return null;
                          }
                        },
                      ),
                      /*Container(
                        padding: EdgeInsets.all(15),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(83, 66, 66, 66),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                                color: Color.fromARGB(255, 65, 65, 65))),
                        child: const Text(
                          "Main Wallet",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),*/
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          labelStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: AppConfig.textFieldColor,
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
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Withdrawal Address : ",
                      style: TextStyle(color: Colors.white),
                    ),
                    Container(

                      margin: EdgeInsets.only(left: 16),
                      child: Text(
                        ethAddress,
                        style: const TextStyle(color: Colors.white,fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const Center(
                    child: CircularProgressIndicator(strokeWidth: 2))
                    : SizedBox(
                  width: double.infinity,
                  child: SizedBox(
                    width: 200.0,
                    child:

                    Container(
                      decoration: BoxDecoration(gradient:

                      AppConfig.buttonGradient,borderRadius: BorderRadius.circular(20)

                      ),
                      child: ElevatedButton(
                        onPressed: () {

                          Withdraw();
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                        child: Text('Withdraw',style: TextStyle(color: AppConfig.titleIconAndTextColor),),
                      ),
                    )



                    /*ElevatedButton(
                      onPressed: () {
                        Withdraw();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        primary: AppConfig.primaryColor, // Set Sanguine background color
                        onPrimary: Colors.white, // Set text color
                        elevation: 3.0, // Add elevation
                      ),
                      child: Text(
                        'Withdraw',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),*/
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text((responseBody?['message'])
                    .toString()
                    .replaceAll('<p>', '')
                    .replaceAll('</p>', ''))));
          }
        } else {
          setState(() {
            isLoading = false;
          });
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
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
              Container(child: Text(msg,style: TextStyle(color: Colors.black),)),
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
