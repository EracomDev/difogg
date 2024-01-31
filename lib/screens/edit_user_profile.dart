import 'dart:convert';
import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:difog/services/api_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_config.dart';
import '../widgets/success_or_failure_dialog.dart';

class EditProfile extends StatefulWidget {
  Function function;
  EditProfile({super.key, required this.function});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String name = "";
  String mobile = "";
  String email = "";
  String selectedCountry = "Select country";
  String countryCode = "+91";
  final formkey = GlobalKey<FormState>();
  var size;
  bool isShowingProgress = false;

  String u_id = "";

  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppConfig.myBackground,
      appBar: AppBar(
        backgroundColor: AppConfig.myBackground,
        iconTheme: IconThemeData(
          color: AppConfig.titleIconAndTextColor, //change your color here
        ),
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text(
                "Complete Profile Info",
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
      body: Container(
        child: Column(
          children: [
            Form(
              key: formkey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /* Container(
                            width: size.width*.6,

                            margin:EdgeInsets.only(top: 16),

                            child :
                            Container(
                              //width: size.width*.4,
                                child: Image.asset(ConstantsStrings.mainImage,height: 130,width: 130,)),
                          ),*/

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),

                        SizedBox(
                          width: size.width * 0.85,
                          child: TextFormField(
                            controller: fullNameController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 10.0),
                              labelText: "Full Name*",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(
                                    top: 0), // add padding to adjust icon
                                child: Icon(CupertinoIcons.person),
                              ),
                              /*fillColor: Colors.green.withOpacity(0.10),
                                      filled: true,*/
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Name field cannot be empty";
                              } else {
                                name = value.toString();
                                return null;
                              }
                            },
                          ),
                        ),

                        //SizedBox(height: 10),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: size.width * 0.85,
                          child: TextFormField(
                            controller: mobileController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 10.0),
                              labelText: "Mobile Number*",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(
                                    top: 0), // add padding to adjust icon
                                child: Icon(CupertinoIcons.phone),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Mobile Number cannot be empty";
                              } /*else if(value.length!=10){
                                        return "Mobile Number length should be 10";
                                      }*/

                              else if ((value.toString().contains(" "))) {
                                return "No space allowed inside mobile number";
                              } else {
                                mobile = value.toString();
                                return null;
                              }
                            },
                          ),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: size.width * 0.85,
                          child: TextFormField(
                            controller: emailController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 10.0),
                              labelText: "Email*",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(
                                    top: 0), // add padding to adjust icon
                                child: Icon(CupertinoIcons.mail),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Email cannot be empty";
                              } else if (!validation(value)) {
                                return "Email error";
                              } else if ((value.toString().contains(" "))) {
                                return "Spaces are not allowed inside email";
                              } else {
                                email = value.toString();
                                return null;
                              }
                            },
                          ),
                        ),

                        const SizedBox(height: 10),

                        InkWell(
                          child: Container(
                            width: size.width * 0.85,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 1),
                                color: const Color(0x1F4C779B),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: Row(
                              children: [
                                Text(
                                  selectedCountry,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_drop_down_sharp,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              //favorite: ,
                              countryListTheme: CountryListThemeData(
                                  backgroundColor: AppConfig.background,
                                  textStyle:
                                      const TextStyle(color: Colors.white)),
                              showPhoneCode:
                                  true, // optional. Shows phone code before the country name.
                              onSelect: (Country country) {
                                setState(() {
                                  selectedCountry = country.name;
                                  countryCode =
                                      "+" + country.phoneCode.toString();
                                });
                                print('Select country: ${country.name}');
                              },
                            );
                          },
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        const SizedBox(height: 20),

                        isShowingProgress
                            ? const Column(
                                children: <Widget>[
                                  CircularProgressIndicator(),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("Please wait...."),
                                ],
                              )
                            : SizedBox(
                                width: size.width * 0.85,
                                height: size.height * 0.06,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (formkey.currentState!.validate()) {
                                      if (selectedCountry == "Select country") {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                              "Please select country first."),
                                        ));
                                      } else {
                                        //isShowingProgress = true;
                                        //_registerAccount();

                                        print("name= $name");
                                        print("email= $email");
                                        print("mobile= $mobile");

                                        hitApi(u_id);
                                      }
                                    }

                                    setState(() {});
                                  },
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            AppConfig.primaryColor),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: const BorderSide(
                                                color:
                                                    AppConfig.primaryColor))),
                                  ),
                                  child: const Text("Submit Detail"),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool validation(String email) {
    bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
        .hasMatch(email);
    return emailValid;
  }

  @override
  void initState() {
    // TODO: implement initState

    fetchPref();
    super.initState();
  }

  fetchPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String userId = prefs.get('u_id').toString();
    u_id = userId;
  }

  hitApi(id) {
    print("response=");
    //_makePayment();

    //_activePackage(id);

    showDialog(
        barrierDismissible: false,
        barrierColor: const Color(0x56030303),
        context: context!,
        builder: (_) => const Material(
              type: MaterialType.transparency,
              child: Center(
                // Aligns the container to center
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Please wait....",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ));

    callApi(id);
  }

  callApi(id) async {
    var requestBody = jsonEncode({
      "session_key": "sbI8taE!nKQ%Fv&0EK2!xnlrV\$CwkP!3",
      "u_id": u_id,
      "name": name,
      "mobile": mobile,
      "email": email,
      "country": selectedCountry,
      "country_code": countryCode
    });

    print(requestBody);

    print("u_id=" + id);

    Map<String, String> headersnew = {
      "Content-Type": "application/json; charset=utf-8",
      "xyz": "",

      //"Authorization":"gGpjrL14ksvhIUTnj2Y2xdjoe623YWbKGbWSSe0ewD0gLtFjRqvpPaxDa2JVaFeBRz5U89Eq5VCCZmGdsl7sZc2lyNclvurR4vmtec67IjL6R2e75DT9cuuXZrjNP1frCZ1pCUeAHSemYiSuDSN29ptwJKCmeFF7uUHS5CxJB3Ee1waEWvvtHFxFvoDa0HGMvt5YxLZFmiPWpWv6MANggsaNOnx9PAjTSsZtjLP2DCjgH2bHtBVJOGPz7prtvJpx"
    };

    // print(rootPathMain+apiPathMain+ApiData.preRequest);

    var response = await post(Uri.parse(ApiData.editProfile),
        headers: headersnew, body: requestBody);

    String body = response.body;
    print("response=1111${response.statusCode}");
    if (response.statusCode == 200) {
      print("response=${response.body}");
      Map<String, dynamic> json = jsonDecode(response.body.toString());
      log("json=$body");
      if (Navigator.canPop(context!)) {
        Navigator.pop(context!);
      }
      fetchSuccess(json);
    } else {
      if (Navigator.canPop(context!)) {
        Navigator.pop(context!);
      }

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialogBox(
                type: "failure",
                title: "Failed Alert",
                desc: 'Oops! Something went wrong!');
          });
    }
  }

  Future<void> fetchSuccess(Map<String, dynamic> json) async {
    try {
      if (json['res'] == "success") {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('name', name).toString();
        prefs.setString('mobile', mobile).toString();
        prefs.setString('email', email).toString();
        prefs.setString('country', selectedCountry).toString();
        prefs.setString('country_code', countryCode).toString();

        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        widget.function(u_id);
      } else {
        String message = json['message'].toString();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialogBox(
                  type: "failure", title: "Failed Alert", desc: message);
            });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
