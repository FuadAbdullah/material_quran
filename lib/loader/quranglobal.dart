import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

List _surahNo = [],
    _surahName = [],
    _surahNameEn = [],
    _surahNameAr = [],
    _surahOrigin = [],
    _surahNumAyahs = [],
    _surahDescEn = [];

Future<void> getLocalQuranInfo() async {
  final String response =
      await rootBundle.loadString('assets/json/surahinfo.json');
  final data = json.decode(response);
  for (int i = 0; i < 114; i++) {
    _surahNo.add(data['data'][i]['number']);
    _surahNameAr.add(data['data'][i]['name']);
    _surahName.add(data['data'][i]['englishName']);
    _surahNameEn.add(data['data'][i]['englishNameTranslation']);
    _surahNumAyahs.add(data['data'][i]['numberOfAyahs']);
    _surahOrigin.add(data['data'][i]['revelationType']);
    _surahDescEn.add(data['data'][i]['englishDescription']);
    // FOR DEBUG ONLY
    // print(
    //     "${_surahNo.elementAt(i)} ${_surahNameAr.elementAt(i)} ${_surahName.elementAt(i)} ${_surahNameEn.elementAt(i)} ${_surahNumAyahs.elementAt(i)} ${_surahOrigin.elementAt(i)}");
  }
}

// Returns 70% of the original screen size
double getScreenSize(BuildContext context) =>
    MediaQuery.of(context).size.width * 0.70;

// Convert English numerals to Arabic
String getArabicNumber(String enNumber) {
  final enNumerals = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  final arNumerals = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  for (int i = 0; i < 10; i++) {
    enNumber = enNumber.replaceAll(RegExp(enNumerals[i]), arNumerals[i]);
  }

  return enNumber;
}

List get getSurahNo => _surahNo;

List get getSurahName => _surahName;

List get getSurahNameEn => _surahNameEn;

List get getSurahNameAr => _surahNameAr;

List get getSurahOrigin => _surahOrigin;

List get getSurahNumAyahs => _surahNumAyahs;

List get getSurahDescEn => _surahDescEn;
