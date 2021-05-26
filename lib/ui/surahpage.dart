import 'package:flutter/material.dart';
import 'package:materialquran/loader/quranglobal.dart';
import 'package:materialquran/ui/readerpage.dart';

// Surah Selection Menu
// This page allows users to select a surah
// and redirect the users to another page

class SurahSelectionPage extends StatelessWidget {
  final fromNavBar;
  const SurahSelectionPage({Key? key, required this.fromNavBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SurahSelectionContainer(fromNavBar: fromNavBar,));
  }
}

class SurahSelectionContainer extends StatefulWidget {
  // Dirty passing. Can apply InheritedWidget
  final fromNavBar;
  const SurahSelectionContainer({Key? key, required this.fromNavBar}) : super(key: key);

  @override
  _SurahSelectionContainerState createState() =>
      _SurahSelectionContainerState();
}

class _SurahSelectionContainerState extends State<SurahSelectionContainer> {
  int size = 10;

  bool _updateView(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (notification.metrics.extentAfter == 0) {
        updateSize();
      }
    }
    return false;
  }

  void updateSize() {
    if (size < 114) {
      setState(() {
        if (size + 10 > 114) {
          size += 4;
        } else if (size + 10 <= 114) {
          size += 10;
        }
      });
      print(size);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  enableAppBar() {
    if (widget.fromNavBar) {
      return SliverList(delegate: SliverChildListDelegate([]));
    } else {
      return SliverAppBar(
        flexibleSpace: FlexibleSpaceBar(
          title: Text("Surah | Chapters"),
          centerTitle: true,
        ),
        expandedHeight: 100.0,
        floating: true,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: NotificationListener<ScrollNotification>(
          onNotification: _updateView,
          child: Scrollbar(
            child: CustomScrollView(
              slivers: [
                enableAppBar(),
                SliverList(
                    delegate: SliverChildListDelegate([
                  for (int i = 0; i < size; i++) GenerateHeader(index: i)
                ]))
              ],
            ),
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
            builder: (context) => SurahReaderPage(
                selectedSurahIndex: widget.index + 1,
                child: SurahReaderContainer())));
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
                            mainAxisAlignment: MainAxisAlignment.end,
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
