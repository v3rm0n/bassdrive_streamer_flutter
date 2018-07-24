import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final String name;

  const Loader({this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: SafeArea(
          child: Center(
        child: CircularProgressIndicator(),
      )),
    );
  }
}
