// ignore_for_file: deprecated_member_use, file_names
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:difog/services/api_data.dart';
import 'package:difog/utils/app_config.dart';

import '../widgets/otp_dialog.dart';


class FundTransfer extends StatefulWidget {
  const FundTransfer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FundTransferState createState() => _FundTransferState();
}

class _FundTransferState extends State<FundTransfer> {
  var size;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var userIdController = TextEditingController();
  var amountController = TextEditingController();

  var dashboardData;

  String amount = "0";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('u_id');
    print('token $userId');


    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(ApiData.getTransferFund);
    var body = {'u_id': userId};
    try {
      var response = await http.post(url, body: body);
      print('res $response');
      if (response.statusCode == 200) {
        print('response.body ${response.body}');
        var jsonData = await jsonDecode(response.body.toString());
        if (jsonData['res'] == "success") {
          setState(() {
            dashboardData = jsonData;
            isLoading = false;

            amount = dashboardData["wallet_amount"]??"0".toString();
          });
          print('dashboardData $dashboardData');
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

      print('An error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: AppConfig.background,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Fund Transfer",
            style: TextStyle(color: Colors.white),
          )),
      body: Container(


        color: AppConfig.background,
        child: Form(
          key: _formKey,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child:
                  Material(
                      elevation: 2,
                      color: AppConfig.background.withOpacity(.1),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),

                      child: Container(
                        constraints: BoxConstraints(minWidth: size.width*.9,maxWidth: size.width*.9),

                        padding:const EdgeInsets.all(16),
                        decoration: BoxDecoration(

                          // color: Colors.white.withOpacity(.2),
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            border: Border.all(color: Colors.white,width: 2)

                        ),
                        child:
                        Column(
                          children: [
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  (dashboardData?['wallet_type']?[0]?['name']??"")
                                      .toString()
                                      .replaceAll('_', ' '),
                                  style: const TextStyle(
                                      color: AppConfig.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                Text(
                                  "\$ "+(amount??"0").toString(),
                                  style: const TextStyle(
                                      color: AppConfig.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 20.0),
                                  Container(
                                    child: TextFormField(
                                      controller: userIdController,
                                      style: const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        labelText: 'User ID',
                                        labelStyle:
                                        const TextStyle(color: Colors.white),
                                        filled: true,
                                        fillColor: const Color.fromARGB(83, 66, 66, 66),
                                        prefixIcon: const Icon(Icons.person,
                                            color: Colors.white),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(25.0),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          vertical: 15.0,
                                          horizontal: 20.0,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'user ID cannot be empty';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  // ---------------------------------------------------------------------
                                  const SizedBox(height: 20.0),
                                  Container(
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: amountController,
                                      style: const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        labelText: 'Amount',
                                        labelStyle:
                                        const TextStyle(color: Colors.white),
                                        filled: true,
                                        fillColor: const Color.fromARGB(83, 66, 66, 66),
                                        prefixIcon: const Icon(Icons.money_off,
                                            color: Colors.white),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(25.0),
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
                                          if (numericValue == null ||
                                              numericValue <= 0) {
                                            return 'Invalid amount';
                                          }
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  // ----------------------------------------------------
                                  isLoading == true
                                      ? const Center(
                                    child:
                                    CircularProgressIndicator(strokeWidth: 2),
                                  )
                                      : SizedBox(
                                    width: double.infinity,
                                    child: SizedBox(
                                      width: 200.0,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          sendOtp();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.all(15.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(25.0),
                                          ),
                                          primary: AppConfig.primaryColor, // Set Sanguine background color
                                          onPrimary:
                                          Colors.white, // Set text color
                                          elevation: 3.0, // Add elevation
                                        ),
                                        child: const Text(
                                          'Transfer',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 66, 40, 0),),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20.0),
                                ],
                              ),
                            ),
                          ],
                        ),))
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Future<void> sendOtp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('u_id').toString();
    final String username = prefs.getString('username').toString();
    print(amountController.text);
    print(ApiData.transferFund);
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      var url = Uri.parse(ApiData.sendOtp);
      var body = {
        "u_code": userId,
        "otp_type": "transfer"

      };
      try {
        var response = await http.post(url, body: body);
        print(response);
        if (response.statusCode == 200) {
          print(response.body);
          var responseBody = await jsonDecode(response.body);
          if (responseBody['res'] == "success") {


            showDialog(context: context,
                builder: (BuildContext context){
                  return OtpDialogBox(
                    userId: userId,
                    amount: amountController.text,
                    transferUsername: userIdController.text,
                    selected_wallet:  (dashboardData?['wallet_type']?[0]?['wallet_type']).toString(),

                    otp_type: "transfer",
                    function: (message,status)=>_otpMatchSuccess(message,status),
                    withdrawal_type: "",

                  );
                }
            );
            /*setState(() {
              isLoading = false;
            });
            _showAlert(context, responseBody['message']);*/
          } else {
            setState(() {
              isLoading = false;
            });
            if (responseBody?['error_amount'].length > 0) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text((responseBody?['error_amount'])
                      .toString()
                      .replaceAll('<p>', '')
                      .replaceAll('</p>', ''))));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(responseBody?['message'])));
            }
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
              Container(child: Text(msg)),
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
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  _otpMatchSuccess(message,status){


    if(status=="success"){

      amount=(double.parse(amount)-double.parse(amountController.text)).toStringAsFixed(2);


      if(Navigator.canPop(context)){
        Navigator.pop(context);
      }

      _showAlert(context, message);
    }else{

    }

    setState(() {
      isLoading = false;
    });


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
