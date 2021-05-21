import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:materialquran/controller/quranapi.dart';
import 'dart:convert';

import 'package:materialquran/loader/quranglobal.dart';

// Future<SurahList>? surahList;
// final api = QuranAPICall(domain: "api.alquran.cloud", reqUrl: "v1/surah");
// surahList = api.surahInfoJson();

// Surah Selection Menu
// This page allows users to select a surah
// and redirect the users to another page

SurahSelectionPage() {
  return Scaffold(body: SurahSelectionContainer());
}

class SurahSelectionContainer extends StatefulWidget {
  const SurahSelectionContainer({Key? key}) : super(key: key);

  @override
  _SurahSelectionContainerState createState() =>
      _SurahSelectionContainerState();
}

class _SurahSelectionContainerState extends State<SurahSelectionContainer> {
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

class GenerateHeader extends StatefulWidget {
  final index;

  const GenerateHeader({Key? key, required this.index}) : super(key: key);

  @override
  _GenerateHeaderState createState() => _GenerateHeaderState();
}

class _GenerateHeaderState extends State<GenerateHeader> {
  bool expandFlag = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Material(
              color: Colors.blue,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Text(getSurahName.elementAt(widget.index),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      )),
                  InkWell(
                    onTap: () {
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
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Opacity(
                        opacity: 0.5,
                        child: Text(getSurahName.elementAt(widget.index),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Ink.image(
                        image: AssetImage('assets/img/1.jpg'),
                        fit: BoxFit.cover,
                        child: InkWell(
                          onTap: () => print("Tapped!"),
                          child: Container(
                            height: 100.0,
                          ),
                        ),
                      ),
                    ],
                  )),
              collapsedHeight: 0.0,
              expandedHeight: 100,
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
          decoration:
              BoxDecoration(border: Border.all(width: 1.0, color: Colors.blue)),
        ));
  }
}

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
