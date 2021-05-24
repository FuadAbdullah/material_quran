import 'package:flutter/material.dart';
import 'package:materialquran/controller/routes.dart';
import 'package:materialquran/loader/quranglobal.dart';

// Main Menu
// This page is the first menu
// a user will encounter
// All buttons leading to different
// pages are found here

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Material Quran"),
          centerTitle: true,
        ),
        body: HomePageContainer(),
        endDrawer: Container(
            width: getScreenSize(context),
            child: Drawer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/img/1.jpg',
                        fit: BoxFit.cover,
                      ),
                      Opacity(
                        opacity: 0.5,
                        child: Text("Material Quran",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.normal,
                            )),
                      ),
                    ],
                  ),
                  Container(
                    width: getScreenSize(context),
                    child: TextButton(
                      child: Text("About Us"),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AboutUsMenu(),
                          )),
                    ),
                  )
                ],
              ),
            )));
  }
}

class HomePageContainer extends StatelessWidget {
  const HomePageContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 100.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 0.5,
                    blurRadius: 7.0,
                    offset: Offset(0, 0))
              ]),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                height: 50,
                width: 300,
                child: ElevatedButton(
                  child: Text("Holy Quran"),
                  onPressed: () {},
                ),
              ),
              Divider(),
              Container(
                height: 50,
                width: 300,
                child: ElevatedButton(
                  child: Text("Surah Selection"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SurahSelectionMenu()));
                  },
                ),
              ),
              Divider(),
              Container(
                height: 50,
                width: 300,
                child: ElevatedButton(
                  child: Text("Search"),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ));
  }
}

// class HomePageContext extends InheritedWidget {
//   const HomePageContext({Key? key, required this.currentContext, required Widget child})
//       : super(key: key, child: child);
//
//   final BuildContext currentContext;
//
//   static HomePageContext of(BuildContext context) {
//     final HomePageContext? result = context.dependOnInheritedWidgetOfExactType<HomePageContext>();
//     assert(result != null, "No Context Found for this Scaffold!");
//     return result!;
//   }
//
//   @override
//   bool updateShouldNotify(HomePageContext old) => currentContext != old.currentContext;
// }
