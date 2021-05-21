import 'package:flutter/services.dart';
import 'dart:convert';

List surahNo = [],
    surahName = [],
    surahNameEn = [],
    surahNameAr = [],
    surahOrigin = [],
    surahNumAyahs = [];

Future<void> getLocalQuranInfo() async {
  final String response =
      await rootBundle.loadString('assets/json/surahinfo.json');
  final data = json.decode(response);
  for (int i = 0; i < 114; i++) {
    surahNo.add(data['data'][i]['number']);
    surahNameAr.add(data['data'][i]['name']);
    surahName.add(data['data'][i]['englishName']);
    surahNameEn.add(data['data'][i]['englishNameTranslation']);
    surahNumAyahs.add(data['data'][i]['numberOfAyahs']);
    surahOrigin.add(data['data'][i]['revelationType']);
    print(
        "${surahNo.elementAt(i)} ${surahNameAr.elementAt(i)} ${surahName.elementAt(i)} ${surahNameEn.elementAt(i)} ${surahNumAyahs.elementAt(i)} ${surahOrigin.elementAt(i)}");
  }
}

List get getSurahNo => surahNo;

List get getSurahName => surahName;

List get getSurahNameEn => surahNameEn;

List get getSurahNameAr => surahNameAr;

List get getSurahOrigin => surahOrigin;

List get getSurahNumAyahs => surahNumAyahs;
