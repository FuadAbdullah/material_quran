import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:materialquran/controller/quranapi.dart';
import 'package:materialquran/loader/quranglobal.dart';
import 'package:materialquran/ui/homepage.dart';
import 'package:materialquran/ui/surahpage.dart';

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
      home: MainMenu(),
    );
  }
}

// Main Menu
// This page is the first menu
// a user will encounter
// All buttons leading to different
// pages are found here
class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}

// Surah Selection Menu
// This page allows users to select a surah
// and redirect the users to another page
class SurahSelectionMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SurahSelectionPage();
  }
}

// Surah Reader Menu
// This page displays the selected surah in full
// There are plans to segregate long surah into pages
class SurahReaderMenu extends StatelessWidget {
  const SurahReaderMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
