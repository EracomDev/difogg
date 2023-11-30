import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:difog/screens/app_layout.dart';
import 'package:difog/screens/wallet.dart';

import '../utils/app_config.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  String? _errorText;
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<String?> _getSavedPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('password');
  }

  Future<void> _savePassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', password);


    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Password reset successfully!'),
    ));

    if(Navigator.canPop(context)){

      Navigator.pop(context);
    }


  }

  void _resetPassword() async {
    String? savedPassword = await _getSavedPassword();
    String oldPassword = _oldPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (oldPassword != savedPassword) {
      setState(() {
        _errorText = 'Incorrect old password.';
      });
      return;
    }

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _errorText = 'Please enter both new password and confirm password.';
      });
      return;
    }

    // Regex pattern for alphanumeric characters and special characters
    RegExp passwordPattern =
    RegExp(r'^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$');

    if (!passwordPattern.hasMatch(newPassword)) {
      setState(() {
        _errorText =
        'Password should contain at least 6 characters, one letter, one number, and one special character.';
      });
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() {
        _errorText = 'New passwords do not match.';
      });
      return;
    }

    _savePassword(newPassword);
    /*Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CryptoWalletDashboard(),
      ),
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: AppConfig.titleIconAndTextColor, //change your color here
          ),
          backgroundColor: AppConfig.titleBarColor,



          elevation: 0,

          automaticallyImplyLeading: true,

          title: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [


                Text("",
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
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView( // Add SingleChildScrollView here
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Image.asset(
                  AppConfig.appLogo, // Replace with your image path
                  height: 80,
                  width: 80,
                ),
                SizedBox(height: 16.0),

                Text("Reset Password",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.normal,
                      color: AppConfig.titleIconAndTextColor,
                    )),

                SizedBox(height: 16.0),
                TextFormField(
                  controller: _oldPasswordController,
                  obscureText: _obscureOldPassword,
                  decoration: InputDecoration(
                    labelText: 'Old Password',
                    suffixIcon: IconButton(
                      icon: Icon(_obscureOldPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureOldPassword = !_obscureOldPassword;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscureNewPassword,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    suffixIcon: IconButton(
                      icon: Icon(_obscureNewPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.0),

                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  _errorText ?? '',
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 16.0),
                Row(

                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      decoration: BoxDecoration(gradient:

                      AppConfig.buttonGradient,borderRadius: BorderRadius.circular(20)

                      ),
                      child: ElevatedButton(
                        onPressed: _resetPassword,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                        child: Text('Reset Password',style: TextStyle(color: AppConfig.titleIconAndTextColor),),
                      ),
                    )

                    /*ElevatedButton(
                      onPressed: _resetPassword,
                      child: Text('Reset Password'),
                    ),*/
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
