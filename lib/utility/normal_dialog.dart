import 'package:flutter/material.dart';

Future<void> normalDialog(BuildContext context, String title) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(title),
      children: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    ),
  );
}
