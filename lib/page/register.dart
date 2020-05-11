import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapplication/utility/my_style.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  File file;
  String name, surName, user, password, lat, lng, pathAvatar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: ListView(
        padding: EdgeInsets.all(30.0),
        children: <Widget>[
          showAvatar(),
          MyStyle().mySizeBox,
          nameForm(),
          MyStyle().mySizeBox,
          surNameForm(),
          MyStyle().mySizeBox,
          userForm(),
          MyStyle().mySizeBox,
          passwordForm(),
          MyStyle().mySizeBox,
          showMap(),
        ],
      ),
    );
  }

  Widget showMap() {
    double lat = 13.683543, lng = 100.591800;

    LatLng latLng = LatLng(lat, lng);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );

    return Container(
      height: 150.0,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
      ),
    );
  }

  Widget showAvatar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
            icon: Icon(
              Icons.add_a_photo,
              size: 36.0,
            ),
            onPressed: () => chooseImage(ImageSource.camera)),
        Container(
          height: 150.0,
          width: MediaQuery.of(context).size.width - 160,
          child: file == null
              ? Image.asset('asset/image/avatar.png')
              : Image.file(file),
        ),
        IconButton(
            icon: Icon(
              Icons.add_photo_alternate,
              size: 36.0,
            ),
            onPressed: () => chooseImage(ImageSource.gallery)),
      ],
    );
  }

  Future<void> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker.pickImage(
        source: source,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );
      setState(() {
        file = object;
      });
    } catch (e) {}
  }

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => name = value.trim(),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.face),
                labelText: 'Name :',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget surNameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => surName = value.trim(),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.supervisor_account),
                labelText: 'Surname :',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget userForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => user = value.trim(),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.account_box),
                labelText: 'User :',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget passwordForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => password = value.trim(),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: 'Password :',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
}
