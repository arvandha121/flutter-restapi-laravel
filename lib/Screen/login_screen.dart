import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_api_login/Screen/register_screen.dart';
import 'package:flutter_api_login/Services/globals.dart';
import 'Add/button.dart';
import 'package:http/http.dart' as http;

import '../Services/auth_services.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

//email controller
final TextEditingController _emailController =
    TextEditingController(text: "superadmin@gmail.com");

//password controller
final TextEditingController _passwordController =
    TextEditingController(text: "password");

class _LoginScreenState extends State<LoginScreen> {
  @override
  String _email = "superadmin@gmail.com";
  String _password = "password";

  loginPressed() async {
    if (_email.isNotEmpty && _password.isNotEmpty) {
      http.Response response = await AuthServices.login(_email, _password);
      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const HomeScreen(),
            ));
      } else {
        errorSnackBar(context, responseMap.values.first);
      }
    } else {
      errorSnackBar(context, 'enter all required fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 249, 248, 248),
        centerTitle: true,
        elevation: 0,
        // title: const Text(
        //   "Login",
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //     fontSize: 22,
        //   ),
        // ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 120,
            ),
            Text(
              "Sign In",
              style: TextStyle(
                fontSize: 25,
                color: Color.fromARGB(255, 0, 106, 255),
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: 'Email',
              ),
              onChanged: (value) {
                _email = value;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
                hintText: 'Password',
              ),
              onChanged: (value) {
                _password = value;
              },
              obscureText: true, //make hide input password key
            ),
            const SizedBox(
              height: 50,
            ),
            Button(
              btnText: 'Login',
              onBtnPressed: () => loginPressed(),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              //make a move to login page
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const RegisterScreen(),
                  ),
                );
              },
              child: const Text(
                "Don't have any account?",
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
