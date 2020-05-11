import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:myapplication/utility/my_style.dart';
import 'package:myapplication/utility/normal_dialog.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  File file;
  String name, surName, user, password, pathAvatar;
  double lat, lng;

  @override
  void initState() {
    super.initState();
    findLatLng();
  }

  void showToast(String string) {
    Fluttertoast.showToast(
      msg: string,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  Future<void> findLatLng() async {
    LocationData locationData = await findLocationData();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;

      showToast('lat => $lat, lng => $lng');
    });
  }

  Future<LocationData> findLocationData() async {
    var location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      return null;
    }
  }

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
      floatingActionButton: registerButton(),
    );
  }

  FloatingActionButton registerButton() => FloatingActionButton(
        backgroundColor: Colors.purple,
        child: Icon(Icons.cloud_upload),
        onPressed: () {
          if (file == null) {
            normalDialog(context, 'Please Choose Avatar');
          } else if (checkSpace(name) ||
              checkSpace(surName) ||
              checkSpace(user) ||
              checkSpace(password)) {
            normalDialog(context, 'Have Space');
          } else {
            uploadAvatarThread();
          }
        },
      );

  Future<void> uploadAvatarThread() async {
    try {
      Random random = Random();
      int i = random.nextInt(10000);
      String nameImage = 'avatar$i.jpg';
      // print('nameImage = $nameImage');
      String urlSaveFile = 'http://www.androidthai.in.th/bhr/saveFile.php';

      Map<String, dynamic> map = Map();
      map['file'] = await MultipartFile.fromFile(file.path, filename: nameImage);
      // print('pathFile = ${file.path}, ${map.toString()}');
      FormData formData = FormData.fromMap(map);

      await Dio().post(urlSaveFile, data: formData).then((value) {
       
        pathAvatar = 'http://androidthai.in.th/bhr/Avartar/$nameImage';
        registerThread();

      });
    } catch (e) {}
  }

  Future<Null> registerThread() async {
    String url =
        'http://www.androidthai.in.th/bhr/addUser.php?isAdd=true&username=$user&password=$password&name=$name&lastname=$surName&img=$pathAvatar&Lat=$lat&Lng=$lng';
    try {
      Response response = await Dio().get(url);
      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else {
        showToast('Please Try Again');
      }
    } catch (e) {}
  }

  bool checkSpace(String string) {
    return name == null || name.isEmpty;
  }

  Set<Marker> myMarkers() {
    LatLng latLng = LatLng(lat, lng);
    return <Marker>[
      Marker(
        markerId: MarkerId('myLocation'),
        position: latLng,
        infoWindow: InfoWindow(
            title: 'คุณอยู่ที่นี่',
            snippet: 'ละติดจูด = $lat, ลองติจูต = $lng'),
      )
    ].toSet();
  }

  Widget showMap() {
    if (lat == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      LatLng latLng = LatLng(lat, lng);
      CameraPosition cameraPosition = CameraPosition(
        target: latLng,
        zoom: 16.0,
      );

      return Container(
        height: 300.0,
        child: GoogleMap(
          initialCameraPosition: cameraPosition,
          mapType: MapType.normal,
          onMapCreated: (controller) {},
          markers: myMarkers(),
        ),
      );
    }
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
