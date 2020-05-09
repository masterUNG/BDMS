import 'package:flutter/material.dart';
import 'package:myapplication/adduser.dart';
import 'package:myapplication/login.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'ThaiSansNeue',
          primaryColor: Color(0xFF4B26F3),
          buttonColor: Color(0xFF4A47E9),
          accentColor: Colors.transparent),
      title: 'Bangkok Hospital Rayong',
      home: LoginPage(),
    );
  }
}
