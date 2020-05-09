import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myapplication/adduser.dart';
import 'package:myapplication/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiProvider apiProvider = ApiProvider();
  List users =[];

  Future getUsers() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');
      try{
        var rs = await apiProvider.getUsers(token);
        if(rs.statusCode == 200) {
          print(rs.body);
          var jsonRes = json.decode(rs.body);
          if(jsonRes['ok']){
             setState(() {
               users = jsonRes['rows'];
             });
          }else{
            print(jsonRes['error']);
          }
        }else{
          print('Server error');
        }
    } catch(error) {
        print(error);
      }
  }

  Future removeUser(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    try {
      var rs = await apiProvider.removeUser(token, id);
      if (rs.statusCode == 200) {
        print(rs.body);
        var jsonRes = json.decode(rs.body);
        if (jsonRes['ok']) {
          getUsers();
        } else {
          print(jsonRes['error']);
        }
      } else {
        print('Server error!');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();

    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text(
          'Bangkok Hospital Rayong',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: IconButton(
                icon: Icon(Icons.group_add, size: 30.0, color: Colors.white,),
                onPressed: () async {
                  var res= await Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterPage(),fullscreenDialog: true));
                  if(res){
                    getUsers();
                  }
                }),
          )
        ],
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          var user = users[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0)),
              child: ListTile(
                  onTap: () async {
                    var res = await Navigator.of(context).push(MaterialPageRoute(
                     builder: (context) => RegisterPage(user['id'].toString()), fullscreenDialog: true
                     )
                    );
                     if(res){
                      getUsers();
                     }else{
                       return null;
                     }
                  },
                  title: Text(user['fullname'],
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                  subtitle: Text(user['email'],
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('ยื่นยันรายการ'),
                              content: Text('คุณต้องการลบรายการนี้ใช้หรือไม่'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('ใช้'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    removeUser(user['id'].toString());
                                  },
                                ),
                                FlatButton(
                                  child: Text('ไม่ใช่'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            );
                          });
                    },
                  )
              ),
            ),
          );
        },
        //separatorBuilder: (context, index)=> Divider(),
        itemCount: users.length,
      ),
    );
  }
}
