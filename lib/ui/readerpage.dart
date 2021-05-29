import 'package:flutter/material.dart';
import 'package:materialquran/controller/quranapi.dart';
import 'package:materialquran/loader/quranglobal.dart';

// Surah Reader Menu
// This page displays the selected surah in full
// There are plans to segregate long surah into pages

class SurahReaderPage extends StatefulWidget {
  final Widget child;

  const SurahReaderPage(
      {Key? key, required this.selectedSurahIndex, required this.child})
      : super(key: key);

  static _SurahReaderPageState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedIndex>()!.data;
  }

  // There should be a simpler way of passing this value
  final selectedSurahIndex;

  @override
  _SurahReaderPageState createState() => _SurahReaderPageState();
}

class _SurahReaderPageState extends State<SurahReaderPage> {
  Future<Surah>? futureSurah;

  int get indexID => widget.selectedSurahIndex;

  String get surahTitle => getSurahName.elementAt(indexID - 1);

  String get surahTitleEn => getSurahNameEn.elementAt(indexID - 1);

  @override
  void initState() {
    super.initState();
    loadSequence();
  }

  void loadSequence() {
    const domain = "api.alquran.cloud";
    var reqUrl = "v1/surah/$indexID";
    final api = QuranAPICall();
    api.setDomain = domain;
    api.setReqUrl = reqUrl;
    api.setExcludedText = "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيم";
    api.setSelectedSurah = indexID;
    futureSurah = api.loadSurah();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(surahTitle + " | " + surahTitleEn),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: InheritedIndex(
          child: widget.child,
          data: this,
        ));
  }
}

class SurahReaderContainer extends StatelessWidget {
  const SurahReaderContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SurahPageBuilder();

    //   Container(
    //   alignment: Alignment.center,
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       FutureBuilder<Surah>(
    //         builder: (context, snapshot) {
    //           if (snapshot.hasData) {
    //             return Expanded(
    //               child: Scrollbar(
    //                 isAlwaysShown: true,
    //                 hoverThickness: 20.0,
    //                 thickness: 10.0,
    //                 radius: Radius.circular(2.0),
    //                 child: ListView(
    //                   shrinkWrap: true,
    //                   children: <Widget>[
    //                     for (int i = 0; i < snapshot.data!.numberOfAyat; i++)
    //                       Padding(
    //                         padding: const EdgeInsets.fromLTRB(
    //                             20.0, 10.0, 20.0, 10.0),
    //                         child: Container(
    //                           decoration: BoxDecoration(
    //                               borderRadius: BorderRadius.circular(12.0),
    //                               boxShadow: [
    //                                 BoxShadow(
    //                                     color: Colors.grey.shade300,
    //                                     spreadRadius: 1.0)
    //                               ]),
    //                           child: Padding(
    //                             padding: const EdgeInsets.fromLTRB(
    //                                 20.0, 10.0, 20.0, 10.0),
    //                             child: RichText(
    //                               text: TextSpan(
    //                                   style: fontStyling("Me Quran"),
    //                                   children: [
    //                                     TextSpan(
    //                                       text: "${snapshot.data!.verses[i]['text']}" +
    //                                           " \uFD3F" +
    //                                           "${getArabicNumber((i + 1).toString())}" +
    //                                           "\uFD3E",
    //                                     ),
    //                                   ]),
    //                               textAlign: TextAlign.right,
    //                               softWrap: true,
    //                               textDirection: TextDirection.rtl,
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                   ],
    //                 ),
    //               ),
    //             );
    //           } else if (snapshot.hasError) {
    //             return Text("${snapshot.error}");
    //           }
    //           return CircularProgressIndicator();
    //         },
    //         future: SurahReaderPage.of(context).futureSurah,
    //       ),
    //     ],
    //   ),
    // );
  }
}

class SurahPageBuilder extends StatefulWidget {
  const SurahPageBuilder({Key? key}) : super(key: key);

  @override
  _SurahPageBuilderState createState() => _SurahPageBuilderState();
}

class _SurahPageBuilderState extends State<SurahPageBuilder> {
  double? _focusedIndex = 0;
  int? _pageCount;
  ScrollController? _scrollController;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _initScrollController();
    _initPageController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pageCount = getSurahNumAyahs[SurahReaderPage.of(context).indexID - 1];
  }

  void _initScrollController() {
    _scrollController = ScrollController(keepScrollOffset: true);
  }

  void _initPageController() {
    _pageController =
        PageController(viewportFraction: 1.0, keepPage: true, initialPage: 0);
    _pageController!.addListener(() {
      _pageControllerListener();
    });
  }

  void _pageControllerListener() {
    setState(() {
      _focusedIndex = _pageController!.page;
    });
  }

  void _nextPage() {
    if (_focusedIndex! < _pageCount! - 1) {
      setState(() {
        _focusedIndex = _focusedIndex! + 1;
        _pageController!.jumpToPage(_focusedIndex!.toInt());
      });
    }
  }

  void _prevPage() {
    if (_focusedIndex! > 0) {
      setState(() {
        _focusedIndex = _focusedIndex! - 1;
        _pageController!.jumpToPage(_focusedIndex!.toInt());
      });
    }
  }

  Widget _pageContent(snapshot, index) {
    return Container(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Scrollbar(
              controller: _scrollController,
              child: ListView(
                children: [
                  Container(
                      child: Card(
                        color: Colors.white70,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              width: MediaQuery.of(context).size.width,
                              child: RichText(
                                text: TextSpan(
                                    style: fontStyling("Me Quran"),
                                    children: [
                                      TextSpan(
                                        text: "${snapshot.data!.verses[index]['text']}" +
                                            " \uFD3F" +
                                            "${getArabicNumber((index + 1).toString())}" +
                                            "\uFD3E",
                                      ),
                                    ]),
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            )));
  }

  Widget _pageBuilder() {
    return FutureBuilder<Surah>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return PageView.builder(
            controller: _pageController,
            itemBuilder: (context, index) {
              return _pageContent(snapshot, index);
            },
            pageSnapping: true,
            scrollDirection: Axis.horizontal,
            itemCount:
                getSurahNumAyahs[SurahReaderPage.of(context).indexID - 1],
          );
        } else if (snapshot.hasError) {
          return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("${snapshot.error}"),
                ],
              ));
        }
        return Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            ));
      },
      future: SurahReaderPage.of(context).futureSurah,
    );
  }

  Widget _bottomNavBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed: () {
            _prevPage();
          },
          icon: Icon(Icons.arrow_back_ios_rounded),
        ),
        Text(
            "${_focusedIndex!.toInt() + 1}/${getSurahNumAyahs[SurahReaderPage.of(context).indexID - 1]}"),
        IconButton(
          onPressed: () {
            _nextPage();
          },
          icon: Icon(Icons.arrow_forward_ios_rounded),
        ),
      ],
    );
  }

  Widget _mainScreen() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(child: Container(child: _pageBuilder())),
          Container(height: 50, child: _bottomNavBar()),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController!.removeListener(_pageControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _mainScreen();
  }
}

fontStyling(font) {
  return TextStyle(
      fontFamily: "$font",
      fontWeight: FontWeight.normal,
      fontSize: 28,
      color: Colors.black);
}

class InheritedIndex extends InheritedWidget {
  final _SurahReaderPageState data;

  InheritedIndex({Key? key, required this.data, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
