import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/app_config.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

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
                "Setup Profile Info",
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

        child: Column(children: [

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



                Padding(padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 32.0),
                  child: Column(
                    children: [



                      const SizedBox(height: 10),

                      SizedBox(
                        width: size.width*0.85,
                        child: TextFormField(
                          controller:  fullNameController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            contentPadding: const  EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
                            labelText: "Full Name*",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(top: 0), // add padding to adjust icon
                              child:Icon(CupertinoIcons.person),
                            ),
                            /*fillColor: Colors.green.withOpacity(0.10),
                                      filled: true,*/

                          ),
                          validator: (value){
                            if(value!.isEmpty){
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
                        width: size.width*0.85,
                        child: TextFormField(
                          controller: mobileController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          decoration: InputDecoration(
                            contentPadding: const  EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
                            labelText: "Mobile Number*",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),

                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(top: 0), // add padding to adjust icon
                              child:Icon(CupertinoIcons.phone),
                            ),

                          ),

                          validator: (value){
                            if(value!.isEmpty){
                              return "Mobile Number cannot be empty";
                            } /*else if(value.length!=10){
                                        return "Mobile Number length should be 10";
                                      }*/

                            else if((value.toString().contains(" "))) {
                              return "No space allowed inside mobile number";
                            }else {
                              mobile = value.toString();
                              return null;
                            }
                          },


                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: size.width*0.85,
                        child: TextFormField(
                          controller:  emailController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            contentPadding: const  EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
                            labelText: "Email*",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),

                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(top: 0), // add padding to adjust icon
                              child:Icon(CupertinoIcons.mail),
                            ),

                          ),

                          validator: (value){
                            if(value!.isEmpty){
                              return "Email cannot be empty";
                            } else if(!validation(value)) {
                              return "Email error";
                            } else if((value.toString().contains(" "))) {
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

                          width: size.width*0.85,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white,width: 1),
                              color: Color(0x1F4C779B),

                              borderRadius: BorderRadius.all(Radius.circular(20))),
                          child: Row(
                            children: [
                              Text(selectedCountry,style: TextStyle(color: Colors.white,fontSize: 16),),
                              Spacer(),
                              Icon(Icons.arrow_drop_down_sharp,color: Colors.white,)
                            ],
                          ),
                        ),
                        onTap: (){

                          showCountryPicker(
                            context: context,
                            //favorite: ,
                            countryListTheme: CountryListThemeData(backgroundColor: AppConfig.background,
                                textStyle: TextStyle(color: Colors.white)),
                            showPhoneCode: true, // optional. Shows phone code before the country name.
                            onSelect: (Country country) {
                              setState(() {
                                selectedCountry=country.name;
                                countryCode = "+"+country.phoneCode.toString();
                              });
                              print('Select country: ${country.name}');
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 10,),

                      const SizedBox(height: 20),

                      isShowingProgress? Column(

                        children: const <Widget>[
                          CircularProgressIndicator(),

                          SizedBox(height: 20,),
                          Text("Please wait...."),
                        ],
                      ):SizedBox(
                        width: size.width*0.85,
                        height: size.height*0.06,
                        child: ElevatedButton(onPressed:(){

                          if(formkey.currentState!.validate()){

                            if (selectedCountry=="Select country"){
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text("Please select country first."),
                              ));
                            }else {


                              //isShowingProgress = true;
                              //_registerAccount();

                              print("name= $name");

                              print("email= $email");
                              print("mobile= $mobile");

                            }

                          }

                          setState(() {

                          });


                        },
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(AppConfig.primaryColor),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(color:AppConfig.primaryColor)
                                )
                            )

                            ,), child:const  Text("Submit Detail"),
                        ),
                      ),



                    ],
                  ),
                ),


              ],
            ),
          ),
        ],),
      ),
    );
  }


  bool validation(String email){

    bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(email);
    return emailValid;
  }

  @override
  void initState() {
    // TODO: implement initState


    super.initState();
  }
}
