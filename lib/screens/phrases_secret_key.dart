import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_config.dart';

class PhrasesAndSecret extends StatefulWidget {
  const PhrasesAndSecret({super.key});

  @override
  State<PhrasesAndSecret> createState() => _PhrasesAndSecretState();
}

class _PhrasesAndSecretState extends State<PhrasesAndSecret> {

  TextEditingController _passwordController = TextEditingController();
  bool _obscureOldPassword = true;

  bool isPasswordMatch = false;
  String _errorText = "";

  var secureStorage;

  String key = "";
  List<String>mnemonics= [];

  var size;

  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;
    return Scaffold(
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
                "Phrases and Secret Key",
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

        height: size.height,
        width:size.width,

        color: AppConfig.background,
        child:



        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(

              children: [


                Container(
                  height: 200,
                  child: Lottie.asset('assets/images/anim6.json',
                      fit: BoxFit.contain),
                ),


                if(!isPasswordMatch)
                Column(
                  children: [


                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscureOldPassword,
                      decoration: InputDecoration(
                        labelText: 'Enter Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureOldPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureOldPassword = !_obscureOldPassword;
                            });
                          },
                        ),
                      ),
                    ),

                    if(_errorText!="")

                      Text(_errorText,style: TextStyle(color: Colors.red),),


                    SizedBox(height: 20,),

                    InkWell(child:
                    Container(


                      alignment: Alignment.center,

                      width: size.width,
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 12),

                      decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(20),
                          color: AppConfig.primaryColor
                      ),

                      child: Text("Submit",style: TextStyle(fontSize:15,fontWeight: FontWeight.bold),),

                    ),

                      onTap: () async {


                        String? savedPassword = await _getSavedPassword();
                        String oldPassword = _passwordController.text;


                        if (oldPassword != savedPassword) {
                          setState(() {
                            _errorText = 'Incorrect password.';
                          });
                          return;
                        }
                        else{

                          final dataArrayString = await secureStorage.read(key: 'mnemonic');
                          final privateKey = await secureStorage.read(key: 'privateKey');

                          mnemonics.addAll(dataArrayString.toString().split(" "));

                          print(mnemonics);

                          key=privateKey.toString();
                          print("key="+privateKey.toString());

                          setState(() {
                            isPasswordMatch = true;
                          });


                        }



                      },)
                  ],
                ),

                if(isPasswordMatch)

                  Column(
                    children: [

                      Container(child: Text("Note - Please do not share these mnemonic phrases and private key to anyone for security of your wallet account."),),

                      SizedBox(height: 20,),

                      Container(child:
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(
                          mnemonics.length,
                              (index) => Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            width: size.width *
                                .28, // Adjust the width as desired
                            height: 40, // Adjust the height as desired
                            decoration: BoxDecoration(
                              //color: MyColors.cardBackground,

                                borderRadius: BorderRadius.circular(20),
                                color: AppConfig.myCardColor),
                            child: Center(
                              child: Text(
                                '${index + 1}. ${mnemonics[index]}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ),),



                      SizedBox(height: 20,),

                      Column(

                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Secret Key",style: TextStyle(fontSize: 20),),

                          Row(
                            children: [
                              SizedBox(
                                  width: size.width*.8,
                                  child: Text(key,maxLines: 1,overflow: TextOverflow.ellipsis,)),
                              
                              InkWell(child: Icon(Icons.copy,color: Colors.white,),
                              onTap: (){

                                Clipboard.setData(ClipboardData(text: key));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Wallet Private key copied to clipboard')),
                                );
                              },)
                            ],
                          )
                        ],
                      ),

                     
                    ],
                  )
                ],
              ),
          )
          ,)

        ,),

    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  Future<String?> _getSavedPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    secureStorage = const FlutterSecureStorage();
    return prefs.getString('password');
  }
}
