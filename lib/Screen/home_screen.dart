import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_api_login/Screen/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/auth_services.dart';
import 'package:http/http.dart' as http;
import 'Add/button.dart';
import 'Add/logoutbutton.dart';
import 'edit_category.dart';
import '../components/category.dart';
import '../Services/category_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List listCategory = [];
  String name = '';
  final TextEditingController addCategoryTxt = TextEditingController();

  getCategory() async {
    final response = await AuthServices().getCategories();
    print('respone from kategori');
    print(response);
    var dataResponse = json.decode(response.body);
    setState(
      () {
        var listRespon = dataResponse['data'];
        print(listRespon);
        for (var i = 0; i < listRespon.length!; i++) {
          listCategory.add(
            Category.fromJson(listRespon[i]),
          );
        }
      },
    );
  }

  addCategory() async {
    final name = addCategoryTxt.text;
    final response = await CategoryService().addCategory(name);
    print(response.body);
    // Navigator.pushNamed(context, "/");
    listCategory.clear();
    getCategory();
    addCategoryTxt.clear();
  }

  getUser() async {
    final sharedPref = await SharedPreferences.getInstance();
    setState(
      () {
        const key = 'name';
        final value = sharedPref.get(key);
        name = '$value';
      },
    );
  }

  @override
  void initState() {
    getUser();
    super.initState();
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              logoutPressed();
            },
          )
        ],
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Color.fromARGB(0, 0, 0, 0),
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'List Categories',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(16),
                      child: TextFormField(
                        controller: addCategoryTxt,
                        decoration: InputDecoration(
                          hintText: "Input Your Categories Name",
                          labelText: "Add Categories",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          suffixIcon: Container(
                            margin: const EdgeInsets.fromLTRB(0, 12, 12, 8),
                            child: ElevatedButton(
                              child: const Text("Add"),
                              onPressed: () {
                                addCategory();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                          ),
                        ),
                        child: ListView.builder(
                            itemCount: listCategory.length,
                            itemBuilder: (context, index) {
                              var kategori = listCategory[index];
                              return Dismissible(
                                key: UniqueKey(),
                                background: Container(
                                  color: Color.fromARGB(255, 51, 179, 55),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.create_rounded,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                onDismissed:
                                    (DismissDirection direction) async {
                                  if (direction ==
                                      DismissDirection.startToEnd) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            edit(category: listCategory[index]),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 1,
                                        blurRadius: 9,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18),
                                      child: Text(
                                        kategori.name,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void logoutPressed() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    const key = 'token';
    final value = preferences.get(key);
    setState(
      () {
        preferences.remove('token');
        preferences.clear();
      },
    );

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
      (route) => false,
    );
  }
}
