import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:myapplication/api_provider.dart';
import 'package:myapplication/models/user_model.dart';
import 'package:myapplication/page/mainpage.dart';
import 'package:myapplication/page/register.dart';

import 'dart:async';

import 'package:myapplication/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _ctrlUsername = TextEditingController();
  TextEditingController _ctrlPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  ApiProvider apiProvider = ApiProvider();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String string = preferences.getString('id');

      if (string != null || string.isNotEmpty) {
        print('Status Login');
        routeToMainPage();
      }
    } catch (e) {}
  }

  Future<void> doLogin() async {
    if (_formKey.currentState.validate()) {
      String user = _ctrlUsername.text;
      String password = _ctrlPassword.text;
      print('user = $user, password = $password');

      String url =
          'https://www.androidthai.in.th/bhr/getUserWhereUser.php?isAdd=true&username=$user';

      try {
        Response response = await Dio().get(url);
        print('response = $response');

        if (response.toString() == 'null') {
          normalDialog(context, 'User False Please Try Again');
        } else {
          var result = json.decode(response.data);
          print('result = $result');

          for (var map in result) {
            UserModel userModel = UserModel.fromJson(map);
            if (password == userModel.password) {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.setString('id', userModel.id);

              routeToMainPage();
            } else {
              normalDialog(context, 'Password False Please Try Again');
            }
          }
        }
      } catch (e) {}

      // try {
      //   var rs =
      //       await apiProvider.doLogin(_ctrlUsername.text, _ctrlPassword.text);
      //   if (rs.statusCode == 200) {
      //     print(rs.body);
      //     var jsonRes = json.decode(rs.body);
      //     if (jsonRes['ok']) {
      //       String token = jsonRes['token'];
      //       print(token);
      //       SharedPreferences prefs = await SharedPreferences.getInstance();
      //       await prefs.setString('token', token);
      //       Navigator.of(context).pushReplacement(
      //           MaterialPageRoute(builder: (context) => HomePage()));
      //     } else {
      //       showDialog<Null>(
      //           context: context,
      //           builder: (BuildContext context) {
      //             return SimpleDialog(
      //               children: <Widget>[
      //                 Text(
      //                   'ชื่อผู้ใช้งานหรือรหัสผ่านไม่ถูกต้อง',
      //                   style: TextStyle(fontSize: 20.0),
      //                 ),
      //                 SimpleDialogOption(
      //                   onPressed: () {
      //                     Navigator.pop(context);
      //                   },
      //                   child: const Text(
      //                     'ตกลง',
      //                     style: TextStyle(fontSize: 20.0),
      //                   ),
      //                 ),
      //               ],
      //             );
      //           });
      //     }
      //   } else {
      //     print('Server error');
      //   }
      // } catch (error) {
      //   print(error);
      // }
    } // if
  }

  void routeToMainPage() {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => MainPage(),
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bangkok Hospital Rayong',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            mySizebox(),
            showLogo(),
            userForm(),
            passwordForm(),
            loginButton(),
            registerButton(),
          ],
        ),
      ),
    );
  }

  FlatButton registerButton() => FlatButton(
        onPressed: () {
          MaterialPageRoute route = MaterialPageRoute(builder: (context) => Register(),);
          Navigator.push(context, route);
        },
        child: Text('New Register'),
      );

  Widget loginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 250.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: RaisedButton.icon(
              onPressed: () => doLogin(),
              icon: Icon(Icons.input),
              textColor: Colors.white,
              label: Text(
                'LOGIN',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget passwordForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 250.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              style: TextStyle(fontSize: 18.0),
              validator: (value) {
                if (value.isEmpty) {
                  return 'กรุณากรอกรหัสผ่าน';
                }
                return null;
              },
              controller: _ctrlPassword,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.https),
                fillColor: Colors.white,
                filled: true,
                labelText: 'PASSWORD',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget userForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 250.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              style: TextStyle(fontSize: 18.0),
              validator: (value) {
                if (value.isEmpty) {
                  return 'กรุณากรอกID';
                }
                return null;
              },
              controller: _ctrlUsername,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.account_circle),
                fillColor: Colors.white,
                filled: true,
                labelText: 'USERNAME',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget showLogo() {
    return Container(
      width: 100,
      child: Image(
        image: AssetImage('asset/image/LOGO-BDMS.png'),
      ),
    );
  }

  SizedBox mySizebox() {
    return SizedBox(
      width: 60.0,
      height: 60.0,
    );
  }
}
