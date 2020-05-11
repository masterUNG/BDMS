import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../login.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
            menuSignOut(),
          ],
        ),
      );

  Future<void> processSignOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear().then((value){
      MaterialPageRoute route = MaterialPageRoute(builder: (context) => LoginPage(),);
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
