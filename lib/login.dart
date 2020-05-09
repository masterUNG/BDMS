import 'dart:convert';
import 'package:myapplication/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:myapplication/api_provider.dart';
import 'package:myapplication/login.dart';
import 'dart:async';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _ctrlUsername = TextEditingController();
  TextEditingController _ctrlPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  ApiProvider apiProvider = ApiProvider();

  Future doLogin() async {
    if (_formKey.currentState.validate()) {
      try {
        var rs =
            await apiProvider.doLogin(_ctrlUsername.text, _ctrlPassword.text);
        if (rs.statusCode == 200) {
          print(rs.body);
          var jsonRes = json.decode(rs.body);
          if (jsonRes['ok']) {
            String token = jsonRes['token'];
            print(token);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', token);
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomePage()));
          } else {
            showDialog<Null>(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    children: <Widget>[
                      Text(
                        'ชื่อผู้ใช้งานหรือรหัสผ่านไม่ถูกต้อง',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'ตกลง',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ],
                  );
                });
          }
        } else {
          print('Server error');
        }
      } catch (error) {
        print(error);
      }
    }
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
            SizedBox(
              width: 60.0,
              height: 60.0,
            ),
            Image(
              image: AssetImage('asset/image/LOGO-BDMS.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
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
            Padding(
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
          ],
        ),
      ),
    );
  }
}
