import 'package:flutter/material.dart';
import 'package:materialquran/ui/homepage.dart';
import 'loader/quranglobal.dart';

void main() => runApp(InitApp());

// Initializer
class InitApp extends StatefulWidget {
  const InitApp({Key? key}) : super(key: key);

  @override
  _InitAppState createState() => _InitAppState();
}

class _InitAppState extends State<InitApp> {

  @override
  void initState() {
    super.initState();
    getLocalQuranInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Material Quran",
      home: HomePage(),
    );
  }
}
