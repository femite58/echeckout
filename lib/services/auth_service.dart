import 'dart:convert';

import 'package:echeckout/services/config_service.dart';
import 'package:echeckout/services/header_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  late Client http;
  static final _auth = BehaviorSubject<Map?>.seeded(null);
  static final pinMsg = BehaviorSubject<Map?>.seeded(null);
  final String _baseUrl = ConfigService.baseUrl;
  AuthService() {
    http = InterceptedClient.build(
        interceptors: [HeaderInterceptor(_auth.stream.value)]);
    print(_auth.stream.value?['token']);
  }
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // final FlutterBackgroundService _serv = FlutterBackgroundService();
  static bool tempLogin = false;

  BehaviorSubject get auth {
    return _auth;
  }

  Future<dynamic> login(data) async {
    var res =
        await http.post(Uri.parse('${_baseUrl}login'), body: json.encode(data));
    if (res.statusCode == 422) {
      throw json.decode(res.body)['error'];
    }
    var auth = json.decode(res.body)['data'];
    return auth;
  }

  Future<dynamic> confirmPin(data) async {
    var res = await http.post(Uri.parse('${_baseUrl}user/account/pin/verify'),
        body: json.encode(data));
    if (res.statusCode == 422) {
      throw json.decode(res.body)['error'];
    }
    var auth = json.decode(res.body)['data'];
    return auth;
  }

  Future<dynamic> submitPIN(data) async {
    var res = await http.post(Uri.parse('${_baseUrl}user/account/pin/update'),
        body: json.encode(data));
    if (res.statusCode == 422) {
      throw json.decode(res.body)['error'];
    }
    var auth = json.decode(res.body)['data'];
    updateAuth(auth);
    return auth;
  }

  Future<dynamic> twoAuth(data) async {
    var res = await http.post(Uri.parse('${_baseUrl}login/verify'),
        body: json.encode(data));
    if (res.statusCode == 422) {
      throw json.decode(res.body)['error'];
    }
    var auth = json.decode(res.body)['data'];
    updateAuth(auth);
    return auth;
  }

  Future<dynamic> twoFaSet(data) async {
    var res = await http.post(
        Uri.parse('${_baseUrl}user/account-settings/set-two-factor'),
        body: json.encode(data));
    if (res.statusCode == 422) {
      throw json.decode(res.body)['error'];
    }
    var auth = json.decode(res.body)['data'];
    updateAuth(auth);
    return auth;
  }

  Future<dynamic> changePass(data) async {
    var res = await http.post(
        Uri.parse('${_baseUrl}user/account-settings/change-password'),
        body: json.encode(data));
    if (res.statusCode == 422) {
      throw json.decode(res.body)['error'];
    }
    var auth = json.decode(res.body);
    return auth;
  }

  Future<dynamic> signup(data) async {
    var res = await http.post(Uri.parse('${_baseUrl}register'),
        body: json.encode(data));
    if (res.statusCode == 422) {
      throw json.decode(res.body)['error'];
    }
    var auth = json.decode(res.body)['data'];
    updateAuth(auth);
    return auth;
  }

  Future<dynamic> verifyBvn(data) async {
    var res = await http.post(
        Uri.parse('${_baseUrl}user/account-settings/post-bvn'),
        body: json.encode(data));
    if (res.statusCode == 422) {
      throw json.decode(res.body)['error'];
    }
    var auth = json.decode(res.body)['data'];
    updateAuth(auth);
    return auth;
  }

  Future<dynamic> verifyEmail(data) async {
    var res = await http.post(
        Uri.parse('${_baseUrl}user/account-settings/email-verify'),
        body: json.encode(data));
    if (res.statusCode == 422) {
      throw json.decode(res.body)['error'];
    }
    var auth = json.decode(res.body)['data'];
    updateAuth(auth);
    return auth;
  }

  Future<dynamic> checkEmail(data) async {
    var res = await http.post(Uri.parse('${_baseUrl}forgot-password'),
        body: json.encode(data));
    if (res.statusCode == 422) {
      throw json.decode(res.body)['error'];
    }
    return json.decode(res.body)['data'];
  }

  Future<dynamic> verifyCode(data) async {
    var res = await http.post(
        Uri.parse('${_baseUrl}forgot-password/submit-token'),
        body: json.encode(data));
    if (res.statusCode == 422) {
      throw json.decode(res.body)['error'];
    }
    return json.decode(res.body)['data'];
  }

  Future<dynamic> forgotPassResendCode(data) async {
    var res = await http.post(Uri.parse('${_baseUrl}forgot-password/resend'),
        body: json.encode(data));
    if (res.statusCode == 422) {
      throw json.decode(res.body)['error'];
    }
    return json.decode(res.body)['data'];
  }

  Future<dynamic> forgotPassChangePass(data) async {
    var res = await http.post(
        Uri.parse('${_baseUrl}forgot-password/reset-password'),
        body: json.encode(data));
    if (res.statusCode == 422) {
      throw json.decode(res.body)['error'];
    }
    // return json.decode(res.body)['data'];
  }

  Future<dynamic> resendCode() async {
    var res = await http
        .get(Uri.parse('${_baseUrl}user/account-settings/resend-token'));
    return res.body;
  }

  updateAuth(auth) async {
    _auth.add(auth);
    SharedPreferences prefs = await _prefs;
    await prefs.setString('auth', json.encode(auth));
    // if (await _serv.isRunning()) {
    //   _serv.invoke('fetchAuth');
    // } else {
    //   _serv.startService();
    // }
  }

  Future<dynamic> updateProfile(data) async {
    var res = await http.post(
        Uri.parse('${_baseUrl}user/account-settings/profile'),
        body: json.encode(data));
    if (res.statusCode == 422) {
      throw json.decode(res.body)['error'];
    }
    var auth = json.decode(res.body)['data'];
    updateAuth(auth);
    return auth;
  }

  Future<dynamic> autoLogin() async {
    SharedPreferences prefs = await _prefs;
    await prefs.reload();
    var auth = prefs.getString('auth');
    if (auth == null) return null;
    _auth.add(json.decode(auth));
    return auth;
  }

  logout() async {
    SharedPreferences prefs = await _prefs;
    _auth.add(null);
    prefs.remove('auth');
    // _serv.invoke('stopService');
  }
}
