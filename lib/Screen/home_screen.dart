import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_api_login/Screen/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/auth_services.dart';
import 'package:http/http.dart' as http;
import 'Add/button.dart';
import 'Add/logoutbutton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),

        // padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(15.0),
              width: 150,
              height: 50,
              child: ElevatedButton(
                onPressed: logoutPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Background color
                ),
                child: Text('Logout'),
              ),
            ),

            // Text("Home Screen"),
            // LogoutButton(
            //   btnText: 'Logout',
            //   onBtnPressed: () => logoutPressed(),
            // ),
          ],
        ),
      ),
    );
  }

  void logoutPressed() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    const key = 'token';
    final value = preferences.get(key);
    setState(() {
      preferences.remove('token');
      preferences.clear();
    });

    final token = '$value';
    // print(token);
    http.Response response = await AuthServices.logout(token);
    print(response.body);
    // final response = await AuthServices().logout(token);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const LoginScreen(),
        ),
        (route) => false);

    // http.Response response = await AuthServices.logout();

    // if (response.statusCode != 204) {
    //   // ignore: use_build_context_synchronously
    //   Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (BuildContext context) => const LoginScreen(),
    //     ),
    //     (route) => true,
    //   );
    // }
    // else {
    //   // ignore: use_build_context_synchronously
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (BuildContext context) => const HomeScreen(),
    //     ),
    //   );
    // }
  }
}
