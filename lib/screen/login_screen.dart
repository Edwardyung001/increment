import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../database/create_db.dart';
import '../service/userService.dart';
import '../widgets/custom_textfield.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _userService = userService();
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isFormValid = false;

  logionFunction() async {
    String inputUserName = userName.text;
    String inputPassword = password.text;

    bool userExists = await _userService.doesUserExist(inputUserName);
    if (userExists) {
      print('Username already exists. Please use a different username.');
    } else {
      var login = Login(
        userName: inputUserName,
        password: inputPassword,
      );
      var result = await _userService.saveUserDetails(login);
      print('User saved: $result');
      print('New user registered successfully.');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    userName: inputUserName,
                  )));
    }
    var existingUser = await _userService.getUserByUsername(inputUserName);
    if (existingUser == null) {
      print('Username not found. Please register first.');
    } else if (existingUser.password == inputPassword) {
      print('Login successful!');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    userName: inputUserName,
                  )));
    } else {
      print('Password is incorrect. Please try again.');
    }
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    userName.addListener(_validateForm);
    password.addListener(_validateForm);
  }
  void _validateForm() {
    setState(() {
      isFormValid = userName.text.isNotEmpty && password.text.isNotEmpty;
    });
  }
  @override
  void dispose() {
    userName.dispose();
    password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold is placed within MaterialApp
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Image.asset('assets/images/login_image.jpg')),
            SizedBox(height: 20),
            CustomTextField(
              controller: userName,
              labelText: 'Email',
              prefixIcon: Icons.email,
            ),
            SizedBox(height: 10),
            CustomTextField(
              controller: password,
              labelText: 'Password',
              prefixIcon: Icons.lock,
              obscureText: true,
            ),
            SizedBox(height: 20),
            Container(
              width: 200,
              child:ElevatedButton(
                onPressed: isFormValid ? () { logionFunction(); } : null,
                child: Text(
                  'Login',
                  style: TextStyle(color: isFormValid ? Colors.white : Colors.grey),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: isFormValid ? Colors.blueAccent : Colors.grey,
                  backgroundColor: isFormValid ? Colors.blueAccent : Colors.grey[300],
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: isFormValid ? Colors.blueAccent : Colors.grey),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),

          ],
        ),
      ),
    );
  }
}
