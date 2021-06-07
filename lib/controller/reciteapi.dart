import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class ReciteAPI {
  // TODO
  String userToken,
      username,
      email,
      password,
      chapter,
      verse,
      submissionUrl,
      domain,
      url;

  ReciteAPI(
      {this.userToken = "randomtoken",
      this.username = 'abc123',
      this.email = 'abc123@gmail.com',
      this.password = 'tQB4xj0tLd',
      this.chapter = '1',
      this.verse = '1',
      this.submissionUrl = 'dummy/url/no/actual/data',
      this.domain = '192.168.0.69:3000',
      this.url = 'users/check?email=abc123@gmail.com'});

  String get getUserToken => userToken;

  String get getUsername => username;

  String get getEmail => email;

  String get getPassword => password;

  String get getChapter => chapter;

  String get getVerse => verse;

  String get getSubmissionUrl => submissionUrl;

  String get getDomain => domain;

  String get getUrl => url;

  set setUserToken(userToken) => this.userToken = userToken;

  set setUsername(username) => this.username = username;

  set setEmail(email) => this.email = email;

  set setPassword(password) => this.password = password;

  set setChapter(chapter) => this.chapter = chapter;

  set setVerse(verse) => this.verse = verse;

  set setSubmissionUrl(submissionUrl) => this.submissionUrl = submissionUrl;

  set setDomain(domain) => this.domain = domain;

  set setUrl(url) => this.url = url;

  // Currently set to HTTP protocol due to local hosting
  Future<http.Response> get(Map<String, String> paramList) =>
      http.get(Uri.http(getDomain, getUrl, paramList));

  // Currently set to HTTP protocol due to local hosting
  Future<http.Response> post(String body, Map<String, String> header) =>
      http.post(Uri.http(getDomain, getUrl), body: body, headers: header);
}

// Tested and working
class CheckUserAvailability extends ReciteAPI {
  // DEBUG DOMAIN = 192.168.0.69:3000, locally hosted
  // DEBUG URL = users/check?email=fab072301@gmail.com

  @override
  @override
  final String email, url;

  CheckUserAvailability({required this.email, required this.url})
      : super(email: email, url: url);

  Future<dynamic> userIsAvailable() async {
    final paramList = {'email': getEmail};
    final response = await get(paramList).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      return true;
    }
    if (response.statusCode == 404) {
      return false;
    }
    return 'Unhandled exception occurred!';
  }
}

// Tested and working
class CreateUser extends ReciteAPI {
  @override
  @override
  @override
  @override
  final String username, email, password, url;

  CreateUser(
      {required this.username,
      required this.email,
      required this.password,
      required this.url})
      : super(username: username, email: email, password: password, url: url);

  Future<String> creationStatus() async {
    final _body =
        '{ "username": "$getUsername", "email": "$getEmail", "password": "$getPassword" }';
    final _header = {'Content-Type': 'application/json'};
    final response = await post(_body, _header);
    if (response.statusCode == 201) {
      return 'User account is successfully created';
    }
    if (response.statusCode == 400) {
      return 'Failed to create user account';
    }
    return 'Unhandled exception occurred!';
  }
}

// Untested
class LoginUser extends ReciteAPI {
  // TODO
}

// Untested
class LogoutUser extends ReciteAPI {
  // TODO
}

// Untested
class LoadUserProfile extends ReciteAPI {
  // TODO
}

// Tested and working
class GetReciteTime extends ReciteAPI {
  // DEBUG DOMAIN = 192.168.0.69:3000, locally hosted
  // DEBUG URL = users/getbalance?email=fab072301@gmail.com
  @override
  @override
  final String email, url;

  GetReciteTime({required this.email, required this.url})
      : super(email: email, url: url);

  Future<String> getReciteTime() async {
    final paramList = {'email': getEmail};
    final response = await get(paramList);
    if (response.statusCode == 200) {
      final reciteTime = (double.parse(response.body) ~/ 60);
      return '$reciteTime';
    }
    if (response.statusCode == 404) {
      return 'User not found';
    }
    return 'Unhandled exception occurred!';
  }
}

// Tested and working
class GetSubmissionPermission extends ReciteAPI {
  // DEBUG DOMAIN = 192.168.0.69:3000, locally hosted
  // DEBUG URL = users/canSubmit?email=fab072301@gmail.com
  @override
  @override
  final String email, url;

  GetSubmissionPermission({required this.email, required this.url})
      : super(email: email, url: url);

  Future<dynamic> getSubmissionPermission() async {
    final paramList = {'email': getEmail};
    final response = await get(paramList);
    if (response.statusCode == 200) {
      final canSubmit = response.body.parseBool();
      return canSubmit;
    }
    if (response.statusCode == 404) {
      return 'User not found';
    }
    return 'Unhandled exception occurred!';
  }
}

// Testing and working
class CreateSubmission extends ReciteAPI {
  @override
  @override
  @override
  @override
  final String userToken, chapter, verse, submissionUrl, url;

  CreateSubmission(
      {required this.userToken,
      required this.chapter,
      required this.verse,
      required this.submissionUrl,
      required this.url})
      : super(
            userToken: userToken,
            chapter: chapter,
            verse: verse,
            submissionUrl: submissionUrl,
            url: url);

  Future<String> submissionStatus() async {
    final _body =
        '{ "chapter": "$chapter", "verse": "$verse", "submissionURI": "$submissionUrl" }';
    final _header = {
      'Content-Type': 'application/json',
      'Authorization': '$userToken'
    };
    final response = await post(_body, _header);
    if (response.statusCode == 200) {
      return 'Submitted';
    }
    if (response.statusCode == 400) {
      return 'Failed';
    }
    if (response.statusCode == 401) {
      return 'NotLoggedIn';
    }
    return 'Unhandled exception occurred!';
  }
}

// Abstract
abstract class ReciteException {
  // TODO
}

// Untested
class ReciteUnhandled extends ReciteException {
  // TODO
}

// Untested
class ReciteNoSuchUser extends ReciteException {
  // TODO
}

// Untested
class ReciteAccountCreationFailed extends ReciteException {
  // TODO
}

// To parse boolean body response
extension BoolParse on String {
  bool parseBool() {
    return toLowerCase() == 'true';
  }
}
