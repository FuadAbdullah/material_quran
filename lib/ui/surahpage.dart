import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:materialquran/controller/quranapi.dart';
import 'package:materialquran/controller/routes.dart';
import 'dart:convert';

import 'package:materialquran/loader/quranglobal.dart';

// Future<SurahList>? surahList;
// final api = QuranAPICall(domain: "api.alquran.cloud", reqUrl: "v1/surah");
// surahList = api.surahInfoJson();

// Surah Selection Menu
// This page allows users to select a surah
// and redirect the users to another page

class SurahSelectionPage extends StatefulWidget {
  const SurahSelectionPage({Key? key}) : super(key: key);

  @override
  _SurahSelectionPageState createState() => _SurahSelectionPageState();
}

class _SurahSelectionPageState extends State<SurahSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SurahSelectionContainer());
  }
}

class SurahSelectionContainer extends StatelessWidget {
  const SurahSelectionContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Scrollbar(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 100.0,
                leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_ios)),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                    for (int i = 0; i < getSurahNo.length; i++)
                      GenerateHeader(
                        index: i,
                      )
                  ]))
            ],
          ),
        ));
  }
}

class GenerateHeader extends StatefulWidget {
  final index;

  const GenerateHeader({Key? key, required this.index}) : super(key: key);

  @override
  _GenerateHeaderState createState() => _GenerateHeaderState();
}

class _GenerateHeaderState extends State<GenerateHeader> {
  bool expandFlag = false;

  Future<dynamic> loadSurah(BuildContext context) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SurahReaderMenu(
                  selectedSurahIndex: widget.index + 1,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Material(
              color: Colors.blue,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 12.0),
                    child: Text(getSurahName.elementAt(widget.index),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  InkWell(
                    onTap: () => loadSurah(context),
                    onLongPress: () {
                      setState(() {
                        expandFlag = !expandFlag;
                      });
                    },
                    child: Container(
                      height: 100.0,
                    ),
                  ),
                ],
              )),
          ExpandableContainer(
              child: Material(
                color: Colors.blue,
                child: SingleChildScrollView(
                    child: Stack(
                  children: <Widget>[
                    Ink.image(
                      image: AssetImage('assets/img/1.jpg'),
                      fit: BoxFit.cover,
                      child: InkWell(
                        onTap: () => print("Tapped!"),
                        child: Container(
                          height: 300.0,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Opacity(
                                      opacity: 0.8,
                                      child: Text(
                                          getSurahNameAr
                                              .elementAt(widget.index),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Me Quran",
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.normal,
                                          )),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Opacity(
                                      opacity: 0.8,
                                      child: Text(
                                          getSurahNameEn
                                              .elementAt(widget.index),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 26.0,
                                            fontWeight: FontWeight.normal,
                                          )),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.all(12.0),
                                    child: Opacity(
                                      opacity: 0.95,
                                      child: Text(
                                          getSurahDescEn
                                              .elementAt(widget.index),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                              fontStyle: FontStyle.italic)),
                                    ),
                                  ),
                                ])
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Spacer(
                                flex: 10,
                              ),
                              ElevatedButton(
                                  onPressed: () => loadSurah(context),
                                  child: Text("Read Surah")),
                              Spacer(
                                flex: 1,
                              ),
                            ])
                      ],
                    ),
                  ],
                )),
              ),
              collapsedHeight: 0.0,
              expandedHeight: 300.0,
              isExpanded: expandFlag)
        ],
      ),
    );
  }
}

class ExpandableContainer extends StatelessWidget {
  final bool isExpanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;

  ExpandableContainer(
      {required this.child,
      required this.collapsedHeight,
      required this.expandedHeight,
      required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        width: screenWidth,
        height: isExpanded ? expandedHeight : collapsedHeight,
        child: Container(
          child: child,
        ));
  }
}

//
// SurahSelectionContainer(ctx) {
//   return Container(
//       alignment: Alignment.center,
//       child: Scrollbar(
//         child: CustomScrollView(
//           slivers: [
//             SliverAppBar(
//               expandedHeight: 100.0,
//               leading: IconButton(
//                   onPressed: () => Navigator.pop(ctx),
//                   icon: Icon(Icons.arrow_back_ios)),
//             ),
//             SliverList(
//                 delegate: SliverChildListDelegate([
//               for (int i = 0; i < getSurahNo.length; i++) GenerateHeader(i)
//             ]))
//           ],
//         ),
//       ));
// }

// return Material(
//     color: Colors.blue,
//     child: Stack(
//       alignment: Alignment.center,
//       children: <Widget>[
//         Opacity(
//           opacity: 0.5,
//           child: Text(getSurahName.elementAt(i),
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 30.0,
//                 fontWeight: FontWeight.bold,
//               )),
//         ),
//         InkWell(
//           onTap: () => print("Tapped!"),
//           child: Container(
//             height: 100.0,
//           ),
//         ),
//       ],
//     ));

// return Card(
//   margin: const EdgeInsets.all(0.0),
//   child: Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: ExpansionTile(
//       backgroundColor: Colors.white,
//       title: Text("Test Tile"),
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             children: <Widget>[
//               Text("Hello Welcome"),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             children: <Widget>[Text("yes Yes")],
//           ),
//         )
//       ],
//     ),
//   ),
// );

// final rnd = Random().nextInt(14);
// int index = rnd == 0 ? 1 : rnd;
//
// return Material(
// color: Colors.blue,
// child: Stack(
// alignment: Alignment.center,
// children: <Widget>[
// Opacity(
// opacity: 0.5,
// child: Text(getSurahName.elementAt(i),
// style: TextStyle(
// color: Colors.white,
// fontSize: 30.0,
// fontWeight: FontWeight.bold,
// )),
// ),
// Ink.image(
// image: AssetImage('assets/img/$index.jpg'),
// fit: BoxFit.cover,
// child: InkWell(
// onTap: () => print("Tapped!"),
// child: Container(
// height: 100.0,
// ),
// ),
// ),
// ],
// ));
