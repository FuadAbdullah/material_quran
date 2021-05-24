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
    var reqUrl = "v1/surah/$indexID/ar.alafasy";
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

  // FOR DEBUG PURPOSE ONLY
  void test(BuildContext context) {
    print(SurahReaderPage.of(context).indexID);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder<Surah>(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // return Text(snapshot.data.text);
                return Expanded(
                  child: Scrollbar(
                    isAlwaysShown: true,
                    hoverThickness: 20.0,
                    thickness: 10.0,
                    radius: Radius.circular(2.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        for (int i = 0; i < snapshot.data!.numberOfAyat; i++)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                20.0, 10.0, 20.0, 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade300,
                                        spreadRadius: 1.0)
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    20.0, 10.0, 20.0, 10.0),
                                child: RichText(
                                  text: TextSpan(
                                      style: fontStyling("Me Quran"),
                                      children: [
                                        TextSpan(
                                          text: "${snapshot.data!.verses[i]['text']}" +
                                              " \uFD3F" +
                                              "${getArabicNumber((i + 1).toString())}" +
                                              "\uFD3E",
                                        ),
                                        // WidgetSpan(
                                        //     child: Padding(
                                        //         padding:
                                        //             const EdgeInsets.symmetric(
                                        //                 horizontal: 2.0,
                                        //                 vertical: 10.0),
                                        //         child: Icon(Icons.star)))
                                      ]),
                                  textAlign: TextAlign.right,
                                  softWrap: true,
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
            future: SurahReaderPage.of(context).futureSurah,
          ),
        ],
      ),
    );
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
