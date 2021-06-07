import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:materialquran/controller/quranapi.dart';
import 'package:materialquran/controller/reciteapi.dart';
import 'package:materialquran/loader/quranglobal.dart';

// Surah Reader Menu
// This page displays the selected surah in full
// There are plans to segregate long surah into pages

class SurahReaderPage extends StatefulWidget {
  const SurahReaderPage({Key? key, required this.selectedSurahIndex})
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
          child: SurahPageBuilder(),
          data: this,
        ));
  }
}

class SurahPageBuilder extends StatefulWidget {
  const SurahPageBuilder({Key? key}) : super(key: key);

  @override
  _SurahPageBuilderState createState() => _SurahPageBuilderState();
}

class _SurahPageBuilderState extends State<SurahPageBuilder> {
  double? _focusedIndex = 0;
  int? _pickerNum = 0;
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

  void _pickerSetPage() {
    setState(() {
      _pageController!.jumpToPage(_pickerNum!);
    });
    Navigator.of(context).pop(context);
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
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height -
                              (AppBar().preferredSize.height + 100)),
                      child: Card(
                        color: Colors.white70,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(16.0),
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
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Divider(
                                color: Colors.black12,
                                thickness: 2.0,
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
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => _cupertinoDialog(),
              child: Icon(Icons.mic),
            ),
            body: PageView.builder(
              controller: _pageController,
              itemBuilder: (context, index) {
                return _pageContent(snapshot, index);
              },
              pageSnapping: true,
              scrollDirection: Axis.horizontal,
              itemCount:
                  getSurahNumAyahs[SurahReaderPage.of(context).indexID - 1],
            ),
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

  void _cupertinoDialog() {
    String title = SurahReaderPage.of(context).surahTitle;
    int verse = _focusedIndex!.toInt() + 1;
    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text("Recording complete."),
              content: Text(
                  "Your audio recording for verse $verse of Surah $title is finished. Would you like to submit?"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text("Submit"),
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) => _userAvailabilityBuilder());
                  },
                ),
                CupertinoDialogAction(
                    child: Text("Cancel"),
                    onPressed: () => Navigator.pop(context),
                    isDefaultAction: true,
                    isDestructiveAction: true)
              ],
            ));
  }

  Widget _userAvailabilityBuilder() {
    return FutureBuilder<String>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!) {
            case "UserNotFound":
              return CupertinoAlertDialog(
                title: Text("User not found."),
                content: Text("Failed to find user by the email specified."),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: Text("OK"),
                      onPressed: () => Navigator.pop(context),
                      isDefaultAction: true,
                      isDestructiveAction: true)
                ],
              );
            case "InsufficientReciteBalance":
              return CupertinoAlertDialog(
                title: Text("Insufficient Recite Time balance."),
                content: Text(
                    "Your Recite time balance is insufficient for this submission.\nPlease topup and try again."),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: Text("OK"),
                      onPressed: () => Navigator.pop(context),
                      isDefaultAction: true,
                      isDestructiveAction: true)
                ],
              );
            case "Submitted":
              return CupertinoAlertDialog(
                title: Text("Submission successful."),
                content:
                    Text("Your audio recording has been submitted for review."),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: Text("OK"),
                      onPressed: () => Navigator.pop(context),
                      isDefaultAction: true,
                      isDestructiveAction: true)
                ],
              );
            case "Failed":
              return CupertinoAlertDialog(
                title: Text("Submission failed."),
                content: Text(
                    "Your audio recording failed to be submitted.\nRetry in a while or contact customer support."),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: Text("OK"),
                      onPressed: () => Navigator.pop(context),
                      isDefaultAction: true,
                      isDestructiveAction: true)
                ],
              );
            case "NotLoggedIn":
              return CupertinoAlertDialog(
                title: Text("Unauthorized submission."),
                content: Text(
                    "You have not logged into Recite account.\nPlease login to submit."),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: Text("OK"),
                      onPressed: () => Navigator.pop(context),
                      isDefaultAction: true,
                      isDestructiveAction: true)
                ],
              );
            case "ConnectionTimedOut":
              return CupertinoAlertDialog(
                title: Text("Connection timed out."),
                content: Text(
                    "Attempt to establish communication with the server failed.\nPlease try again later."),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: Text("OK"),
                      onPressed: () => Navigator.pop(context),
                      isDefaultAction: true,
                      isDestructiveAction: true)
                ],
              );
            case "NoInternet":
              return CupertinoAlertDialog(
                title: Text("No internet connection."),
                content: Text(
                    "Your device may not have an active internet connection.\nRecite feature requires an active internet."),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: Text("OK"),
                      onPressed: () => Navigator.pop(context),
                      isDefaultAction: true,
                      isDestructiveAction: true)
                ],
              );
            default:
              return CupertinoAlertDialog(
                title: Text("Unhandled exception occurred."),
                content: Text(
                    "The application had encountered an unhandled back-end error. Report the condition to developers if it persist."),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: Text("OK"),
                      onPressed: () => Navigator.pop(context),
                      isDefaultAction: true,
                      isDestructiveAction: true)
                ],
              ); //Unhandled exception
          }
        }
        if (snapshot.hasError) {
          return CupertinoAlertDialog(
            title: Text("Encountered Exception"),
            content: Text("Error: ${snapshot.error}"),
            actions: <Widget>[
              CupertinoDialogAction(
                  child: Text("OK"),
                  onPressed: () => Navigator.pop(context),
                  isDefaultAction: true,
                  isDestructiveAction: true)
            ],
          );
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
      future: _submissionToRecite(),
    );
  }

  Future<String> _submissionToRecite() async {
    final email = "fab072301@gmail.com";
    final userToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MGJiN2MzOWVkYmQyZTJiN2QwMWM3MGEiLCJpYXQiOjE2MjI4OTk3Njl9.4djAZoB1hDzHoWFDDAV_t_h5U5XwwC590fdzvRp5ESg";
    final chapter = (SurahReaderPage.of(context).indexID - 1).toString();
    final verse = (_focusedIndex!.toInt() + 1).toString();
    final submissionUrl = "dummy/uri/for/now";

    final userIsAvailable = await _checkUserAvailability(email);
    if (userIsAvailable is String) {
      return userIsAvailable;
    } else if (userIsAvailable) {
      final canSubmit = await _checkSubmissionPermission(email);
      if (canSubmit is String) {
        return canSubmit;
      } else if (canSubmit) {
        final submissionStatus =
            await _createSubmission(userToken, chapter, verse, submissionUrl);
        return submissionStatus;
      } else {
        return "InsufficientReciteBalance";
      }
    } else {
      return "UserNotFound";
    }
  }

  Future<dynamic> _checkUserAvailability(email) async {
    final url = "users/check",
        checkUserAvailability = CheckUserAvailability(email: email, url: url);
    try {
      final userIsAvailable = await checkUserAvailability
          .userIsAvailable()
          .timeout(Duration(seconds: 10));
      return userIsAvailable;
    } on TimeoutException catch (_) {
      return "ConnectionTimedOut";
    } on SocketException catch (_) {
      return "NoInternet";
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> _checkSubmissionPermission(email) async {
    final url = "users/canSubmit",
        getSubmissionPermission =
            GetSubmissionPermission(email: email, url: url);
    try {
      final canSubmit = await getSubmissionPermission.getSubmissionPermission();
      return canSubmit;
    } on TimeoutException catch (_) {
      return "ConnectionTimedOut";
    } on SocketException catch (_) {
      return "NoInternet";
    } catch (e) {
      throw e;
    }
  }

  Future<String> _createSubmission(
      userToken, chapter, verse, submissionUrl) async {
    final url = "recital",
        createSubmission = CreateSubmission(
            userToken: userToken,
            chapter: chapter,
            verse: verse,
            submissionUrl: submissionUrl,
            url: url);
    var submissionStatus;
    try {
      submissionStatus = await createSubmission.submissionStatus();
      return submissionStatus;
    } on TimeoutException catch (_) {
      return submissionStatus = "ConnectionTimedOut";
    } on SocketException catch (_) {
      return submissionStatus = "NoInternet";
    } catch (e) {
      throw e;
    }
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
        TextButton(
          onPressed: () => _popModalBottomSheet(context),
          child: RichText(
            text: TextSpan(
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                      text:
                          "${_focusedIndex!.toInt() + 1}/${getSurahNumAyahs[SurahReaderPage.of(context).indexID - 1]}"),
                  WidgetSpan(
                      child: Icon(Icons.arrow_drop_up_rounded,
                          color: Colors.black))
                ]),
          ),
        ),
        IconButton(
          onPressed: () {
            _nextPage();
          },
          icon: Icon(Icons.arrow_forward_ios_rounded),
        ),
      ],
    );
  }

  _popModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              boxShadow: [
                const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 14,
                    spreadRadius: 4,
                    offset: Offset(0, -5)),
              ]),
          height: 255,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                  child: _cupertinoSinglePicker(),
                  width: MediaQuery.of(context).size.width,
                  height: 200),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CupertinoButton(
                    child: Text("Confirm"),
                    onPressed: () => _pickerSetPage(),
                  ),
                  CupertinoButton(
                    child: Text("Return"),
                    onPressed: () => {Navigator.of(context).pop()},
                  ),
                ],
              )
            ],
          )),
    );
  }

  _cupertinoSinglePicker() {
    return CupertinoPicker(
      looping: true,
      itemExtent: 50,
      children: <Widget>[
        for (int i = 1;
            i <= getSurahNumAyahs[SurahReaderPage.of(context).indexID - 1];
            i++)
          Center(
              child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              i.toString(),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ))
      ],
      onSelectedItemChanged: (value) {
        _pickerNum = value;
      },
      scrollController:
          FixedExtentScrollController(initialItem: _focusedIndex!.toInt()),
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
