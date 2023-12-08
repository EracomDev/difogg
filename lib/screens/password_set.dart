import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes.dart';
import '../utils/app_config.dart';
import 'app_layout.dart';
import 'create_wallet_screen.dart';

class SetPasswordPage extends StatefulWidget {
  @override
  _SetPasswordPageState createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  String? _errorText;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _savePassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', password);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => CreateWalletScreen()));
  }

  void _validatePassword() {
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _errorText = 'Please enter both password and confirm password.';
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _errorText = 'Password should be at least 6 characters long.';
      });
      return;
    }

    // Regex pattern for alphanumeric characters and special characters
    RegExp passwordPattern =
        RegExp(r'^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$');

    if (!passwordPattern.hasMatch(password)) {
      setState(() {
        _errorText =
            'Password should contain at least 6 characters, one letter, one number, and one special character.';
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _errorText = 'Passwords do not match.';
      });
      return;
    }

    _savePassword(password);
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            // Wrap with ListView
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    AppConfig.appLogo, // Replace with your image path
                    height: 80,
                    width: 80,
                  ),
                  SizedBox(height: 16.0),
                  Text("Set Password",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppConfig.titleIconAndTextColor,
                      )),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
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
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: AppConfig.buttonGradient,
                        borderRadius: BorderRadius.circular(20)),
                    child: ElevatedButton(
                      onPressed: _validatePassword,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent),
                      child: Text(
                        'Save Password',
                        style:
                            TextStyle(color: AppConfig.titleIconAndTextColor),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
