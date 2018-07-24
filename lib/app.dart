import 'package:bassdrive_streamer/home.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Bassdrive Streamer',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Home(title: 'Bassdrive Streamer'),
    );
  }
}
