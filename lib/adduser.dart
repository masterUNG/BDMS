import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapplication/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  final String id;
  RegisterPage([this.id]);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _crtUsername = TextEditingController();
  TextEditingController _crtPassword = TextEditingController();
  TextEditingController _crtFullname = TextEditingController();
  TextEditingController _crtEmail = TextEditingController();

  ApiProvider apiProvider = ApiProvider();

  Future saveUser() async {
    if (_formKey.currentState.validate()) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = prefs.getString('token');
        var rs;
        if (widget.id != null) {
          //update
          rs = await apiProvider.updateUser(widget.id, _crtUsername.text,
              _crtPassword.text, _crtFullname.text, _crtEmail.text, token);
        } else {
          rs = await apiProvider.saveUser(_crtUsername.text, _crtPassword.text,
              _crtFullname.text, _crtEmail.text, token);
        }
        if(rs.statusCode == 200){
          print(rs.body);
          var jsonRes = json.decode(rs.body);

          if(jsonRes['ok']){
            Navigator.of(context).pop(true);
          }else{
             print(jsonRes['error']);
          }
        }else{
          print('Server error!');
        }
      } catch (error) {
        print(error);
      }
    } else {}
  }
  Future getInfo() async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');
      String id = widget.id;

      var rs = await apiProvider.getInfo(token, id);

      if(rs.statusCode == 200){
        print('rs.body');
        var jsonRes = json.decode(rs.body);

        if (jsonRes['ok']){
          setState(() {
           _crtUsername.text = jsonRes['info']['username'];
           _crtPassword.text = jsonRes['info']['password'];
            _crtFullname.text = jsonRes['info']['fullname'];
            _crtEmail.text = jsonRes['info']['email'];
          });
        }else{
          print(jsonRes['error']);
        }
      }else{
        print('Server error!!');
      }
    }catch(error){
      print(error);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.id != null) {
      getInfo();
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('REGISTER',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _crtUsername,
                      validator: (value){
                        if(value.isEmpty){
                          return 'กรุณากรอกข้อมูลให้ครบถ้วน';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.account_circle),
                          labelText: 'USERID',
                          hintText: 'ชื่อผู้ใช้งาน',
                          labelStyle: TextStyle(fontSize: 15.0)),
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _crtPassword,
                      validator: (value){
                        if(value.isEmpty){
                          return 'กรุณากรอกข้อมูลให้ครบถ้วน';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.https),
                          labelText: 'PASSWORD',
                          hintText: 'รหัสผ่าน',
                          labelStyle: TextStyle(fontSize: 15.0)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _crtFullname,
                      validator: (value){
                        if(value.isEmpty){
                          return 'กรุณากรอกข้อมูลให้ครบถ้วน';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'FULLNAME',
                          hintText: 'ชื่อ-นามสกุล',
                          labelStyle: TextStyle(fontSize: 15.0)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _crtEmail,
                      validator: (value){
                        if(value.isEmpty){
                          return 'กรุณากรอกข้อมูลให้ครบถ้วน';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: 'EMAIL',
                          hintText: 'อีเมลล์',
                          labelStyle: TextStyle(fontSize: 15.0)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: RaisedButton.icon(
                  textColor: Colors.white,
                  onPressed: () => saveUser(),
                  icon: Icon(Icons.input),
                  label: Text('SAVE',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold))),
            ),
          ],
        ),
      ),
    );
  }
}
