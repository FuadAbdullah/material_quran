import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:arabic_numbers/arabic_numbers.dart';


class QuranAPICall {
  QuranAPICall(
      {@required this.domain,
      @required this.reqUrl,
      this.selectedSurah,
      this.excludedText});

  final domain, reqUrl, selectedSurah, excludedText;

  // Getters
  getDomain() => this.domain;

  getReqUrl() => this.reqUrl;

  getSelectedSurah() => this.selectedSurah;

  getExcludedText() => this.excludedText;

  Future<http.Response> getContent() =>
      http.get(Uri.https(getDomain(), getReqUrl()));

  Future<Surah> loadSurah() async {
    final res = await getContent();
    return checkAPICallResponse(res);
  }

  // Future<SurahList> loadSurahList() async {
  //   final res = await getContent();
  //   if (res.statusCode == 200) {
  //     return SurahList.fromJson(json.decode(res.body));
  //   } else {
  //     throw Exception("Failed to load surah list!");
  //   }
  // }

  Future<SurahList> surahInfoJson() async {
    final res = await getContent();
    if (res.statusCode == 200) {
      return SurahList.fromJson(json.decode(res.body));
    } else {
      throw Exception("Failed to load surah list!");
    }
  }

  checkAPICallResponse(res) {
    if (res.statusCode == 200) {
      var surah = Surah.fromJson(json.decode(res.body));
      if (getSelectedSurah() != 1) {
        surah.verses[0]['text'] =
            textExcluder(surah.verses[0]['text'], getExcludedText());
      }
      return surah;
    } else {
      throw Exception("Failed to load surah!");
    }
  }

  textExcluder(parentText, String target) => parentText.replaceAll(target, "");
}

class Surah {
  int? code;
  String? status;
  var verses;
  var title;
  var titleEn;
  var numberOfAyat;

  Surah(
      {@required this.code,
      @required this.status,
      @required this.verses,
      @required this.title,
      @required this.titleEn,
      @required this.numberOfAyat});

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
        code: json['code'],
        status: json['status'],
        verses: json['data']['ayahs'],
        title: json['data']['name'],
        titleEn: json['data']['englishName'],
        numberOfAyat: json['data']['numberOfAyahs']);
  }
}

class SurahList {
  int? code;
  String? status;
  var data;

  SurahList({@required this.code, @required this.status, @required this.data});

  factory SurahList.fromJson(Map<String, dynamic> json) {
    return SurahList(
        code: json['code'], status: json['status'], data: json['data']);
  }
}
