import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myapplication/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String idLogin;
  UserModel userModel;

  @override
  void initState() {
    super.initState();
    findLogin();
  }

  Future<Null> findLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idLogin = preferences.getString('id');

    String url =
        'http://www.androidthai.in.th/bhr/getUserWhereId.php?isAdd=true&id=$idLogin';

    Response response = await Dio().get(url);
    var result = json.decode(response.data);
    for (var map in result) {
      setState(() {
        userModel = UserModel.fromJson(map);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: buildDrawer(),
    );
  }

  Drawer buildDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: userModel == null
                  ? Image.asset('asset/image/avatar.png')
                  : Image.network(userModel.img),
              accountName: showName(),
              accountEmail: Text('Login'),
            ),
            menuSignOut(),
          ],
        ),
      );

  Text showName() {
    return Text(userModel == null ? 'Name' : userModel.name);
  }

  Future<void> processSignOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear().then((value) {
      MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => LoginPage(),
      );
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    });
  }

  ListTile menuSignOut() => ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text('Sign Out'),
        subtitle: Text('Sign Out and Go Home'),
        onTap: () => processSignOut(),
      );
}
