import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuranAPICall {
  var domain, reqUrl, selectedSurah, excludedText;

  // Getters Setters
  get getDomain => this.domain;

  get getReqUrl => this.reqUrl;

  get getSelectedSurah => this.selectedSurah;

  get getExcludedText => this.excludedText;

  set setDomain(domain) => this.domain = domain;

  set setReqUrl(reqUrl) => this.reqUrl = reqUrl;

  set setSelectedSurah(selectedSurah) => this.selectedSurah = selectedSurah;

  set setExcludedText(excludedText) => this.excludedText = excludedText;

  Future<http.Response> getContent() =>
      http.get(Uri.https(getDomain, getReqUrl));

  Future<Surah> loadSurah() async {
    final res = await getContent();
    return checkAPICallResponse(res);
  }

  checkAPICallResponse(res) {
    if (res.statusCode == 200) {
      var surah = Surah.fromJson(json.decode(res.body));
      if (getSelectedSurah != 1) {
        surah.verses[0]['text'] =
            textExcluder(surah.verses[0]['text'], getExcludedText);
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
